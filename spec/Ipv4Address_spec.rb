require 'iputils'


RSpec.describe Ipv4Address, "#initialize" do
  context 'generate from string' do

    it 'correct num value' do # TODO: "it correct num value" - не читается
      expect(Ipv4Address.new('0.0.0.0').to_i).to eq(0)
      expect(Ipv4Address.new('192.168.1.1').to_i).to eq(3232235777) # TODO: что за кейс?
      expect(Ipv4Address.new('255.255.255.255').to_i).to eq(2**32-1)
    end

  end

  context 'generates from integer' do

    it 'correct string value' do # TODO: - не читается
      expect(Ipv4Address.new(0).to_s).to eq('0.0.0.0')
      expect(Ipv4Address.new(3232235777).to_s).to eq('192.168.1.1') # TODO: что за кейс?
      expect(Ipv4Address.new(2**32-1).to_s).to eq('255.255.255.255')
    end

    it 'throws ex if invalid value' do
      expect{Ipv4Address.new(2**32)}.to raise_exception(ArgumentError, /is not valid IPv4 numeric representation/)
      expect{Ipv4Address.new(-111)}.to raise_exception(ArgumentError, /is not valid IPv4 numeric representation/) # TODO: -1 - граничное значение, -111 нет.
      expect{Ipv4Address.new(nil)}.to raise_exception(ArgumentError, /is not valid IPv4 numeric representation/)
    end
  end
end

# TODO: string_to_numeric - лучше ему быть приватным методом. Если нужно тестировать конструктор со строками и числами - лучше именно такие тесты и писать
RSpec.describe Ipv4Address, "#string_to_numeric" do
  test_ip = Ipv4Address.new(0)

  it 'convert correctly' do
    expect(test_ip.class.string_to_numeric('0.0.0.0')).to eq(0) # TODO: копия строки #19
    expect(test_ip.class.string_to_numeric('81.95.27.2')).to eq(1365187330) # TODO: что за кейс?
    expect(test_ip.class.string_to_numeric('255.255.255.255')).to eq(2**32-1)
  end

  context 'throws exception' do

    # TODO: слишком специфичные разные кейсы - лучше в отдельные it разбить
    it 'invalid format' do # TODO: - не читается.
      expect {test_ip.class.string_to_numeric('192.abbb.0.1')}.to raise_exception(ArgumentError, /is not valid IPv4 address/)  # TODO: к сообщениям  ошибок лучше не привязываться, т.к. они часто меняются. Если это не критично для кейса.
      expect {test_ip.class.string_to_numeric('1.1.00000.000001')}.to raise_exception(ArgumentError, /is not valid IPv4 address/) # TODO: 1.1.0000.000001 чем-то лучше чем 1.1.1.0001 ?
      expect {test_ip.class.string_to_numeric('1...1')}.to raise_exception(ArgumentError, /is not valid IPv4 address/)
    end

    it 'too few octets' do # TODO: а где too much octets? btw, 'it too few' - не читается.
      expect {test_ip.class.string_to_numeric('....')}.to raise_exception(ArgumentError, /is not valid IPv4 address/)
      expect {test_ip.class.string_to_numeric('192.168.0')}.to raise_exception(ArgumentError, /is not valid IPv4 address/)
    end

    it 'octet is greater, than 255' do # TODO: - не читается.
      expect {test_ip.class.string_to_numeric('192.168.999.0')}.to raise_exception(ArgumentError, /is not valid IPv4 address/) # TODO: 999 - не граничное значение для октета.
    end
  end
end

# TODO: граничные значения?
RSpec.describe Ipv4Address, "#-(another)" do
  context 'first address is greater' do
    it 'amount is correct' do # TODO: - не читается.
      ip = Ipv4Address.new('0.0.0.7')
      expect(ip-ip).to eq(1) # TODO: отдельный кейс - отдельный it
      expect(ip-Ipv4Address.new('0.0.0.6')).to eq(2) # TODO: что за кейс?
      expect(ip-Ipv4Address.new('0.0.0.5')).to eq(3) # TODO: что за кейс?
    end
  end

  context 'second address is greater' do
    it 'amount is correct' do # TODO: - не читается.
      ip = Ipv4Address.new('0.0.0.7')
      expect(ip-ip).to eq(1) # TODO: копия строки 65
      expect(ip-Ipv4Address.new('0.0.0.8')).to eq(2) # TODO: что за кейс?
      expect(ip-Ipv4Address.new('0.0.0.9')).to eq(3) # TODO: что за кейс?
    end
  end

  context 'boundary values' do
    it 'amount is correct' do # TODO: - не читается.
      expect(Ipv4Address.new('255.255.255.255') - Ipv4Address.new('0.0.0.0')).to eq(2**32)
      expect(Ipv4Address.new('0.0.0.0') - Ipv4Address.new('255.255.255.255')).to eq(2**32)
    end
  end
