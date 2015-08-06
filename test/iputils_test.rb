require 'rubygems'
require 'bundler/setup'

require './../lib/iputils'
include IpUtils

# TODO: obsolete draft file. Remove it when features are ready.


f = DummyAddress.new(0)
l = DummyAddress.new(8)

subnet = Subnet.new(f,l)
# puts subnet

parts = 4



if subnet.size % parts == 0
  part_size = subnet.size / parts
else
  part_size = subnet.size / (parts - 1)
end


subnets = []
iter = subnet.first

parts.times do
  iter_next = iter + (part_size - 1)

  # last part should be smaller
  iter_next = subnet.last if iter_next > subnet.last
  subnets << Subnet.new(iter, iter_next)
  iter = iter_next + 1

end


puts subnets