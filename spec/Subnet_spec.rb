require 'iputils'

=begin

we don't want to use ip4 objects.
also, no need to create some sort of test object, because numbers
alreade implements interface we need

=end


RSpec.describe Subnet, '#split_on' do

  context 'split into eight parts' do
    subnet = Subnet.new(0,35)
    splitted = subnet.split_on(8)


    it 'returns array of Subnets' do
      expect(splitted[2]).to be_a_kind_of(Subnet)
    end

    it 'correct split' do
      expect(splitted.length).to eq(8)

      expect(splitted[0].to_s).to eq(Subnet.new(0,4).to_s)
      expect(splitted[3].to_s).to eq(Subnet.new(15,19).to_s)
      expect(splitted[7].to_s).to eq(Subnet.new(35,35).to_s)
    end

    it 'parts have the same size (except last)' do
      expect(splitted[0].size).to eq(splitted[6].size)
      expect(splitted[0].size).to eq(splitted[3].size)
    end

    it 'last part is smaller' do
      expect(splitted[0].size >= splitted[7].size).to be_truthy
    end

  end

  context 'more parts than elements' do
    subnet = Subnet.new(0,10)

    it 'raise exception' do
      expect{subnet.split_on(11)}.to raise_exception(ArgumentError)
    end

  end

  context 'parts is not integer ' do
    subnet = Subnet.new(0,10)

    it 'raise exception' do
      expect{subnet.split_on(0)}.to raise_exception(ArgumentError)
      expect{subnet.split_on(-1)}.to raise_exception(ArgumentError)
      expect{subnet.split_on(nil)}.to raise_exception(ArgumentError)
      expect{subnet.split_on(7.24)}.to raise_exception(ArgumentError)
      expect{subnet.split_on('Zorro')}.to raise_exception(ArgumentError)
    end

  end

  context 'parts = size' do
    subnet = Subnet.new(0,100)

    it 'correct split' do
      expect(subnet.split_on(100).length).to eq(100)
      expect(subnet.split_on(100)[5].size).to eq(1)
    end

  end

end


RSpec.describe Subnet, '#each' do
  subnet = Subnet.new(1,6)

  it 'just yield' do
    expect {|b| subnet.each(&b) }.to yield_control
  end

  it 'yield 6 times' do
    expect {|b| subnet.each(&b) }.to yield_successive_args(1,2,3,4,5,6)
    expect {|b| subnet.each(&b) }.not_to yield_successive_args(1,2,3)
  end

end


RSpec.describe Subnet, '#to_s' do

  context 'hardcoded output' do
    it 'context output' do
      expect(Subnet.new(2,12).to_s).to eq('2-12')
    end
  end

  context 'with to_s method of childs' do
    it 'context output' do
      first = 2
      last = 12
      expect(Subnet.new(first,last).to_s).to eq(first.to_s + '-' + last.to_s)
    end
  end

end


RSpec.describe Subnet, '#size' do

  context 'with normal subnet' do
    it 'size is correct' do
      expect(Subnet.new(7, 12).size).to eq(5)
    end
  end

  context 'with one-address subnet' do
    it 'size is correct' do
      loopback = Subnet.new(7, 7)
      expect(loopback.size).to eq(0)
    end
  end

end

RSpec.describe Subnet, '#initialize' do

  context 'args has different type' do
    it 'raises TypeError' do
      ipv4 = Ipv4Address.new(0)
      ipv6 = Ipv6Address.new(1)

      expect{Subnet.new(ipv4, ipv6)}.to raise_error(TypeError,"Can't create subnet with different type of addresses")
    end
  end

  context 'last >= first ' do
    it 'correct subnet' do
      subnet = Subnet.new(0, 11)
      expect(subnet.first.to_s).to eq('0')
      expect(subnet.last.to_s).to eq('11')
    end

    it 'one-address subnet' do
      loopback = Subnet.new(45, 45)
      expect(loopback.first <=> loopback.last).to be_truthy
      expect(loopback.first <=> 45).to be_truthy
    end
  end

  context 'first > last' do
    it 'correct subnet' do
      subnet = Subnet.new(45, 12)
      expect(subnet.first.to_s).to eq('12')
      expect(subnet.last.to_s).to eq('45')
    end
  end

end

RSpec.describe Subnet, '#include' do

  subnet = Subnet.new(12, 36)

  it 'includes' do
    expect(subnet.includes?(12)).to be_truthy
    expect(subnet.includes?(25)).to be_truthy
    expect(subnet.includes?(36)).to be_truthy
  end

  it "doesn't include" do
    expect(subnet.includes?(0)).to be_falsey
    expect(subnet.includes?(11)).to be_falsey
    expect(subnet.includes?(37)).to be_falsey
  end

end


RSpec.describe Subnet, '#intersects?' do

  #   |subnet_left|      |subnet_right|
  #           |subnet_middle|

  subnet_left = Subnet.new(3, 11)
  subnet_middle = Subnet.new(7, 15)
  subnet_right = Subnet.new(12, 21)

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

    subnet_global = Subnet.new(0, 255)

    it 'intersects' do
      expect(subnet_global.intersects?(subnet_left)).to be_truthy
      expect(subnet_global.intersects?(subnet_middle)).to be_truthy
      expect(subnet_global.intersects?(subnet_right)).to be_truthy
      expect(subnet_global.intersects?(Subnet.new(0,0))).to be_truthy

      expect(subnet_global.intersects?(Subnet.new(255, 0))).to be_truthy
    end

  end

end