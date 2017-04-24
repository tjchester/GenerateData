module Generator

  class NameGenerator
  
    attr_reader :first_name
    attr_reader :middle_name
    attr_reader :last_name
    attr_reader :suffix
    attr_reader :gender
    attr_reader :gender_name
    attr_reader :middle_initial

  	def initialize(seed=nil, gender=nil, culture='en-us')
  	  seed = Random.new_seed if seed.nil?
      @prng = Random.new(seed)

      data_dir = File.dirname(__FILE__) + "/data/#{culture}/"

      @fnames_male = File.readlines("#{data_dir}popular_male_first_names.txt")
      @mnames_male = File.readlines("#{data_dir}popular_male_first_names.txt")

      @fnames_female = File.readlines("#{data_dir}popular_female_first_names.txt")
      @mnames_female = File.readlines("#{data_dir}popular_female_first_names.txt")

      @lnames = File.readlines("#{data_dir}common_northamerican_surnames.txt")

      @suffix_male = File.readlines("#{data_dir}common_male_suffixes.txt")
  	end

    def generate
      @gender = ["m","f"].shuffle[0] if gender == nil

      if "m" == @gender.downcase

        @first_name = sample(@fnames_male)
        @middle_name = sample(@mnames_male)
        @suffix = sample(@suffix_male)
        @gender_name = 'Male'
      
      else

        @first_name = sample(@fnames_female)
        @middle_name = sample(@mnames_female)
        @gender_name = 'Female'

      end 

      @middle_initial = @middle_name[0]
      @last_name = sample(@lnames)

      # Return a link to the object so that methods can be chained
      self
    end

  private

    def sample(list)
      # Isolate random sampling so that all values use the 
      # same (repeatable) seed value if specified
      list[@prng.rand(list.length)]
    end

  end
end