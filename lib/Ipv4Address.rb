# Represents single valid IPv4 address
class Ipv4Address
  include Comparable

  # @param numeric - may be integer (integer presentation of ipv4 address) or string (like "127.0.0.1")
  # @raise ArgumentError if parameter is not valid
  def initialize(numeric)
    if numeric.is_a? String
      # puts 'is a string'
      @as_num = self.class.string_to_numeric(numeric)
      @as_str = numeric
    else
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

  # Returns next IPv4 address (new object) or RuntimeError if not exist
  def next
    if self.class.is_valid_nr(@as_num + 1)
      Ipv4Address.new(@as_num + 1)
    else
      raise RuntimeError.new('Error: IP is out of range')
    end
  end

  # Returns previous IPv4 address (new object) or RuntimeError if not exist
  def prev
    # Ipv4Address.new(@as_num - 1)
    if self.class.is_valid_nr(@as_num - 1)
      Ipv4Address.new(@as_num - 1)
    else
      raise RuntimeError.new('Error: IP is out of range')
    end
  end

  # Returns string representation of ip address
  def to_s
    @as_str
  end

  # Returns integer representation of ip address
  def to_i
    @as_num
  end

  # Compares 2 ip addresses
  def <=>(another_addr)
    to_i <=> another_addr.to_i
  end

  # Returns amount of addresses between 2 addresses including them. (addr - addr == 1)
  def -(another_addr)
    (to_i - another_addr.to_i).abs + 1
  end

  # Returns next step-th ip address
  def +(step)
    if self.class.is_valid_nr(@as_num + step)
      Ipv4Address.new(@as_num + step)
    else
      raise RuntimeError.new('Error: IP is out of range')
    end
  end

  # used for tests only
  def testing_is_valid_nr
    self.class.is_valid_nr(@as_num)
  end

  alias_method :succ, :next    #to support ranges

  private
  def self.is_valid_nr(num)
    num >= 0 && num < (1 << 32)
  end

end