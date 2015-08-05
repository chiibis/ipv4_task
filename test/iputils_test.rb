require 'rubygems'
require 'bundler/setup'

require './../lib/iputils'
include IpUtils

# TODO: obsolete draft file. Remove it when features are ready.


# addr = Ipv4Address.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')
# puts addr.to_s


str = '2001:db8::ae21:ad12'
#  2001:0db8:0000:0000:0000:0000:ae21:ad12

# str.gsub! '::', ':0000:'


# puts parts


parts = str.split('::')
missing_hextets_count = 8

parts.each { |part| missing_hextets_count -= part.split(':').length }
missing_part = ':0000:' * missing_hextets_count

str.gsub! '::', missing_part
str.gsub! '::',':'
str.sub!(/^:/, '').sub!(/:$/,'')

puts str

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