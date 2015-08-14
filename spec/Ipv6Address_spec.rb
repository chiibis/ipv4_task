require 'iputils'

RSpec.describe Ipv6Address, "#initialize" do
  context 'when generate from string' do
    it 'returns correct num value' do
      expect(Ipv6Address.new('0000:0000:0000:0000:0000:0000:0000:0000').to_i).to eq(0)
      expect(Ipv6Address.new('0000:0000:0000:0000:0000:0000:0000:0001').to_i).to eq(1)
      expect(Ipv6Address.new('0000:0000:0000:0000:0000:0000:0000:000f').to_i).to eq(15)
    end

    it 'handle upper case' do
      expect(Ipv6Address.new('FFFF:ffff:ffff:FFFF:ffff:ffff:ffff:ffff')).to eq(256**16-1)
    end

    context 'when max allowed value' do
      it 'returns max num value' do
        expect(Ipv6Address.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff').to_i).to eq(256**16-1)
      end
    end

    context 'when using :: notation' do
      context 'when one hextet is missing' do
        it 'replace missing hextet with zeros' do
          expect(Ipv6Address.new('::1111:1111:1111:1111:1111:1111:1111').to_s).to eq('0000:1111:1111:1111:1111:1111:1111:1111')
          expect(Ipv6Address.new('1111:1111:1111::1111:1111:1111:1111').to_s).to eq('1111:1111:1111:0000:1111:1111:1111:1111')
          expect(Ipv6Address.new('1111:1111:1111:1111:1111:1111:1111::').to_s).to eq('1111:1111:1111:1111:1111:1111:1111:0000')
        end
      end

      context 'when many hextets are missing' do
        it 'replace missing hextets with zeros' do
          expect(Ipv6Address.new('1111:1111::1111:1111').to_s).to eq('1111:1111:0000:0000:0000:0000:1111:1111')
          expect(Ipv6Address.new('::1111:1111').to_s).to eq('0000:0000:0000:0000:0000:0000:1111:1111')
          expect(Ipv6Address.new('ffff::').to_s).to eq('ffff:0000:0000:0000:0000:0000:0000:0000')
        end
      end

      context 'when all hextets are missing' do
        it 'returns 0' do
          expect(Ipv6Address.new('::').to_i).to eq(0)
        end
      end
    end

    context 'when string is not valid' do
      context 'when has more than one ::' do
        it 'throws exception' do
          expect {Ipv6Address.new('1:::')}.to raise_exception(ArgumentError)
          expect {Ipv6Address.new(':::::::')}.to raise_exception(ArgumentError)
          expect {Ipv6Address.new('1111:1111::1111:1111::1111:1111')}.to raise_exception(ArgumentError)
        end
      end

      context 'when has invalid literals' do
        it 'throws exception' do
          expect {Ipv6Address.new('1111:1111:HHHH:1111:1111:1111:1111:1111')}.to raise_exception(ArgumentError)
        end
      end

      context 'when hextet has more than 4 characters ' do
        it 'throws exception' do
          expect {Ipv6Address.new('0000001::')}.to raise_exception(ArgumentError)
        end
      end

      context 'when some hextets are missing' do
        it 'throws exception' do
          expect {Ipv6Address.new('1111:1111:1111:1111:1111:1111:1111')}.to raise_exception(ArgumentError)
        end
      end
    end
  end

  context 'when generates from integer' do
    it 'returns correct string value' do
      expect(Ipv6Address.new(0).to_s).to eq('0000:0000:0000:0000:0000:0000:0000:0000')
      expect(Ipv6Address.new(1).to_s).to eq('0000:0000:0000:0000:0000:0000:0000:0001')
      expect(Ipv6Address.new(15).to_s).to eq('0000:0000:0000:0000:0000:0000:0000:000f')

=begin
      # TODO: отдельный it
      expect(Ipv6Address.new(256**16-1).to_s).to eq('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')
      Вынес, но не понял смысл. Почему не катит за 0-1-n? Потому что Boundary value? Тогда, наверное, стоит еще и ноль выносить.
=end
    end

    context 'when max allowed integer' do
      it 'returns correct string value' do
        expect(Ipv6Address.new(256**16-1).to_s).to eq('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')
      end
    end

    context 'when invalid value passed' do
      it 'throws exception' do

=begin

# TODO: лучше без константы.
Не согласен. С константой сразу понятно, почему это значение невалидное. А без нее это "просто число".
Вариант написать комментарий или вынести в отдельный контекст "когда слишком большое значение", но на мой взгляд и так нормально.

=end
        too_big = 256**16
        expect{Ipv6Address.new(too_big)}.to raise_exception(ArgumentError)
        expect{Ipv6Address.new(-1)}.to raise_exception(ArgumentError)
        expect{Ipv6Address.new(nil)}.to raise_exception(ArgumentError)
      end
    end
  end
end


RSpec.describe Ipv6Address, "#-(another)" do
  context 'when addresses are the same' do
    it 'returns 1' do
      ip = Ipv6Address.new('::8')
      expect(ip-ip).to eq(1)
    end
  end

  context 'when first is greater' do
    it 'returns correct amount' do
      ip = Ipv6Address.new('::8')
      expect(ip-Ipv6Address.new('::7')).to eq(2)
      expect(ip-Ipv6Address.new('::5')).to eq(4)
    end
  end

  context 'when second is lower' do
    it 'returns correct amount' do
      ip = Ipv6Address.new('::7')
      expect(ip-Ipv6Address.new('::8')).to eq(2)
      expect(ip-Ipv6Address.new('::9')).to eq(3)
    end
  end

  context 'boundary values' do
    it 'returns correct amount' do
      max_ip = Ipv6Address.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')
      min_ip = Ipv6Address.new('::')

      expect(max_ip - min_ip).to eq(256**16)
      expect(min_ip - max_ip).to eq(256**16)
    end
  end
end


RSpec.describe Ipv6Address, "#<=>" do
  base_ip = Ipv6Address.new('::1')

  context 'when addresses are the same' do
    it 'returns 0' do
      expect(base_ip <=> base_ip).to equal(0)
    end
  end

  context 'when first is lower' do
    it 'returns -1' do
      expect(base_ip <=> Ipv6Address.new('::2')).to equal(-1)
    end
  end

  context 'when first is greater' do
    it 'returns 1' do
      expect(base_ip <=> Ipv6Address.new('::0')).to equal(1)
    end
  end
end


RSpec.describe Ipv6Address, '#to_s' do
  it 'returns correct string value'  do
    expect(Ipv6Address.new(256**16-1).to_s).to eq('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')
  end
end


RSpec.describe Ipv6Address, '#to_i' do
  it 'returns correct integer value' do
    expect(Ipv6Address.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff').to_i).to eq(256**16-1)
  end
end


RSpec.describe Ipv6Address, '#next' do
  it 'returns next address' do
    expect(Ipv6Address.new('::a').next <=> Ipv6Address.new('::b')).to equal(0)
  end

  context 'when ip out of range' do
    it 'raises an exception' do
      expect {Ipv6Address.new(256**16-1).next}.to raise_error('Error: IP is out of range')
    end
  end
end


RSpec.describe Ipv6Address, '#prev' do
  it 'returns previous address' do
    expect(Ipv6Address.new('::7').prev <=> Ipv6Address.new('::6')).to equal(0)
  end

  context 'when ip out of range' do
    it 'raises an exception' do
      expect {Ipv6Address.new(0).prev}.to raise_error('Error: IP is out of range')
    end
  end
end


RSpec.describe Ipv6Address, '#+(step)' do
  context 'when step is positive' do
    it 'returns correct ip' do
      expect(Ipv6Address.new('::2')+(0)).to eq(Ipv6Address.new('::2').to_i)
      expect(Ipv6Address.new('::2')+(1)).to eq(Ipv6Address.new('::3').to_i)
      expect(Ipv6Address.new('::2')+(3)).to eq(Ipv6Address.new('::5').to_i)
    end

    context 'when step is too big' do
      it 'raises error' do
        expect {Ipv6Address.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')+(1)}.to raise_error('Error: IP is out of range')
      end
      end
  end

  context 'when step is negative' do
    it 'returns correct ip' do
      expect(Ipv6Address.new('::5')+(-1)).to eq(Ipv6Address.new('::4').to_i)
      expect(Ipv6Address.new('::5')+(-3)).to eq(Ipv6Address.new('::2').to_i)
    end

    context 'when step is too big' do
      it 'raises error' do
        expect {Ipv6Address.new('::')+(-1)}.to raise_error('Error: IP is out of range')
      end
    end
  end
end