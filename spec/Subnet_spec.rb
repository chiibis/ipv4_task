require 'iputils'

=begin

All test should use instance of DummyAddress as arguments

=end

# TODO: DummyAddress.new(0) можно заменить на метод-хелпер, например address(int) - просто запись будет короче и понятнее
# TODO: - многие it не читаются

RSpec.describe Subnet, '#split_on' do

  it 'returns array of Subnets' do
    subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(5))
    expect(subnet.split_on(3)[0]).to be_a_kind_of(Subnet) # TODO: сомнительно, если этот кейс не будет работать - упадут вообще все тесты. Всё равно что проверять а есть ли такой-то метод в этом классе.
  end

  context 'can split into equal parts' do
    subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(5))
    splitted = subnet.split_on(3)

    it 'correct split' do
      expect(splitted.length).to eq(3)

      expect(splitted[0].to_s).to eq(Subnet.new(DummyAddress.new(0),DummyAddress.new(1)).to_s)
      expect(splitted[1].to_s).to eq(Subnet.new(DummyAddress.new(2),DummyAddress.new(3)).to_s)
      expect(splitted[2].to_s).to eq(Subnet.new(DummyAddress.new(4),DummyAddress.new(5)).to_s)
    end

  end

  context 'not equal parts, last is smaller' do
    subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(4))
    splitted = subnet.split_on(3)

    it 'correct split' do
      expect(splitted.length).to eq(3)

      expect(splitted[0].to_s).to eq(Subnet.new(DummyAddress.new(0),DummyAddress.new(1)).to_s)
      expect(splitted[1].to_s).to eq(Subnet.new(DummyAddress.new(2),DummyAddress.new(3)).to_s)
      expect(splitted[2].to_s).to eq(Subnet.new(DummyAddress.new(4),DummyAddress.new(4)).to_s)
    end

  end

  context 'not equal parts, last can not be smaller' do

    it 'correct split (part size > 1)' do

      subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(8))
      splitted = subnet.split_on(4)

      expect(splitted.length).to eq(4)

      expect(splitted[0].to_s).to eq(Subnet.new(DummyAddress.new(0),DummyAddress.new(1)).to_s)
      expect(splitted[1].to_s).to eq(Subnet.new(DummyAddress.new(2),DummyAddress.new(3)).to_s)
      expect(splitted[2].to_s).to eq(Subnet.new(DummyAddress.new(4),DummyAddress.new(5)).to_s)
      expect(splitted[3].to_s).to eq(Subnet.new(DummyAddress.new(6),DummyAddress.new(8)).to_s)
    end


    it 'correct split (part size = 1 )' do
      subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(5))
      splitted = subnet.split_on(5) # TODO: чем в этом тесте 5 адресов лучше чем 3, кроме того что занимают больше места?

      expect(splitted.length).to eq(5)

      expect(splitted[0].to_s).to eq(Subnet.new(DummyAddress.new(0),DummyAddress.new(0)).to_s)
      expect(splitted[1].to_s).to eq(Subnet.new(DummyAddress.new(1),DummyAddress.new(1)).to_s)
      expect(splitted[2].to_s).to eq(Subnet.new(DummyAddress.new(2),DummyAddress.new(2)).to_s)
      expect(splitted[3].to_s).to eq(Subnet.new(DummyAddress.new(3),DummyAddress.new(3)).to_s)
      expect(splitted[4].to_s).to eq(Subnet.new(DummyAddress.new(4),DummyAddress.new(5)).to_s)
    end

    
    it 'correct split (prime number)' do # TODO: что за кейс? о_О
      subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(10))
      splitted = subnet.split_on(7)

      expect(splitted.length).to eq(7)

      expect(splitted[0].to_s).to eq(Subnet.new(DummyAddress.new(0),DummyAddress.new(0)).to_s)
      expect(splitted[1].to_s).to eq(Subnet.new(DummyAddress.new(1),DummyAddress.new(1)).to_s)
      expect(splitted[2].to_s).to eq(Subnet.new(DummyAddress.new(2),DummyAddress.new(2)).to_s)
      expect(splitted[3].to_s).to eq(Subnet.new(DummyAddress.new(3),DummyAddress.new(3)).to_s)
      expect(splitted[4].to_s).to eq(Subnet.new(DummyAddress.new(4),DummyAddress.new(4)).to_s)
      expect(splitted[5].to_s).to eq(Subnet.new(DummyAddress.new(5),DummyAddress.new(5)).to_s)
      expect(splitted[6].to_s).to eq(Subnet.new(DummyAddress.new(6),DummyAddress.new(10)).to_s)
    end


  end

  context 'more parts than elements' do
    subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(4))

    it 'raise exception' do
      expect{subnet.split_on(6)}.to raise_exception(ArgumentError,/Subnet has.*elements only./)
    end

  end

  context 'parts is not integer ' do # TODO: context врёт, ведь 0 и -1 - вполне себе integer'ы
    subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(10))

    it 'raise exception' do
      expect{subnet.split_on(0)}.to raise_exception(ArgumentError,/Parts should be Integer greater than 0./)
      expect{subnet.split_on(-1)}.to raise_exception(ArgumentError,/Parts should be Integer greater than 0./)
      expect{subnet.split_on(nil)}.to raise_exception(ArgumentError,/Parts should be Integer greater than 0./)
      expect{subnet.split_on(7.24)}.to raise_exception(ArgumentError,/Parts should be Integer greater than 0./)
      expect{subnet.split_on('Zorro')}.to raise_exception(ArgumentError,/Parts should be Integer greater than 0./)
    end

  end

  context 'parts = size' do
    subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(10))

    it 'correct split' do
      expect(subnet.split_on(11).length).to eq(11)
      expect(subnet.split_on(11)[3].size).to eq(1) # TODO: ассерт "по пути"?
    end

  end

