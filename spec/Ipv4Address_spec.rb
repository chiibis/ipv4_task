require 'iputils'


RSpec.describe Ipv4Address, "#initialize" do
  context 'generate from string' do

    it 'correct num value' do
      expect(Ipv4Address.new('0.0.0.0').to_i).to eq(0)
      expect(Ipv4Address.new('192.168.1.1').to_i).to eq(3232235777)
      expect(Ipv4Address.new('255.255.255.255').to_i).to eq(2**32-1)
    end

  end

  context 'generates from integer' do

    it 'correct string value' do
      expect(Ipv4Address.new(0).to_s).to eq('0.0.0.0')
      expect(Ipv4Address.new(3232235777).to_s).to eq('192.168.1.1')
      expect(Ipv4Address.new(2**32-1).to_s).to eq('255.255.255.255')
    end

    it 'throws ex if invalid value' do
      expect{Ipv4Address.new(2**32)}.to raise_exception(ArgumentError, /is not valid IPv4 numeric representation/)
      expect{Ipv4Address.new(-111)}.to raise_exception(ArgumentError, /is not valid IPv4 numeric representation/)
      expect{Ipv4Address.new(nil)}.to raise_exception(ArgumentError, /is not valid IPv4 numeric representation/)
    end
  end
end


RSpec.describe Ipv4Address, "#string_to_numeric" do
  test_ip = Ipv4Address.new(0)

  it 'convert correctly' do
    expect(test_ip.class.string_to_numeric('0.0.0.0')).to eq(0)
    expect(test_ip.class.string_to_numeric('81.95.27.2')).to eq(1365187330)
    expect(test_ip.class.string_to_numeric('255.255.255.255')).to eq(2**32-1)
  end

  context 'throws exception' do

    it 'invalid format' do
      expect {test_ip.class.string_to_numeric('192.abbb.0.1')}.to raise_exception(ArgumentError, /is not valid IPv4 address/)
      expect {test_ip.class.string_to_numeric('1.1.00000.000001')}.to raise_exception(ArgumentError, /is not valid IPv4 address/)
      expect {test_ip.class.string_to_numeric('1...1')}.to raise_exception(ArgumentError, /is not valid IPv4 address/)
    end

    it 'too few octets' do
      expect {test_ip.class.string_to_numeric('....')}.to raise_exception(ArgumentError, /is not valid IPv4 address/)
      expect {test_ip.class.string_to_numeric('192.168.0')}.to raise_exception(ArgumentError, /is not valid IPv4 address/)
    end

    it 'octet is greater, than 255' do
      expect {test_ip.class.string_to_numeric('192.168.999.0')}.to raise_exception(ArgumentError, /is not valid IPv4 address/)
    end
  end
end


RSpec.describe Ipv4Address, "#-(another)" do
  context 'first address is greater' do
    it 'amount is correct' do
      ip = Ipv4Address.new('0.0.0.7')
      expect(ip-ip).to eq(1)
      expect(ip-Ipv4Address.new('0.0.0.6')).to eq(2)
      expect(ip-Ipv4Address.new('0.0.0.5')).to eq(3)
    end
  end

  context 'second address is greater' do
    it 'amount is correct' do
      ip = Ipv4Address.new('0.0.0.7')
      expect(ip-ip).to eq(1)
      expect(ip-Ipv4Address.new('0.0.0.8')).to eq(2)
      expect(ip-Ipv4Address.new('0.0.0.9')).to eq(3)
    end
  end

  context 'boundary values' do
    it 'amount is correct' do
      expect(Ipv4Address.new('255.255.255.255') - Ipv4Address.new('0.0.0.0')).to eq(2**32)
      expect(Ipv4Address.new('0.0.0.0') - Ipv4Address.new('255.255.255.255')).to eq(2**32)
    end
  end
end


RSpec.describe Ipv4Address, '#<=>' do
  it 'main success' do
    expect(Ipv4Address.new('0.0.0.1') <=> Ipv4Address.new('0.0.0.1')).to equal(0)
    expect(Ipv4Address.new('0.0.0.0') <=> Ipv4Address.new('0.0.0.3')).to equal(-1)
    expect(Ipv4Address.new('0.0.0.3') <=> Ipv4Address.new('0.0.0.0')).to equal(1)
  end
end


RSpec.describe Ipv4Address, '#to_s' do
  it 'is string' do
    expect(Ipv4Address.new('1.1.1.1').to_s).to be_instance_of(String)
  end

  it 'correct transformation'  do
    expect(Ipv4Address.new(2**32-1).to_s).to eq('255.255.255.255')
  end
end


RSpec.describe Ipv4Address, '#to_i' do
  it 'is integer' do
    expect(Ipv4Address.new('1.1.1.1').to_i).to be_a_kind_of(Numeric)
  end

  it 'correct transformation'  do
    expect(Ipv4Address.new('255.255.255.255').to_i).to eq(2**32-1)
  end
end


RSpec.describe Ipv4Address, '#next' do

  it 'main success' do
    expect(Ipv4Address.new('0.0.0.1').next <=> Ipv4Address.new('0.0.0.2')).to equal(0)
  end

  context 'when ip out of range' do
    it 'raise an exception' do
      expect {Ipv4Address.new('255.255.255.255').next}.to raise_error('Error: IP is out of range')
    end
  end

end


RSpec.describe Ipv4Address, '#prev' do

  it 'main success' do
    expect(Ipv4Address.new('0.0.0.8').prev <=> Ipv4Address.new('0.0.0.7')).to equal(0)
  end

  context 'when ip out of range' do
    it 'raise an exception' do
      expect {Ipv4Address.new('0.0.0.0').prev}.to raise_error('Error: IP is out of range')
    end
  end

end


RSpec.describe Ipv4Address, '#+(step)' do

  context 'when step is positive' do
    it 'main success' do
      expect(Ipv4Address.new('0.0.0.8')+(0)).to eq(Ipv4Address.new('0.0.0.8').to_i)
      expect(Ipv4Address.new('0.0.0.8')+(1)).to eq(Ipv4Address.new('0.0.0.9').to_i)
      expect(Ipv4Address.new('0.0.0.8')+(3)).to eq(Ipv4Address.new('0.0.0.11').to_i)
    end

    it 'too big step raises an exception' do
      expect {Ipv4Address.new('255.255.255.250')+(10)}.to raise_error('Error: IP is out of range')
    end

  end

  context 'when step is negative number' do
    it 'main success' do
      expect(Ipv4Address.new('0.0.0.8')+(-1)).to eq(Ipv4Address.new('0.0.0.7').to_i)
      expect(Ipv4Address.new('0.0.0.8')+(-3)).to eq(Ipv4Address.new('0.0.0.5').to_i)
    end

    it 'too big step raises an exception' do
      expect {Ipv4Address.new('0.0.0.8')+(-10)}.to raise_error('Error: IP is out of range')
    end
  end

end


