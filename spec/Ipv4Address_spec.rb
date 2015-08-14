require 'iputils'


RSpec.describe Ipv4Address, "#initialize" do

  context 'when generate from string' do
    it 'converts correctly' do
      expect(Ipv4Address.new('0.0.0.0').to_i).to eq(0)

      # expect(Ipv4Address.new('192.168.1.1').to_i).to eq(3232235777) # TODO: что за кейс?
      # просто взятое наобум значение.
      # я переделаю, но реально не понимаю почему тестировать реальный айпи плохо.

      expect(Ipv4Address.new('0.0.0.5').to_i).to eq(5)
      expect(Ipv4Address.new('255.255.255.255').to_i).to eq(2**32-1)
    end

    context 'when string is not valid' do
      context 'when string contains letters' do
        it 'raises ArgumentError' do
          expect {Ipv4Address.new('192.abbb.0.1')}.to raise_exception(ArgumentError)
        end
      end
      context 'when octet contains >3 digits' do
        it 'raises ArgumentError' do
          expect {Ipv4Address.new('1.1.1.0001')}.to raise_exception(ArgumentError)
        end
      end
      context 'when has empty octet' do
        it 'raises ArgumentError' do
          expect {Ipv4Address.new('1..1.1')}.to raise_exception(ArgumentError)
        end
      end
      context 'when >4 octets' do
        it 'raises ArgumentError' do
          expect {Ipv4Address.new('1.1.1.1.1')}.to raise_exception(ArgumentError)
        end
      end
      context 'when <4 octets' do
        it 'raises ArgumentError' do
          expect {Ipv4Address.new('192.168.0')}.to raise_exception(ArgumentError)
        end
      end
      context 'when octet is greater than 255' do
        it 'raises ArgumentError' do
          expect {Ipv4Address.new('1.1.1.266')}.to raise_exception(ArgumentError)
        end
      end
    end

  end

  context 'when generates from number' do
    it 'converts correctly' do
      expect(Ipv4Address.new(0).to_s).to eq('0.0.0.0')
      expect(Ipv4Address.new(5).to_s).to eq('0.0.0.5')
      expect(Ipv4Address.new(2**32-1).to_s).to eq('255.255.255.255')
    end

    it 'throws ArgumentError if not valid value' do
      expect{Ipv4Address.new(2**32)}.to raise_exception(ArgumentError, /is not valid IPv4 numeric representation/)
      expect{Ipv4Address.new(-1)}.to raise_exception(ArgumentError, /is not valid IPv4 numeric representation/)
      expect{Ipv4Address.new(nil)}.to raise_exception(ArgumentError, /is not valid IPv4 numeric representation/)
    end
  end

end




RSpec.describe Ipv4Address, "#-(another)" do
=begin

# TODO: граничные значения?
в конце теста есть два теста на граничные значения. Какие еще ожидаются?

=end

  context 'when addresses are the same' do
    it 'returns 1' do
      ip = Ipv4Address.new('0.0.0.7')
      expect(ip-ip).to eq(1)
    end
  end

  context 'when first is greater' do
    it 'returns correct amount' do
      ip = Ipv4Address.new('0.0.0.7')
      expect(ip-Ipv4Address.new('0.0.0.6')).to eq(2)
      expect(ip-Ipv4Address.new('0.0.0.5')).to eq(3)
=begin

# TODO: что за кейс?
# TODO: что за кейс?

Просто проверяю, что функция возвращает правильное количество вот на таких значениях

=end
    end
  end

  context 'first is lower' do
    it 'returns correct amount' do
      ip = Ipv4Address.new('0.0.0.7')
      expect(ip-Ipv4Address.new('0.0.0.8')).to eq(2)
      expect(ip-Ipv4Address.new('0.0.0.9')).to eq(3)
    end
  end

  context 'boundary values' do
    it 'returns correct amount' do
      expect(Ipv4Address.new('255.255.255.255') - Ipv4Address.new('0.0.0.0')).to eq(2**32)
      expect(Ipv4Address.new('0.0.0.0') - Ipv4Address.new('255.255.255.255')).to eq(2**32)
    end
  end

end


