require 'iputils'

# TODO: похоже на приватный метод, плюс дубликаты тестов с тестами ниже
RSpec.describe Ipv6Address, "#add_missing_hextets" do
  test_ip = Ipv6Address.new(0)


  context 'one hextet missing' do
    str = '1111:1111:1111::1111:1111:1111:1111'
    str2 = '::1111:1111:1111:1111:1111:1111:1111'

    it 'replace missing with zeros' do
      expect(test_ip.class.add_missing_hextets(str)).to eq('1111:1111:1111:0000:1111:1111:1111:1111')
      expect(test_ip.class.add_missing_hextets(str2)).to eq('0000:1111:1111:1111:1111:1111:1111:1111')
    end
  end

  context 'many hextets are missing' do
    it 'replace missing with zeros' do
      expect(test_ip.class.add_missing_hextets('1111:1111::1111:1111')).to eq('1111:1111:0000:0000:0000:0000:1111:1111')
      expect(test_ip.class.add_missing_hextets('::1111:1111')).to eq('0000:0000:0000:0000:0000:0000:1111:1111')
      expect(test_ip.class.add_missing_hextets('ffff::')).to eq('ffff:0000:0000:0000:0000:0000:0000:0000')
      expect(test_ip.class.add_missing_hextets('::')).to eq('0000:0000:0000:0000:0000:0000:0000:0000')
    end

  end

end


