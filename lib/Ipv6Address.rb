# Represents single valid IPv6 address

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
      raise ArgumentError.new("'#{numeric}' is not valid IPv6 numeric representation") unless numeric
      raise ArgumentError.new("'#{numeric}' is not valid IPv6 numeric representation") unless self.class.is_valid_nr(numeric)
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


  def self.add_missing_hextets(str) # to support :: notation

    parts = str.split('::')
    missing_hextets_count = 8

    parts.each { |part| missing_hextets_count -= part.split(':').length }
    missing_part = ':0000:' * missing_hextets_count

    str.gsub! '::', missing_part
    str.gsub! '::',':'
    str.sub! /^:/, ''
    str.sub! /:$/, ''

    str
  end


  def self.string_to_numeric(str)

    raise ArgumentError.new("'#{str}' is not valid IPv6 address") if str.scan(/::/).length > 1
    raise ArgumentError.new("'#{str}' is not valid IPv6 address") if not /^[0-9a-f:]+$/ === str

    str = add_missing_hextets(str)

    hextets = str.split(":").map{|i| i.to_i(16)}

    raise ArgumentError.new("'#{str}' is not valid IPv6 address") if hextets.length != 8

    num = 0
    hextets.each_with_index { |hex, index| num += hex << 112 - 16 * index }

    raise ArgumentError.new("'#{str}' is not valid IPv6 address") unless is_valid_nr(num)
    num

  end

  alias_method :succ, :next    #to support ranges

  private
  def self.is_valid_nr(num)
    num >= 0 && num < (1 << 128)
  end

end