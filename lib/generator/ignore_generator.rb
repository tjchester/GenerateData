module Generator

  class IgnoreGenerator

    def initialize(seed=nil)
      seed = Random.new_seed if seed.nil?
      @prng = Random.new(seed)
    end

    def generate
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