end

# TODO: граничный случай?
RSpec.describe Subnet, '#each' do

  subnet = Subnet.new(DummyAddress.new(1),DummyAddress.new(6))

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
      expect(Subnet.new(DummyAddress.new(2),DummyAddress.new(12)).to_s).to eq('2-12') # TODO: граничный случай?
    end
  end

  context 'with to_s method of childs' do
    it 'context output' do
      first = DummyAddress.new(2)
      last = DummyAddress.new(12)
      expect(Subnet.new(first,last).to_s).to eq(first.to_s + '-' + last.to_s) # TODO: дублируется логика тестируемого метода, лучше писать явно
    end
  end

end


RSpec.describe Subnet, '#size' do

  context 'with normal subnet' do
    it 'size is correct' do
      expect(Subnet.new(DummyAddress.new(0), DummyAddress.new(3)).size).to eq(4) # TODO: граничный случай?
    end
  end

  context 'with one-address subnet' do
    it 'size is correct' do
      loopback = Subnet.new(DummyAddress.new(0), DummyAddress.new(0))
      expect(loopback.size).to eq(1)
    end
  end

end
# TODO: почему бы тесты на конструктор не поместить в самом верху?
RSpec.describe Subnet, '#initialize' do

  context 'args has different type' do
    it 'raises TypeError' do
      addr = DummyAddress.new(0)
      other_type_addr = Ipv6Address.new(1) # TODO: в TDD не прокатит

      expect{Subnet.new(addr, other_type_addr)}.to raise_error(TypeError,"Can't create subnet with different type of addresses") # TODO: к сообщению лучше не привязываться - оно может поменяться
    end
  end

  context 'last >= first ' do
    it 'correct subnet' do
      subnet = Subnet.new(DummyAddress.new(0), DummyAddress.new(2))
      expect(subnet.first.to_s).to eq('0')
      expect(subnet.last.to_s).to eq('2')
    end

    it 'one-address subnet' do
      loopback = Subnet.new(DummyAddress.new(1), DummyAddress.new(1))
      expect(loopback.first <=> loopback.last).to be_truthy
      expect(loopback.first <=> 1).to be_truthy
    end
  end

  context 'first > last' do
    it 'correct subnet' do
      subnet = Subnet.new(DummyAddress.new(2), DummyAddress.new(0))
      expect(subnet.first.to_s).to eq('0')
      expect(subnet.last.to_s).to eq('2')
    end
  end

  # TODO: initialize с nil?
end

 # TODO: граничные случаи?
RSpec.describe Subnet, '#include' do

  subnet = Subnet.new(DummyAddress.new(1), DummyAddress.new(10)) # TODO: слишком большая подсеть для этих кейсов

  it 'includes' do
    expect(subnet.includes?(DummyAddress.new(1))).to be_truthy
    expect(subnet.includes?(DummyAddress.new(5))).to be_truthy
    expect(subnet.includes?(DummyAddress.new(10))).to be_truthy
  end

  it "doesn't include" do
    expect(subnet.includes?(DummyAddress.new(0))).to be_falsey
    expect(subnet.includes?(DummyAddress.new(11))).to be_falsey
  end

  it 'throws different type exception' do
    expect{subnet.includes?(0)}.to raise_exception(TypeError, /Can accept.*type only/)
  end

end

# TODO: граничные случаи?
RSpec.describe Subnet, '#intersects?' do

  #   |subnet_left|      |subnet_right|
  #           |subnet_middle|

  subnet_left = Subnet.new(DummyAddress.new(0), DummyAddress.new(3)) # TODO: можно подсети поменьше ;)
  subnet_middle = Subnet.new(DummyAddress.new(3), DummyAddress.new(6))
  subnet_right = Subnet.new(DummyAddress.new(6), DummyAddress.new(9))

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

    subnet_global = Subnet.new(DummyAddress.new(0), DummyAddress.new(9))

    it 'intersects' do
      expect(subnet_global.intersects?(subnet_left)).to be_truthy
      expect(subnet_global.intersects?(subnet_middle)).to be_truthy
      expect(subnet_global.intersects?(subnet_right)).to be_truthy
      expect(subnet_global.intersects?(Subnet.new(DummyAddress.new(0),DummyAddress.new(0)))).to be_truthy
      expect(subnet_global.intersects?(Subnet.new(DummyAddress.new(9), DummyAddress.new(0)))).to be_truthy
    end

  end

end