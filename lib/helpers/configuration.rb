require 'yaml'

module Helpers
  class Configuration

  	def self.load(config_dir, config_file)
  	  YAML.load(File.read(config_dir + config_file + ".yml"))
    end

  	def self.save(contents, config_dir, config_file)
  	  File.open(config_dir + config_file + ".yml", "w") { 
  	    |file| file.write(YAML.dump(contents))
  	  }
  	end

    def self.exist?(config_dir, config_file)
      File.exist?(config_dir + config_file + ".yml")
    end

    def self.any?(config_dir, exclude_list)
      Dir[config_dir + "*.yml"].reject { 
        |file| exclude_list.include? File.basename(file) 
        }.length > 0    
    end

  end
end