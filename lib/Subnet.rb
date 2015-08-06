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

    # test both args has same type
    raise TypeError.new("Can't create subnet with different type of addresses") unless first.is_a? last.class

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
    raise TypeError.new("Can accept #{first.class} type only") unless first.is_a? addr.class

    first <= addr and addr <= last
  end

  # Returns true if there are ip addresses which present in both this and provided subnets
  def intersects?(subnet)
    includes? subnet.first or includes? subnet.last
  end

  # Iterates over all addresses
  def each
    (@first..@last).each {|addr| yield addr}
  end

  # Returns an array of <c>parts</c> subnets. All subnets except last shall have same size, last one should be smaller
  # if possible. If not, it can be greater.
  # All ip addresses from this subnet shall be used in the returned subnets set
  def split_on(parts)

    raise ArgumentError.new("Parts should be Integer greater than 0.") unless parts.is_a? Integer and parts > 0
    raise ArgumentError.new("Subnet has #{size} elements only.") if parts > size

    if size % parts == 0
      part_size = size / parts
    else
      part_size = size / (parts - 1)
      if size % part_size == 0 and part_size > 1
        part_size -= 1
      end
    end

    subnets = []
    iter = first

    parts.times do |i|
      iter_next = iter + (part_size - 1)

      # last part should be smaller
      iter_next = last if iter_next > last or i + 1 == parts

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