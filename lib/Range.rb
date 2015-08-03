class Range
  # Converts range of ip addresses to subnet
  def to_subnet
    Subnet.new(first(), last())
  end
end