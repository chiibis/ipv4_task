require 'ipaddr'

class Ipv6Address
  include Comparable
  include IpAddress

  # @param numeric - may be integer (integer presentation of ipv4 address) or string (like "127.0.0.1")
  # @raise ArgumentError if parameter is not valid
  def initialize(numeric)
    if numeric.is_a? String
      @as_num = self.class.string_to_numeric(numeric)
      @as_str = numeric
    else
      raise ArgumentError.new("'#{numeric}' is not valid IPv4 numeric representation") unless self.class.is_valid_nr(numeric)
      @as_num = numeric
      hextets = []
      num = numeric
      (0...8).each do
        hextets.unshift (num % 65536).to_s(16).rjust(4,'0')
        num = num / 65536
      end
      @as_str = hextets.join(":")
    end
  end

  def self.string_to_numeric(str)

    # to support ab12::45ff notation
    # todo: need to add missing octets
    str.gsub! '::', ':0000:'

    raise ArgumentError.new("'#{str}' is not valid IPv6 address") if not /^[0-9a-f:]+$/ === str

    hextets = str.split(":").map{|i| i.to_i}

    raise ArgumentError.new("'#{str}' is not valid IPv6 address") if hextets.length != 8

    num = IPAddr.new(str).to_i
    raise ArgumentError.new("'#{str}' is not valid IPv4 address") unless is_valid_nr(num)
    num
  end

  alias_method :succ, :next    #to support ranges

  private
  def self.is_valid_nr(num)
    num >= 0 && num < (1 << 128)
  end

end