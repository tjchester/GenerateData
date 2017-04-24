module Generator
  
  class NumberGenerator
  
    attr_reader :integer
    attr_reader :decimal

    def initialize(seed=nil)
      seed = Random.new_seed if seed.nil?
      @prng = Random.new(seed)
    end

    def generate(min_value=0.0, max_value=32767.0)
      @decimal = sample(min_value, max_value)
      @integer = @decimal.to_i


      # Return a link to the object so that methods can be chained
      self
    end

  private

    def sample(low_value, high_value)
      # Isolate random sampling so that all values use the 
      # same (repeatable) seed value if specified
      low_value + @prng.rand(high_value) 
    end

  end
  
end