require 'securerandom'

module Generator

  class StringGenerator
  
    attr_reader :uuid
    attr_reader :alpha
    attr_reader :alpha_numeric
    attr_reader :numeric

  	def initialize(seed = nil)
      seed = Random.new_seed if seed.nil?
  	  @prng = Random.new(seed)

      @alpha_list = [('a'..'z').to_a, ('A'..'Z').to_a].flatten
      @numeric_list = ('0'..'9').to_a
      @alpha_numeric_list = [@alpha_list, @numeric_list].flatten
  	end

    def generate(length=1)

      #puts @alpha_list.inspect
      #puts @alpha_numeric_list.inspect
      #puts @numeric_list.inspect

      @alpha = ""
      @uuid = ""
      @alpha_numeric = ""
      @numeric = ""
      @uuid = SecureRandom.uuid

      length.times do
        @alpha << sample(@alpha_list)
        @numeric << sample(@numeric_list)
        @alpha_numeric << sample(@alpha_numeric_list)
      end

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