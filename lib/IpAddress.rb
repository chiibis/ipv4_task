# represents common parts of each IpAddress realization

module IpAddress

  # Returns next IPv4 address (new object) or RuntimeError if not exist
  def next
    if self.class.is_valid_nr(@as_num + 1)
      self.class.new(@as_num + 1)
    else
      raise RuntimeError.new('Error: IP is out of range')
    end
  end

  # Returns previous IPv4 address (new object) or RuntimeError if not exist
  def prev
    if self.class.is_valid_nr(@as_num - 1)
      self.class.new(@as_num - 1)
    else
      raise RuntimeError.new('Error: IP is out of range')
    end
  end

  # Returns next step-th ip address
  def +(step)
    if self.class.is_valid_nr(@as_num + step)
      self.class.new(@as_num + step)
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

  # used for tests only
  def testing_is_valid_nr
    self.class.is_valid_nr(@as_num)
  end

  # Compares 2 ip addresses
  def <=>(another_addr)
    to_i <=> another_addr.to_i
  end

  # Returns amount of addresses between 2 addresses including them. (addr - addr == 1)
  def -(another_addr)
    (to_i - another_addr.to_i).abs + 1
  end


end