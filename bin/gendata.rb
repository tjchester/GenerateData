#!/usr/bin/env ruby

require 'optparse'
require_relative '../lib/gendata.rb'

config_dir = File.dirname(__FILE__) + "/../config/"

if !File.directory?(config_dir)
  Dir.mkdir(config_dir)
end


options = {}
option_parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby gendata.rb [options]"

  opts.on("--rails-app-path PATH", "Full path to top level folder of rails app") do |path|
  	options[:rails_path] = path
  end

  opts.on("--rails-env ENV", "One of 'development', 'test', or 'production'") do |env|
    options[:rails_env] = env
  end

  opts.on("--list-tables", "Generate a list of tables in the database") do 
  	options[:list_tables] = true
  end

  opts.on("--list-columns", "Generate a list of columns for each table in the database") do
  	options[:list_columns] = true
  end

  opts.on("--generate-data", "Generate data and load it into tables in the database") do
  	options[:generate_data] = true
  end

  opts.on("--seed SEED", "Use specified number to seed generators") do |seed|
    options[:seed] = seed.to_i
  end    

  opts.on("-v", "--verbose", "Prints extra messages as program runs") do
    options[:verbose] = true
  end

  opts.on("--ssl-ca-cert CERT") do |cert|
    options["sslca"] = cert
  end

  opts.on("--ssl-client-cert CERT") do |cert|
    options["sslcert"] = cert
  end

  opts.on("--ssl-client-key CERT") do |cert|
    options["sslkey"] = cert
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end
option_parser.parse!

if options[:verbose] 
  puts "Command line options used #{options.inspect}"
end

if options.length == 0
  puts option_parser.help
  exit
end

if options[:list_tables] || options[:list_columns] || options[:generate_data]
  if !options[:rails_env]
    raise "You must specify a RAILS_ENV value for any database options"
  end
end

# handle --rails-app-path
if options[:rails_path]
  if File.directory?(options[:rails_path])
    Helpers::Configuration.save(options[:rails_path], config_dir, "config")
  else
  	raise "Unable to verify specified rails folder."
  end
  exit
end

# the config.yml file will be needed for the rest of the script,
# so make sure it exists first before proceeding
if Helpers::Configuration.exist?(config_dir, "config") 
  rails_path = Helpers::Configuration.load(config_dir, "config") 

  rails_database_config = Helpers::Configuration.load(rails_path + "/config/", "database")

  rails_env_config = rails_database_config[options[:rails_env]]

  if rails_env_config["adapter"] == "sqlite3"
    rails_env_config["database"] = rails_path + rails_env_config["database"]
  end

  if options["sslca"]
    rails_env_config["sslca"] = options["sslca"]
    rails_env_config["sslcert"] = options["sslcert"]
    rails_env_config["sslkey"] = options["sslkey"]
  end

  ds = Datasource::ActiveRecordInterface.new(rails_env_config)
else
  raise "Unable to locate config file, did you forget to run --rails-app-path option"
end


# handle --list-tables
if options[:list_tables]
  Helpers::Configuration.save(ds.table_list, config_dir, "tables")
  exit
end

# the tables.yml file will be needed for the rest of the script,
# so make sure it exists first before proceeding
if Helpers::Configuration.exist?(config_dir, "tables")
  tables = Helpers::Configuration.load(config_dir, "tables")
else
  raise "Unable to locate tables config file, did you forget to run --list-tables option"
end


# handle --list-columns
if options[:list_columns]
  tables.each do |table, options|
  	if table != 'schema_migrations'
  	  column_info = ds.column_list(table)
  	  Helpers::Configuration.save(column_info, config_dir, table)
    end
  end
  exit
end


# at least one column information configuration file will be needed
# for the rest of the script, so make sure it exists first before
# proceeding
if !Helpers::Configuration.any?(config_dir, ["config.yml", "tables.yml"])
  raise "Unable to locate column config file(s), did you forget to run --list-columns option"
end

if !options[:seed]
  options[:seed] = Random.new_seed
end
puts "Generators seeded with value #{options[:seed]}" 

# handle --generate-data
if options[:generate_data]
  tables = tables.each.select { |table,options| options[:records_to_load] > 0}

  if !tables.any?
  	raise "You must edit the tables.yml file to include at least one table with a records_to_load property greater than zero."
  end

  # using the rails_path load up the model files because
  # that is what we are going to use to populate the 
  # database with
  models = ds.model_list(rails_path + "/app/models")

  # initialize and seed the generators once
  address_generator = Generator::AddressGenerator.new(options[:seed])
  constant_generator = Generator::ConstantGenerator.new(options[:seed])
  date_generator = Generator::DateGenerator.new(options[:seed])
  ignore_generator = Generator::IgnoreGenerator.new(options[:seed])
  name_generator = Generator::NameGenerator.new(options[:seed])
  number_generator = Generator::NumberGenerator.new(options[:seed])
  string_generator = Generator::StringGenerator.new(options[:seed])

  # loop through each table in our list
  tables.each do |table, options|

 	  puts "Starting to process #{table}..."

  	# identify the model file that corresponds to the current table
    model = models.detect { 
    	|model, options| options[:klass].table_name == table
    }[1][:klass]

    if model == nil
      raise "Unable to identify Rails model that corresponds to the #{table} table."
    end

    # check to see if we are supposed to truncate table first
    if options[:truncate_before_load]
      puts "  Deleting all rows from #{table}..."
      model.delete_all
    end

  	# load up the column configuration table for this table
	  columns = Helpers::Configuration.load(config_dir, table)

	  # filter the column list to only those with assigned data generators
	  columns = columns.reject { |column, options| options[:generator] == "ignore_generator"}

	  if !columns.any?
	    raise "You must edit the #{table}.yml file to include at least one column with a generator not set to the IgnoreGenerator"
    end

    # loop through adding X number of table records specifed
    x = 0
  	options[:records_to_load].times do
    
      address_generator.generate
      constant_generator.generate('')
      date_generator.generate
      ignore_generator.generate
      name_generator.generate
      number_generator.generate
      string_generator.generate(5)

      x += 1

      puts "  Loading record #{x} of #{options[:records_to_load]}"

      # initialize a new ActiveRecord for the current table
  	  record = model.new

      # loop through each column that has an assigned generator
	    columns.each do |column, options|
  	    #puts "    Processing column #{column}"
        generator = options[:generator]
        #puts "      Using generator #{generator}"
		    record[column] = eval(generator)
   	  end

   	  # save record to the database
	    record.save
	  end
  	puts "Finished loading #{table}"
  end
end
