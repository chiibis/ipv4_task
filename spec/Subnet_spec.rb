require 'iputils'

=begin

All test should use instance of DummyAddress as arguments

=end


# TODO: DummyAddress.new(0) можно заменить на метод-хелпер, например address(int) - просто запись будет короче и понятнее


RSpec.describe Subnet, '#initialize' do
  context 'when args has different types' do
    it 'raises TypeError' do
      addr = DummyAddress.new(0)
      other_type_addr = nil
      expect{Subnet.new(addr, other_type_addr)}.to raise_error(TypeError)
    end
  end

  context 'when last >= first ' do
    it 'returns correct subnet' do
      subnet = Subnet.new(DummyAddress.new(0), DummyAddress.new(2))
      expect(subnet.first.to_s).to eq('0')
      expect(subnet.last.to_s).to eq('2')
    end
  end

  context 'when create single address subnet' do
    it 'returns correct subnet' do
      loopback = Subnet.new(DummyAddress.new(1), DummyAddress.new(1))
      expect(loopback.first <=> loopback.last).to be_truthy
      expect(loopback.first <=> 1).to be_truthy
    end
  end

  context 'when first > last' do
    it 'returns correct subnet' do
      subnet = Subnet.new(DummyAddress.new(2), DummyAddress.new(0))
      expect(subnet.first.to_s).to eq('0')
      expect(subnet.last.to_s).to eq('2')
    end
  end
end


RSpec.describe Subnet, '#split_on' do

  context 'when able to split into equal parts' do
    subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(5))
    splitted = subnet.split_on(3)

    it 'splits correctly' do
      expect(splitted.length).to eq(3)

      expect(splitted[0].to_s).to eq(Subnet.new(DummyAddress.new(0),DummyAddress.new(1)).to_s)
      expect(splitted[1].to_s).to eq(Subnet.new(DummyAddress.new(2),DummyAddress.new(3)).to_s)
      expect(splitted[2].to_s).to eq(Subnet.new(DummyAddress.new(4),DummyAddress.new(5)).to_s)
    end

  end

  context 'when last part should be smaller' do
    subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(4))
    splitted = subnet.split_on(3)

    it 'splits correctly' do
      expect(splitted.length).to eq(3)

      expect(splitted[0].to_s).to eq(Subnet.new(DummyAddress.new(0),DummyAddress.new(1)).to_s)
      expect(splitted[1].to_s).to eq(Subnet.new(DummyAddress.new(2),DummyAddress.new(3)).to_s)
      expect(splitted[2].to_s).to eq(Subnet.new(DummyAddress.new(4),DummyAddress.new(4)).to_s)
    end

  end

  context 'when last part can not be smaller' do

    context 'when part size > 1' do
      it 'splits correclty' do
        subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(8))
        splitted = subnet.split_on(4)

        expect(splitted.length).to eq(4)

        expect(splitted[0].to_s).to eq(Subnet.new(DummyAddress.new(0),DummyAddress.new(1)).to_s)
        expect(splitted[1].to_s).to eq(Subnet.new(DummyAddress.new(2),DummyAddress.new(3)).to_s)
        expect(splitted[2].to_s).to eq(Subnet.new(DummyAddress.new(4),DummyAddress.new(5)).to_s)
        expect(splitted[3].to_s).to eq(Subnet.new(DummyAddress.new(6),DummyAddress.new(8)).to_s)
      end
    end

    context 'when part size = 1' do
      it 'splits correclty' do
        subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(3))
        splitted = subnet.split_on(3)

        expect(splitted.length).to eq(3)

        expect(splitted[0].to_s).to eq(Subnet.new(DummyAddress.new(0),DummyAddress.new(0)).to_s)
        expect(splitted[1].to_s).to eq(Subnet.new(DummyAddress.new(1),DummyAddress.new(1)).to_s)
        expect(splitted[2].to_s).to eq(Subnet.new(DummyAddress.new(2),DummyAddress.new(3)).to_s)
      end
    end

  end

  context 'when passed <parts> param is greater than subnet size' do
    it 'raises ArgumentError' do
      subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(4))
      expect{subnet.split_on(6)}.to raise_exception(ArgumentError,/Subnet has.*elements only./)
    end
  end

  context 'when passed <parts> param is not valid' do
    subnet = Subnet.new(DummyAddress.new(0),DummyAddress.new(10))

    it 'raises exception' do
      expect{subnet.split_on(0)}.to raise_exception(ArgumentError)
      expect{subnet.split_on(-1)}.to raise_exception(ArgumentError)
      expect{subnet.split_on(nil)}.to raise_exception(ArgumentError)
      expect{subnet.split_on(7.24)}.to raise_exception(ArgumentError)
      expect{subnet.split_on('Zorro')}.to raise_exception(ArgumentError)
    end

  end

  context 'when  passed <parts> param equals to subnet size' do
    splitted = Subnet.new(DummyAddress.new(0),DummyAddress.new(10)).split_on(11)

    it 'splits correctly' do
      expect(splitted.length).to eq(11)
    end

    it 'has single address in part' do
      expect(splitted[0].size).to eq(1)
      expect(splitted[1].size).to eq(1)
      expect(splitted[10].size).to eq(1)
    end
  end