RSpec.describe Ipv6Address, "#initialize" do
  context 'generate from string' do

    it 'correct num value' do # TODO: - не читается.
      expect(Ipv6Address.new('0000:0000:0000:0000:0000:0000:0000:0000').to_i).to eq(0)
      expect(Ipv6Address.new('::').to_i).to eq(0) # TODO: отдельный it
      expect(Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d').to_i).to eq(42540766416740939402060931394078537309) # TODO: что за кейс?
      expect(Ipv6Address.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff').to_i).to eq(256**16-1) # TODO: отдельный it
    end

  end

  context 'generates from integer' do

    it 'correct string value' do # TODO: - не читается.
      expect(Ipv6Address.new(0).to_s).to eq('0000:0000:0000:0000:0000:0000:0000:0000')
      expect(Ipv6Address.new(42540766416740939402060931394078537309).to_s).to eq('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d') # TODO: что за кейс?
      expect(Ipv6Address.new(256**16-1).to_s).to eq('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')# TODO: отдельный it
    end

    it 'throws ex if invalid value' do
      too_big = 256**16 # TODO: лучше без константы.
      expect{Ipv6Address.new(too_big)}.to raise_exception(ArgumentError, /is not valid IPv6 numeric representation/)
      expect{Ipv6Address.new(-111)}.to raise_exception(ArgumentError, /is not valid IPv6 numeric representation/) # TODO: аналогично замечаниям в IPv4
      expect{Ipv6Address.new(nil)}.to raise_exception(ArgumentError, /is not valid IPv6 numeric representation/)
    end
  end
end


RSpec.describe Ipv6Address, "#string_to_numeric" do
  test_ip = Ipv6Address.new(0)

  # TODO: много кейсов под одним it
  it 'converts correctly' do # TODO: - в каких случаях?
    expect(test_ip.class.string_to_numeric('0000:0000:0000:0000:0000:0000:0000:0000')).to eq(0)
    expect(test_ip.class.string_to_numeric('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d')).to eq(42540766416740939402060931394078537309)  # TODO: что за кейс?
    expect(test_ip.class.string_to_numeric('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')).to eq(256**16-1)
    expect(test_ip.class.string_to_numeric('::7')).to eq(7)
    expect(test_ip.class.string_to_numeric('FABC::FABC')).to eq(333283150755633515820115498379979586236) # TODO: что за кейс?
    expect(test_ip.class.string_to_numeric('::FFFF')).to eq(2**16-1)

  end

  it 'handle Upper case' do
    expect(test_ip.class.string_to_numeric('FFFF:ffff:ffff:FFFF:ffff:ffff:ffff:ffff')).to eq(256**16-1)
  end

  context 'throws exception' do

    it 'has more than one ::' do
      ip = '1111:1111::1111:1111::1111:1111'
      expect {test_ip.class.string_to_numeric(ip)}.to raise_exception(ArgumentError, /is not valid IPv6 address/)
    end

    it 'invalid formats' do # TODO: - не читается.
      ip = '1111:1111:HHHH:1111:1111:1111:1111:1111' # TODO: лучше без константы.
      expect {test_ip.class.string_to_numeric(ip)}.to raise_exception(ArgumentError, /is not valid IPv6 address/)
      expect {test_ip.class.string_to_numeric('1:::')}.to raise_exception(ArgumentError, /is not valid IPv6 address/)
      expect {test_ip.class.string_to_numeric('0000001::')}.to raise_exception(ArgumentError, /is not valid IPv6 address/)
      expect {test_ip.class.string_to_numeric(':::::::')}.to raise_exception(ArgumentError, /is not valid IPv6 address/)
    end

    it 'too few octets' do # TODO: - не читается. octets?
      ip = '1111:1111:1111:1111:1111:1111:1111'
      expect {test_ip.class.string_to_numeric(ip)}.to raise_exception(ArgumentError, /is not valid IPv6 address/)
    end

  end

end

 # TODO: аналогично замечаниям в IPv4
RSpec.describe Ipv6Address, "#-(another)" do
  context 'first address is greater' do
    it 'amount is correct' do # TODO: - не читается. 
      ip = Ipv6Address.new('::8') 
      expect(ip-ip).to eq(1)
      expect(ip-Ipv6Address.new('::7')).to eq(2)
      expect(ip-Ipv6Address.new('::5')).to eq(4)
    end
  end

  context 'second address is greater' do
    it 'amount is correct' do # TODO: - не читается. 
      ip = Ipv6Address.new('::7')
      expect(ip-ip).to eq(1)
      expect(ip-Ipv6Address.new('::8')).to eq(2)
      expect(ip-Ipv6Address.new('::9')).to eq(3)
    end
  end

  context 'boundary values' do
    it 'amount is correct' do # TODO: - не читается. 
      max_ip = Ipv6Address.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')
      min_ip = Ipv6Address.new('::')

      expect(max_ip - min_ip).to eq(256**16)
      expect(min_ip - max_ip).to eq(256**16)
    end
  end
end

 # TODO: аналогично замечаниям в IPv4
RSpec.describe Ipv6Address, "#<=>" do
  it 'main success' do # TODO: - не читается. 
    base_ip = Ipv6Address.new('::11d')

    expect(base_ip <=> base_ip).to equal(0)
    expect(base_ip <=> Ipv6Address.new('::11e')).to equal(-1)
    expect(base_ip <=> Ipv6Address.new('::11c')).to equal(1)
  end
end

 # TODO: аналогично замечаниям в IPv4
RSpec.describe Ipv6Address, '#to_s' do
  it 'is string' do
    expect(Ipv6Address.new('ffff::').to_s).to be_instance_of(String)
  end

  it 'correct transformation'  do # TODO: - не читается. 
    expect(Ipv6Address.new(42540766416740939402060931394078537309).to_s).to eq('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d')
  end
end

 # TODO: аналогично замечаниям в IPv4
RSpec.describe Ipv6Address, '#to_i' do
  it 'is integer' do
    expect(Ipv6Address.new('::1111').to_i).to be_a_kind_of(Numeric)
  end

  it 'correct transformation'  do # TODO: - не читается. 
    expect(Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d').to_i).to eq(42540766416740939402060931394078537309)
  end
end

 # TODO: аналогично замечаниям в IPv4
RSpec.describe Ipv6Address, '#next' do

  it 'main success' do # TODO: - не читается. 
    expect(Ipv6Address.new('::a').next <=> Ipv6Address.new('::b')).to equal(0)
  end

  context 'when ip out of range' do
    it 'raise an exception' do
      expect {Ipv6Address.new(256**16-1).next}.to raise_error('Error: IP is out of range')
    end
  end

end

 # TODO: аналогично замечаниям в IPv4
RSpec.describe Ipv6Address, '#prev' do

  it 'main success' do # TODO: - не читается. 
    expect(Ipv6Address.new('::7').prev <=> Ipv6Address.new('::6')).to equal(0)
  end

  context 'when ip out of range' do
    it 'raise an exception' do
      expect {Ipv6Address.new(0).prev}.to raise_error('Error: IP is out of range')
    end
  end

end

 # TODO: аналогично замечаниям в IPv4
RSpec.describe Ipv6Address, '#+(step)' do

  context 'when step is positive' do
    it 'main success' do # TODO: - не читается. 
      expect(Ipv6Address.new('::2')+(0)).to eq(Ipv6Address.new('::2').to_i)
      expect(Ipv6Address.new('::2')+(1)).to eq(Ipv6Address.new('::3').to_i)
      expect(Ipv6Address.new('::2')+(3)).to eq(Ipv6Address.new('::5').to_i)
    end

    it 'too big step raises an exception' do # TODO: - не читается. 
      expect {Ipv6Address.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffd')+(10)}.to raise_error('Error: IP is out of range')
    end

  end

  context 'when step is negative number' do
    it 'main success' do # TODO: - не читается. 
      expect(Ipv6Address.new('::5')+(-1)).to eq(Ipv6Address.new('::4').to_i)
      expect(Ipv6Address.new('::5')+(-3)).to eq(Ipv6Address.new('::2').to_i)
    end

    it 'too big step raises an exception' do # TODO: - не читается. 
      expect {Ipv6Address.new('::7')+(-10)}.to raise_error('Error: IP is out of range')
    end
  end
end

