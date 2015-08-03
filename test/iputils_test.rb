require 'rubygems'
require 'bundler/setup'

require './../lib/iputils'
include IpUtils


str = '192.0.131.1'
puts 'ERROR' if not /^[0-9\.]+$/ === str



# puts str ===


# octets = str.split(".").map{|i| i.to_i}
#
#
# puts octets.min

=begin


addr1 = Ipv4Address.new('192.168.1.1')
addr2 = Ipv4Address.new('192.168.1.1')

puts Ipv4Address.new('255.255.255.255').to_i

puts addr1.to_s
puts addr1.to_i

puts addr1.next.to_s
puts addr1.prev.to_s



=begin
puts '===='

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