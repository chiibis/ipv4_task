require 'iputils'


RSpec.describe Ipv4Address, "#initialize" do
  context 'generate from string' do

    it 'correct num value' do
      expect(Ipv4Address.new('0.0.0.0').to_i).to eq(0)
      expect(Ipv4Address.new('192.168.1.1').to_i).to eq(3232235777)
      expect(Ipv4Address.new('255.255.255.255').to_i).to eq(4294967295)
    end

  end

  context 'generates from integer' do

    it 'correct string value' do
      expect(Ipv4Address.new(0).to_s).to eq('0.0.0.0')
      expect(Ipv4Address.new(3232235777).to_s).to eq('192.168.1.1')
      expect(Ipv4Address.new(4294967295).to_s).to eq('255.255.255.255')
    end

    it 'throws ex if invalid value' do
      expect{Ipv4Address.new(4294967296)}.to raise_exception(ArgumentError)
      expect{Ipv4Address.new(-111)}.to raise_exception(ArgumentError)
    end
  end
end


RSpec.describe Ipv4Address, "#string_to_numeric" do
  test_ip = Ipv4Address.new(0)

  it 'convert correctly' do
    expect(test_ip.class.string_to_numeric('0.0.0.0')).to eq(0)
    expect(test_ip.class.string_to_numeric('81.95.27.2')).to eq(1365187330)
    expect(test_ip.class.string_to_numeric('255.255.255.255')).to eq(4294967295)
  end

  context 'throws exception' do

    it 'invalid symbols' do
      expect {test_ip.class.string_to_numeric('192.abbb.0.1')}.to raise_exception(ArgumentError)
    end

    it 'too few octets' do
      expect {test_ip.class.string_to_numeric('....')}.to raise_exception(ArgumentError)
      expect {test_ip.class.string_to_numeric('192.168.0')}.to raise_exception(ArgumentError)
    end

    it 'octet is greater, than 255' do
      expect {test_ip.class.string_to_numeric('192.168.999.0')}.to raise_exception(ArgumentError)
    end
  end
end


RSpec.describe Ipv4Address, "#-(another)" do
  context 'first address is greater' do
    it 'amount is correct' do
      ip = Ipv4Address.new('81.95.27.7')
      expect(ip-ip).to eq(1)
      expect(ip-Ipv4Address.new('81.95.27.6')).to eq(2)
      expect(ip-Ipv4Address.new('81.95.27.5')).to eq(3)
    end
  end

  context 'second address is greater' do
    it 'amount is correct' do
      ip = Ipv4Address.new('81.95.27.7')
      expect(ip-ip).to eq(1)
      expect(ip-Ipv4Address.new('81.95.27.8')).to eq(2)
      expect(ip-Ipv4Address.new('81.95.27.9')).to eq(3)
    end
  end

  context 'boundary values' do
    it 'amount is correct' do
      expect(Ipv4Address.new('255.255.255.255') - Ipv4Address.new('0.0.0.0')).to eq(4294967296)
      expect(Ipv4Address.new('0.0.0.0') - Ipv4Address.new('255.255.255.255')).to eq(4294967296)
    end
  end
end


RSpec.describe Ipv4Address, "#<=>" do
  it 'main success' do
    expect(Ipv4Address.new('192.168.1.1') <=> Ipv4Address.new('192.168.1.1')).to equal(0)
    expect(Ipv4Address.new('192.168.1.0') <=> Ipv4Address.new('192.168.1.3')).to equal(-1)
    expect(Ipv4Address.new('192.168.1.3') <=> Ipv4Address.new('192.168.1.0')).to equal(1)
  end
end


RSpec.describe Ipv4Address, '#to_s' do
  it 'is string' do
    expect(Ipv4Address.new('192.168.1.1').to_s).to be_instance_of(String)
  end

  it 'correct transformation'  do
    expect(Ipv4Address.new(1365187330).to_s).to eq('81.95.27.2')
  end
end


RSpec.describe Ipv4Address, '#to_i' do
  it 'is integer' do
    expect(Ipv4Address.new('192.168.1.1').to_i).to be_a_kind_of(Numeric)
  end

  it 'correct transformation'  do
    expect(Ipv4Address.new('81.95.27.2').to_i).to eq(1365187330)
  end
end


RSpec.describe Ipv4Address, '#is_valid_nr' do

  it 'main success' do
    expect(Ipv4Address.new('192.168.1.1').testing_is_valid_nr).to be_truthy
    expect(Ipv4Address.new('0.0.0.0').testing_is_valid_nr).to be_truthy
    expect(Ipv4Address.new('255.255.255.255').testing_is_valid_nr).to be_truthy
  end

end


RSpec.describe Ipv4Address, '#next' do

  it 'main success' do
    expect(Ipv4Address.new('192.168.1.1').next <=> Ipv4Address.new('192.168.1.2')).to equal(0)
  end

  context 'when ip out of range' do
    it 'raise an exception' do
      expect {Ipv4Address.new('255.255.255.255').next}.to raise_error('Error: IP is out of range')
    end
  end

end


RSpec.describe Ipv4Address, '#prev' do

  it 'main success' do
    expect(Ipv4Address.new('192.168.1.8').prev <=> Ipv4Address.new('192.168.1.7')).to equal(0)
  end

  context 'when ip out of range' do
    it 'raise an exception' do
      expect {Ipv4Address.new('0.0.0.0').prev}.to raise_error('Error: IP is out of range')
    end
  end

end


RSpec.describe Ipv4Address, '#+(step)' do
  ip = Ipv4Address.new('192.168.1.8')

  context 'when step is positive' do
    it 'main success' do
      expect(ip+(0)).to eq(Ipv4Address.new('192.168.1.8').to_i)
      expect(ip+(1)).to eq(Ipv4Address.new('192.168.1.9').to_i)
      expect(ip+(3)).to eq(Ipv4Address.new('192.168.1.11').to_i)
    end

    it 'too big step raises an exception' do
      expect {Ipv4Address.new('255.255.255.250')+(10)}.to raise_error('Error: IP is out of range')
    end

  end

  context 'when step is negative number' do
    it 'main success' do
      expect(ip+(-1)).to eq(Ipv4Address.new('192.168.1.7').to_i)
      expect(ip+(-3)).to eq(Ipv4Address.new('192.168.1.5').to_i)
    end

    it 'too big step raises an exception' do
      expect {Ipv4Address.new('0.0.0.8')+(-10)}.to raise_error('Error: IP is out of range')
    end
  end

end


