# Represents single valid IPv4 address
class Ipv4Address
  include Comparable
  include IpAddress

  # @param numeric - may be integer (integer presentation of ipv4 address) or string (like "127.0.0.1")
  # @raise ArgumentError if parameter is not valid
  def initialize(numeric)
    if numeric.is_a? String
      # puts 'is a string'
      @as_num = self.class.string_to_numeric(numeric)
      @as_str = numeric
    else
      raise ArgumentError.new("'#{numeric}' is not valid IPv4 numeric representation") unless numeric
      raise ArgumentError.new("'#{numeric}' is not valid IPv4 numeric representation") unless self.class.is_valid_nr(numeric)
      @as_num = numeric
      octets = []
      num = numeric
      (0...4).each do
        octets.unshift num % 256
        num = num / 256
      end
      @as_str = octets.join(".")
    end
  end

  # Converts string presentation of ipv4 address to numeric
  def self.string_to_numeric(str)

    raise ArgumentError.new("'#{str}' is not valid IPv4 address") if not /^[0-9\.]+$/ === str

    octets = str.split(".").map{|i| i.to_i}

    raise ArgumentError.new("'#{str}' is not valid IPv4 address") if octets.length != 4

    octets.each { |oct| raise ArgumentError.new("'#{str}' is not valid IPv4 address") if oct > 255}

    num = (octets[0]<< 24) + (octets[1]<< 16) + (octets[2]<< 8) + (octets[3])

    raise ArgumentError.new("'#{str}' is not valid IPv4 address") unless is_valid_nr(num)
    num

  end


  alias_method :succ, :next    #to support ranges

  private
  def self.is_valid_nr(num)
    num >= 0 && num < (1 << 32)
  end

end