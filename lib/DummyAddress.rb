class DummyAddress
  # used to test Subnet

  include Comparable
  include SubnetAddress

  def initialize(numeric)
      @as_num = numeric
      @as_str = @as_num.to_s
  end

  alias_method :succ, :next    #to support ranges

  private
  def self.is_valid_nr(num)
    num >= 0 && num < 100
  end

end