RSpec.describe Ipv4Address, '#<=>' do

  context 'when addresses are the same' do
    it 'returns 0' do
      expect(Ipv4Address.new('0.0.0.1') <=> Ipv4Address.new('0.0.0.1')).to equal(0)
    end
  end

  context 'when first is lower' do
    it 'returns -1' do
      expect(Ipv4Address.new('0.0.0.0') <=> Ipv4Address.new('0.0.0.3')).to equal(-1)
    end
  end

  context 'when first is greater' do
    it 'returns 1' do
      expect(Ipv4Address.new('0.0.0.3') <=> Ipv4Address.new('0.0.0.0')).to equal(1)
    end
  end

end


RSpec.describe Ipv4Address, '#to_s' do
  it 'returns correct string value'  do
=begin

# TODO: только одна граница, где остальные? как это пересекается с тестами на конструхтор?
Пересекается, ровно поэтому и одна проверка.
Не вижу смысла проверять для нескольких айпи, если корректно работает для одного.

=end

    expect(Ipv4Address.new(2**32-1).to_s).to eq('255.255.255.255')
  end
end


RSpec.describe Ipv4Address, '#to_i' do
  it 'returns correct integer value'  do
    expect(Ipv4Address.new('255.255.255.255').to_i).to eq(2**32-1)
  end
end


RSpec.describe Ipv4Address, '#next' do
=begin

# TODO: не все граничные значения учитываются
Не понимаю, какие надо еще. Что даст этот тест, если оно работает для 0.0.0.1?

=end

  it 'returns next address' do
=begin

# TODO: кейс сомнительный.
Почему?
Должно быть типа expect(Ipv4Address.new('0.0.0.1').next.to_s).to eq('0.0.0.2') ?
=end
    expect(Ipv4Address.new('0.0.0.1').next <=> Ipv4Address.new('0.0.0.2')).to equal(0)
  end

  context 'when ip out of range' do
    it 'raise an exception' do
      expect {Ipv4Address.new('255.255.255.255').next}.to raise_error('Error: IP is out of range')
    end
  end

end


RSpec.describe Ipv4Address, '#prev' do
  it 'returns previous address' do
    expect(Ipv4Address.new('0.0.0.8').prev.to_s).to eq('0.0.0.7')
  end

  context 'when ip out of range' do
    it 'raises an exception' do
      expect {Ipv4Address.new('0.0.0.0').prev}.to raise_error('Error: IP is out of range')
    end
  end
end


RSpec.describe Ipv4Address, '#+(step)' do
  context 'when step is positive' do
    it 'returns correct ip' do
      expect(Ipv4Address.new('0.0.0.8')+(0)).to eq(Ipv4Address.new('0.0.0.8').to_i)
      expect(Ipv4Address.new('0.0.0.8')+(1)).to eq(Ipv4Address.new('0.0.0.9').to_i)
      expect(Ipv4Address.new('0.0.0.8')+(3)).to eq(Ipv4Address.new('0.0.0.11').to_i)
    end

    context 'when step is too big' do
      it 'raises error' do
        expect {Ipv4Address.new('255.255.255.255')+(1)}.to raise_error('Error: IP is out of range')

=begin
        # TODO: что за кейс? явно не граничный
        expect {Ipv4Address.new('255.255.255.250')+(10)}.to raise_error('Error: IP is out of range')

        почему это плохо?
        тест читается, все цифры адекватные. Шаг достаточно явный, чтобы читающий сразу понял, что происходит.
        какие реальные (а не стилевые) преимущества у 255.255.255.255 + 1?
=end

      end
    end
  end

  context 'when step is negative' do

    it 'returns correct ip' do
      expect(Ipv4Address.new('0.0.0.8')+(-1)).to eq(Ipv4Address.new('0.0.0.7').to_i)
      expect(Ipv4Address.new('0.0.0.8')+(-3)).to eq(Ipv4Address.new('0.0.0.5').to_i)
    end

    context 'when step is too big' do
      it 'raises error' do
        expect {Ipv4Address.new('0.0.0.0')+(-1)}.to raise_error('Error: IP is out of range')
      end
    end

  end
end