end

=begin

# TODO: граничный случай?
Не понимаю, как тестировать йельд. Передавать пустой блок?

=end

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

  it 'return correct string' do
    expect(Subnet.new(DummyAddress.new(0),DummyAddress.new(1)).to_s).to eq('0-1')
  end

  context 'when subnet has only one address' do
    it 'returns correct string' do
      expect(Subnet.new(DummyAddress.new(0),DummyAddress.new(0)).to_s).to eq('0-0')
    end
  end
=begin

# TODO: дублируется логика тестируемого метода, лучше писать явно
Тогда этот тест вообще можно удалить, он будет дублировать один из верхних.

  it 'uses to_s method of childs ' do
    first = DummyAddress.new(2)
    last = DummyAddress.new(12)
    expect(Subnet.new(first,last).to_s).to eq(first.to_s + '-' + last.to_s)
  end

=end
end


RSpec.describe Subnet, '#size' do
  it 'returns correct size' do
      expect(Subnet.new(DummyAddress.new(0), DummyAddress.new(1)).size).to eq(2)
  end

  context 'when subnet has only one address' do
    it 'returns correct size' do
      loopback = Subnet.new(DummyAddress.new(0), DummyAddress.new(0))
      expect(loopback.size).to eq(1)
    end
  end
end



RSpec.describe Subnet, '#include' do
=begin

# TODO: граничные случаи?
Что в данном тесте можно принять за граничные значения?
Отрицательных адресов не бывает, максимального адреса тоже.
Добавил тесты для подсети из одного адреса, на этом мои полномочия всё.

=end


=begin

# TODO: слишком большая подсеть для этих кейсов
Почему это проблема? Цифры простые и понятные. Не вижу разницы между 1-2-3 и 1-5-10

=end

  context 'when pass argument of different type' do
    it 'throws TypeError exception' do
      subnet = Subnet.new(DummyAddress.new(1), DummyAddress.new(10))
      expect{subnet.includes?(0)}.to raise_exception(TypeError)
    end
  end

  context 'when subnet has 2 or more elements' do
    subnet = Subnet.new(DummyAddress.new(1), DummyAddress.new(10))

    it 'includes addresses from first to last' do
      expect(subnet.includes?(DummyAddress.new(1))).to be_truthy
      expect(subnet.includes?(DummyAddress.new(5))).to be_truthy
      expect(subnet.includes?(DummyAddress.new(10))).to be_truthy
    end

    it "doesn't include addresses beyound the boundary " do
      expect(subnet.includes?(DummyAddress.new(0))).to be_falsey
      expect(subnet.includes?(DummyAddress.new(11))).to be_falsey
    end
  end

  context 'when subnet has only one address' do
    subnet = Subnet.new(DummyAddress.new(1), DummyAddress.new(1))

    it 'includes this address' do
      expect(subnet.includes?(DummyAddress.new(1))).to be_truthy
    end

    it 'does not include any other' do
      expect(subnet.includes?(DummyAddress.new(0))).to be_falsey
      expect(subnet.includes?(DummyAddress.new(2))).to be_falsey
    end
  end
end

RSpec.describe Subnet, '#intersects?' do

=begin

  # TODO: можно подсети поменьше ;)
  И опять я задам вопрос "а что это изменит?" :)

=end


  #   |subnet_left|      |subnet_right|
  #           |subnet_middle|



  subnet_left = Subnet.new(DummyAddress.new(0), DummyAddress.new(3))
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

  context 'when both subnets are loopbacks' do
    it 'intersect each other' do
      subnet_0 = Subnet.new(DummyAddress.new(0),DummyAddress.new(0))
      expect(subnet_0.intersects?(subnet_0)).to be_truthy
    end
  end

  context 'when one subnet is loopback' do
    subnet_0 = Subnet.new(DummyAddress.new(0),DummyAddress.new(0))

    it 'intersects with bigger subnet' do
      expect(subnet_left.intersects?(subnet_0)).to be_truthy
      expect(subnet_0.intersects?(subnet_left)).to be_truthy
    end

    it 'does not intersect with bigger subnet' do
      expect(subnet_0.intersects?(subnet_middle)).to be_falsey
      expect(subnet_middle.intersects?(subnet_0)).to be_falsey
    end
  end

end