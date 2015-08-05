require 'rubygems'
require 'bundler/setup'

require './../lib/iputils'
include IpUtils

# TODO: obsolete draft file. Remove it when features are ready.


f = DummyAddress.new(0)
l = DummyAddress.new(4)

subnet = Subnet.new(f,l)
puts subnet

puts subnet.size

ssnets = subnet.split_on(5)

puts ssnets


