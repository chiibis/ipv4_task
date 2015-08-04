require 'rubygems'
require 'bundler/setup'

require './../lib/iputils'
include IpUtils

addr2 = Ipv4Address.new(11)
puts addr2.next

addr1 = Ipv6Address.new(340282366920938463463374607431768211455)
puts addr1.to_s

addr1 = Ipv6Address.new(42540766416740939402060931394078537309)
puts addr1.to_s



addr1 = Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d')
puts addr1.to_i



=begin

addr1 = Ipv4Address.new("127.0.0.126")
addr2 = Ipv4Address.new("127.0.0.128")


puts addr2 - addr1
puts addr1 + (addr2 - addr1)
puts addr2 > addr1

puts '===='

subnet = Subnet.new(addr1, addr2)
puts subnet.to_s
puts subnet.includes?(addr1)
puts subnet.includes?(addr1.prev)
puts subnet.includes?(addr1.next)

puts '===='

puts (addr1..addr2).to_subnet.split_on(4)

addr_last = Ipv4Address.new("255.255.255.255")
puts addr_last
puts 'finish'

=end