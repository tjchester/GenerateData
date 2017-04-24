require 'rubygems'
require 'active_record'

module Datasource

	class ActiveRecordInterface

		def initialize(config)
      #puts config

		  ActiveRecord::Base.establish_connection(
		  	:adapter => config["adapter"],
		  	:host => config["host"],
		  	:database => config["database"],
		  	:username => config["username"],
		  	:password => config["password"],
        :sslca => config["sslca"],
        :sslcert => config["sslcert"],
        :sslkey => config["sslkey"]
		  )
		end

		def table_list()
		  tables = {}
		  ActiveRecord::Base.connection.tables.each do |table|
		  	tables[table] = { 
		  		:records_to_load => 0,
		  		:truncate_before_load => false
		  	}
		  end
		  tables
		end

		def column_list(table_name)
		  columns = {}
		  ActiveRecord::Base.connection.columns(table_name).each do |column|
		  	columns[column.name] = {
		  		:precision => column.precision,
		  		:scale => column.scale,
		  		:limit => column.limit,
		  		:sql_type => column.sql_type,
		  		:null => column.null,
		  		:default => column.default,
		  		:generator => "ignore_generator"
		  	}
		  end
		  columns
		end

		def model_list(rails_model_path)
			models = {}
			Dir[rails_model_path + "/*.rb"].each do |model_file|
				require model_file

				basename  = File.basename(model_file, File.extname(model_file))
  				models[basename.camelize] = { :klass => basename.camelize.constantize }
			end
			models
		end

	end

end