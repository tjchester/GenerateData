require_relative 'gendata/version.rb'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file
# Load data generators
Dir[File.dirname(__FILE__) + "/generator/*.rb"].each { |file| require file }

# Load datasource modules
Dir[File.dirname(__FILE__) + "/datasource/*.rb"].each { |file| require file }

# Load helper modules
Dir[File.dirname(__FILE__) + "/helpers/*.rb"].each { |file| require file }
