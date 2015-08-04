# Represents subnet of addresses (ip or mac, does not matter)
# Address object shall implement following methods:
# - comparison: addr1 < addr2, addr2 <= addr1
# - converting to Range: addr1..addr2
# - add numer: addr1 + 4
# - subtract one from another: addr2-addr1
# - conversion to string: addr1.to_s
class Subnet
  include Enumerable

  # Returns first and last elements of subnet. Last is guarantely >= first
  attr_reader :first, :last

  # Creates instance of subnet. Makes sure that last >= first, otherwise shall swap them
  def initialize(first, last)
    #TODO should we check both args has the same type?

    if last >= first
      @first = first
      @last = last
    else
      @first = last
      @last = first
    end
  end

  # Returns true if specified address is included into subnet
  def includes?(addr)
    first < addr and addr <= last
  end

  # Returns true if there are ip addresses which present in both this and provided subnets
  def intersects?(subnet)
    includes? subnet.first or includes? subnet.last
  end

  # Iterates over all addresses
  def each
    (@first..@last).each {|addr| yield addr}
  end

  # Returns an array of <c>parts</c> subnets. All subnets except last shall have same size, last one could be smaller.
  # All ip addresses from this subnet shall be used in the returned subnets set
  def split_on(parts)

    raise ArgumentError.new("Parts should be FixNum.") if not parts.is_a? Integer
    raise ArgumentError.new("Subnet has #{size} elements only.") if parts > size

    part_size = size / parts

    subnets = []
    iter = first
    parts.times do
      iter_next = iter + part_size

      # last part should be smaller
      iter_next = last if iter_next > last
      subnets << Subnet.new(iter, iter_next)
      iter = iter_next + 1
    end
    subnets
  end

  # Returns amount of addresses in subnet
  def size
    last - first
  end

  # Returns string representation of subnet
  def to_s
    first.to_s + '-' + last.to_s
  end
end