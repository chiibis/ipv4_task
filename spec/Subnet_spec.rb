require 'iputils'

# TODO: MAYBE SHOULD USE MOCK OBJECTS?
=begin

we don't want to use ip objects.
also, no need to create some sort of test object, because numbers
alreade implements interface we need

=end


RSpec.describe Subnet, '#size' do

  ip1 = Ipv4Address.new('192.168.0.0')
  ip2 = Ipv4Address.new('192.168.0.11')

  context 'with normal subnet' do
    it 'size is correct' do
      expect(Subnet.new(ip1, ip2).size).to eq(12)
    end
  end

  context 'with one-address subnet' do
    it 'size is correct' do
      loopback = Subnet.new(ip1, ip1)
      expect(loopback.size).to eq(1)
    end
  end

end

RSpec.describe Subnet, '#initialize' do

  ip1 = Ipv4Address.new('192.168.0.0')
  ip2 = Ipv4Address.new('192.168.0.11')

  context 'last >= first ' do
    it 'correct subnet' do
      subnet = Subnet.new(ip1, ip2)
      expect(subnet.first.to_s).to eq('192.168.0.0')
      expect(subnet.last.to_s).to eq('192.168.0.11')
    end

    it 'one-address subnet' do
      loopback = Subnet.new(ip1, ip1)
      expect(loopback.first <=> loopback.last).to be_truthy
      expect(loopback.first <=> Ipv4Address.new('192.168.0.0')).to be_truthy
    end
  end

  context 'first > last' do
    it 'correct subnet' do
      subnet = Subnet.new(ip2, ip1)
      expect(subnet.first.to_s).to eq('192.168.0.0')
      expect(subnet.last.to_s).to eq('192.168.0.11')
    end
  end

end

RSpec.describe Subnet, '#include' do

  subnet = Subnet.new(Ipv4Address.new('192.168.0.0'), Ipv4Address.new('192.168.0.11'))

  it 'includes' do
    expect(subnet.includes?(Ipv4Address.new('192.168.0.1'))).to be_truthy
    expect(subnet.includes?(Ipv4Address.new('192.168.0.8'))).to be_truthy
    expect(subnet.includes?(Ipv4Address.new('192.168.0.11'))).to be_truthy
  end

  it "doesn't include" do
    expect(subnet.includes?(Ipv4Address.new('192.168.0.0'))).to be_falsey
    expect(subnet.includes?(Ipv4Address.new('192.168.0.12'))).to be_falsey
    expect(subnet.includes?(Ipv4Address.new('0.0.0.0'))).to be_falsey
  end

end


RSpec.describe Subnet, '#intersects?' do

  #   |subnet_left|      |subnet_right|
  #           |subnet_middle|

  subnet_left = Subnet.new(Ipv4Address.new('192.168.0.0'), Ipv4Address.new('192.168.0.11'))
  subnet_middle = Subnet.new(Ipv4Address.new('192.168.0.7'), Ipv4Address.new('192.168.0.15'))
  subnet_right = Subnet.new(Ipv4Address.new('192.168.0.12'), Ipv4Address.new('192.168.0.21'))

  it 'intersects' do
    expect(subnet_left.intersects?(subnet_middle)).to be_truthy
    expect(subnet_middle.intersects?(subnet_left)).to be_truthy

    expect(subnet_middle.intersects?(subnet_right)).to be_truthy
    expect(subnet_right.intersects?(subnet_middle)).to be_truthy
  end

  it "doesn't intersects" do
    expect(subnet_left.intersects?(subnet_right)).to be_falsey
    expect(subnet_right.intersects?(subnet_left)).to be_falsey
  end

  context 'with global subnet' do

    very_first_ip = Ipv4Address.new('0.0.0.0')
    very_last_ip = Ipv4Address.new('255.255.255.255')

    subnet_global = Subnet.new(very_first_ip, very_last_ip)

    it 'intersects' do
      expect(subnet_global.intersects?(subnet_left)).to be_truthy
      expect(subnet_global.intersects?(subnet_middle)).to be_truthy
      expect(subnet_global.intersects?(subnet_right)).to be_truthy

      expect(subnet_global.intersects?(Subnet.new(very_last_ip,very_last_ip))).to be_truthy
    end

    it "doesn't intersects" do
      expect(subnet_global.intersects?(Subnet.new(very_first_ip,very_first_ip))).to be_falsey
    end

  end

end