end


RSpec.describe Ipv4Address, '#<=>' do
  # TODO: три разных кейса - три разных it
  it 'main success' do # TODO: - не читается.
    expect(Ipv4Address.new('0.0.0.1') <=> Ipv4Address.new('0.0.0.1')).to equal(0)
    expect(Ipv4Address.new('0.0.0.0') <=> Ipv4Address.new('0.0.0.3')).to equal(-1)
    expect(Ipv4Address.new('0.0.0.3') <=> Ipv4Address.new('0.0.0.0')).to equal(1)
  end
end


RSpec.describe Ipv4Address, '#to_s' do
  it 'is string' do
    expect(Ipv4Address.new('1.1.1.1').to_s).to be_instance_of(String) # TODO: lol-тест
  end

  it 'correct transformation'  do
    expect(Ipv4Address.new(2**32-1).to_s).to eq('255.255.255.255') # TODO: только одна граница, где остальные? как это пересекается с тестами на конструхтор?
  end
end


RSpec.describe Ipv4Address, '#to_i' do
  it 'is integer' do
    expect(Ipv4Address.new('1.1.1.1').to_i).to be_a_kind_of(Numeric) # TODO: lol-тест
  end

  it 'correct transformation'  do # TODO: - не читается.
    expect(Ipv4Address.new('255.255.255.255').to_i).to eq(2**32-1) # TODO: только одна граница, где остальные? как это пересекается с тестами на конструхтор?
  end
end


# TODO: не все граничные значения учитываются
RSpec.describe Ipv4Address, '#next' do

  it 'main success' do # TODO: - не читается.
    expect(Ipv4Address.new('0.0.0.1').next <=> Ipv4Address.new('0.0.0.2')).to equal(0) # TODO: кейс сомнительный.
  end

  context 'when ip out of range' do
    it 'raise an exception' do
      expect {Ipv4Address.new('255.255.255.255').next}.to raise_error('Error: IP is out of range')
    end
  end

end

# TODO: не все граничные значения учитываются
RSpec.describe Ipv4Address, '#prev' do

  it 'main success' do # TODO: - не читается.
    expect(Ipv4Address.new('0.0.0.8').prev <=> Ipv4Address.new('0.0.0.7')).to equal(0) # TODO: кейс сомнительный.
  end

  context 'when ip out of range' do
    it 'raise an exception' do
      expect {Ipv4Address.new('0.0.0.0').prev}.to raise_error('Error: IP is out of range')
    end
  end

end


RSpec.describe Ipv4Address, '#+(step)' do

  context 'when step is positive' do
    it 'main success' do # TODO: - не читается.
      expect(Ipv4Address.new('0.0.0.8')+(0)).to eq(Ipv4Address.new('0.0.0.8').to_i)
      expect(Ipv4Address.new('0.0.0.8')+(1)).to eq(Ipv4Address.new('0.0.0.9').to_i)
      expect(Ipv4Address.new('0.0.0.8')+(3)).to eq(Ipv4Address.new('0.0.0.11').to_i)
    end

    it 'too big step raises an exception' do # TODO: - не читается.
      expect {Ipv4Address.new('255.255.255.250')+(10)}.to raise_error('Error: IP is out of range') # TODO: что за кейс? явно не граничный
    end

  end

  context 'when step is negative number' do
    it 'main success' do # TODO: - не читается.
      expect(Ipv4Address.new('0.0.0.8')+(-1)).to eq(Ipv4Address.new('0.0.0.7').to_i) # TODO: -1? слишком круто для main success
      expect(Ipv4Address.new('0.0.0.8')+(-3)).to eq(Ipv4Address.new('0.0.0.5').to_i)
    end

    it 'too big step raises an exception' do # TODO: - не читается.
      expect {Ipv4Address.new('0.0.0.8')+(-10)}.to raise_error('Error: IP is out of range') # TODO: что за кейс? явно не граничный
    end
  end

end


