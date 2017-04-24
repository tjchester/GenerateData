#!/usr/bin/env ruby

require 'optparse'
require_relative '../lib/gendata.rb'

puts "Sampling address information"
@prng = Generator::AddressGenerator.new(5).generate

puts @prng.street
puts @prng.city
puts @prng.state_name
puts @prng.state_abbrev
puts @prng.zipcode
puts @prng.email
puts @prng.phone

puts Generator::AddressGenerator.new(5).generate.city

puts "\nSampling constant information"
@prng = Generator::ConstantGenerator.new(5).generate("VALUE")

puts @prng.value


puts "\nSampling date information"
@prng = Generator::DateGenerator.new(5).generate

puts @prng.date
puts @prng.datetime

puts "\nSampling name information"

@prng = Generator::NameGenerator.new(5).generate

puts @prng.first_name
puts @prng.middle_name
puts @prng.last_name
puts @prng.suffix
puts @prng.gender

puts "\nSampling number information"
@prng = Generator::NumberGenerator.new(5).generate

puts @prng.integer
puts @prng.decimal

puts Generator::NumberGenerator.new(5).generate.integer

puts "\nSampling string information"
@prng = Generator::StringGenerator.new(5).generate(5)

puts @prng.uuid
puts @prng.alpha
puts @prng.numeric
puts @prng.alpha_numeric




