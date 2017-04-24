module Generator
  
  class DateGenerator

    attr_reader :date
    attr_reader :datetime

    def initialize(seed=nil)
      seed = Random.new_seed if seed.nil?
      @prng = Random.new(seed)
    end

    def generate(min_value=nil, max_value=nil)
      low_value = '1900-01-01' if min_value.nil?
      high_value = DateTime.now.strftime("%Y-%m-%d") if max_value.nil?

      #puts "DateGenerator.generate low_value=#{low_value}"
      #puts "DateGenerator.generate high_value=#{high_value}"

      @date = date_value(low_value, high_value)
      @datetime = datetime_value(low_value, high_value)

      # Return a link to the object so that methods can be chained
      self
    end

  private

    def sample(list)
      # Isolate random sampling so that all values use the 
      # same (repeatable) seed value if specified
      list[@prng.rand(list.length)]
    end

    def datetime_value(low_value, high_value)
      hour = sample((0..23).to_a)
      minute = sample((0..59).to_a)
      second = sample((0..60).to_a)

      min_date = DateTime.parse(low_value + " #{hour}:#{minute}:#{second}")
      max_date = DateTime.parse(high_value)

      min_date + @prng.rand(max_date - min_date) 
    end

    def date_value(low_value, high_value)
      min_date = Date.parse(low_value)
      max_date = Date.parse(high_value)

      min_date + @prng.rand(max_date - min_date) 
    end

  end
  
end