require 'iputils'

=begin
340282366920938463463374607431768211455
ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff


42540766416740939402060931394078537309
2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d

42540766416740939402060931394078537308
2001:0db8:11a3:09d7:1f34:8a2e:07a0:765c


0000:0000:0000:0000:0000:0000:0000:0000
0
=end


RSpec.describe Ipv6Address, "#initialize" do
  context 'generate from string' do

    it 'correct num value' do
      expect(Ipv6Address.new('0000:0000:0000:0000:0000:0000:0000:0000').to_i).to eq(0)
      #  TODO: add with :: addresses
      expect(Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d').to_i).to eq(42540766416740939402060931394078537309)
      expect(Ipv6Address.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff').to_i).to eq(340282366920938463463374607431768211455)
    end

  end

  context 'generates from integer' do

    it 'correct string value' do
      expect(Ipv6Address.new(0).to_s).to eq('0000:0000:0000:0000:0000:0000:0000:0000')
      expect(Ipv6Address.new(42540766416740939402060931394078537309).to_s).to eq('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d')
      expect(Ipv6Address.new(340282366920938463463374607431768211455).to_s).to eq('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')
    end

    it 'throws ex if invalid value' do
      expect{Ipv6Address.new(340282366920938463463374607431768211456)}.to raise_exception(ArgumentError)
      expect{Ipv6Address.new(-111)}.to raise_exception(ArgumentError)
    end
  end
end


RSpec.describe Ipv6Address, "#string_to_numeric" do
  test_ip = Ipv6Address.new(0)

  it 'convert correctly' do
    expect(test_ip.class.string_to_numeric('0000:0000:0000:0000:0000:0000:0000:0000')).to eq(0)
    expect(test_ip.class.string_to_numeric('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d')).to eq(42540766416740939402060931394078537309)
    expect(test_ip.class.string_to_numeric('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')).to eq(340282366920938463463374607431768211455)
  end

  context 'throws exception' do

    it 'invalid symbols' do
      expect {test_ip.class.string_to_numeric('2001:0db8:zzzz:09d7:1f34:8a2e:07a0:765d')}.to raise_exception(ArgumentError)
    end

    it 'too few octets' do
      expect {test_ip.class.string_to_numeric(':::::::')}.to raise_exception(ArgumentError)
      expect {test_ip.class.string_to_numeric('2001:0db8:11a3:1f34:8a2e:07a0:765d')}.to raise_exception(ArgumentError)
    end

  end
end


RSpec.describe Ipv6Address, "#-(another)" do
  context 'first address is greater' do
    it 'amount is correct' do
      ip = Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d')
      expect(ip-ip).to eq(1)
      expect(ip-Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765c')).to eq(2)
      expect(ip-Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765b')).to eq(3)
    end
  end

  context 'second address is greater' do
    it 'amount is correct' do
      ip = Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d')
      expect(ip-ip).to eq(1)
      expect(ip-Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765e')).to eq(2)
      expect(ip-Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765f')).to eq(3)
    end
  end

  context 'boundary values' do
    it 'amount is correct' do
      max_ip = Ipv6Address.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')
      min_ip = Ipv6Address.new('0000:0000:0000:0000:0000:0000:0000:0000')

      expect(max_ip - min_ip).to eq(340282366920938463463374607431768211456)
      expect(min_ip - max_ip).to eq(340282366920938463463374607431768211456)
    end
  end
end


RSpec.describe Ipv6Address, "#<=>" do
  it 'main success' do
    base_ip = Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d')

    expect(base_ip <=> base_ip).to equal(0)
    expect(base_ip <=> Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765e')).to equal(-1)
    expect(base_ip <=> Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765c')).to equal(1)
  end
end


RSpec.describe Ipv6Address, '#to_s' do
  it 'is string' do
    expect(Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d').to_s).to be_instance_of(String)
  end

  it 'correct transformation'  do
    expect(Ipv6Address.new(42540766416740939402060931394078537309).to_s).to eq('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d')
  end
end


RSpec.describe Ipv6Address, '#to_i' do
  it 'is integer' do
    expect(Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d').to_i).to be_a_kind_of(Numeric)
  end

  it 'correct transformation'  do
    expect(Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d').to_i).to eq(42540766416740939402060931394078537309)
  end
end



RSpec.describe Ipv6Address, '#is_valid_nr' do

  it 'main success' do
    expect(Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d').testing_is_valid_nr).to be_truthy
    expect(Ipv6Address.new('0000:0000:0000:0000:0000:0000:0000:0000').testing_is_valid_nr).to be_truthy
    expect(Ipv6Address.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff').testing_is_valid_nr).to be_truthy

    expect(Ipv6Address.new('2001:0db8::09d7:1f34:8a2e:07a0:765d').testing_is_valid_nr).to be_truthy
    expect(Ipv6Address.new('2001:0db8::09d7:1f34::07a0:765d').testing_is_valid_nr).to be_truthy
  end

end



RSpec.describe Ipv6Address, '#next' do

  ip = Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d')

  it 'main success' do
    expect(ip.next <=> Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765e')).to equal(0)
  end

  context 'when ip out of range' do
    it 'raise an exception' do
      expect {Ipv6Address.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff').next}.to raise_error('Error: IP is out of range')
    end
  end

end


RSpec.describe Ipv6Address, '#prev' do

  ip = Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765d')

  it 'main success' do
    expect(ip.prev <=> Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765c')).to equal(0)
  end

  context 'when ip out of range' do
    it 'raise an exception' do
      expect {Ipv6Address.new(0).prev}.to raise_error('Error: IP is out of range')
    end
  end

end


RSpec.describe Ipv6Address, '#+(step)' do
  ip = Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765b')

  context 'when step is positive' do
    it 'main success' do
      expect(ip+(0)).to eq(Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765b').to_i)
      expect(ip+(1)).to eq(Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765c').to_i)
      expect(ip+(3)).to eq(Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765e').to_i)
    end

    it 'too big step raises an exception' do
      expect {Ipv6Address.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:fffd')+(10)}.to raise_error('Error: IP is out of range')
    end

  end

  context 'when step is negative number' do
    it 'main success' do
      expect(ip+(-1)).to eq(Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:765a').to_i)
      expect(ip+(-3)).to eq(Ipv6Address.new('2001:0db8:11a3:09d7:1f34:8a2e:07a0:7658').to_i)
    end

    it 'too big step raises an exception' do
      expect {Ipv6Address.new('0:0:0:0:0:0:0:7')+(-10)}.to raise_error('Error: IP is out of range')
    end
  end
end

