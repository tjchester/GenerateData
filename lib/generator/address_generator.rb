require 'CSV'

module Generator

  class AddressGenerator

    attr_reader :street
    attr_reader :city
    attr_reader :state_name
    attr_reader :state_abbrev
    attr_reader :zipcode
    attr_reader :email
    attr_reader :phone

  	def initialize(seed=nil, culture='en-us')
      seed = Random.new_seed if seed.nil?

  	  @prng = Random.new(seed)
  	
  	  data_dir = File.dirname(__FILE__) + "/data/#{culture}/"
  	  
      @states = CSV.readlines("#{data_dir}us_states_and_capitals.csv")
      @nouns = File.readlines("#{data_dir}common_english_nouns.txt")
      @street_suffixes = File.readlines("#{data_dir}street_suffix_names.txt")
      @domains = File.readlines("#{data_dir}internet_domains.txt")
  	end

    def generate
      state_record = sample(@states)

      @street = street_address_value
      @city = state_record[2]
      @state_name  = state_record[0]
      @state_abbrev = state_record[1]
      @zipcode = zipcode_value
      @email = email_address_value
      @phone = phone_number_value

      # Return a link to the object so that methods can be chained
      self
    end


  private

    def sample(list)
      # Isolate random sampling so that all values use the 
      # same (repeatable) seed value if specified
      list[@prng.rand(list.length)]
    end

    def email_address_value()
      # Create an email address: bird02@google.com

      "#{sample(@nouns).strip.downcase}" + 
      "#{sample((0..100).to_a)}" + 
      "@#{sample(@domains).strip.downcase}"
    end

    def phone_number_value()
      # Create a phone number: 123-456-7890

      value = ""
      3.times { value << "#{sample((1..9).to_a)}" }
      value << "-"
      3.times { value << "#{sample((1..9).to_a)}" }
      value << "-"
      4.times { value << "#{sample((0..9).to_a)}" }
      value
    end

    def street_address_value()
      # Create a street address: 10 Lake Canyon

      "#{sample((1..100).to_a)} " +
      "#{sample(@nouns).strip.capitalize} " + 
      "#{sample(@street_suffixes).strip.capitalize}"
    end

    def zipcode_value()
      # Create a US zipcode: 16012

      zipcode = ""
      5.times do 
        zipcode << sample((0..9).to_a).to_s
      end 
      zipcode
    end

  end

end