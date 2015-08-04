require 'iputils'

RSpec.describe Range, '#to_subnet' do

  context 'with correct data' do

    it 'returns Subnet' do
      expect((1...5).to_subnet).to be_instance_of Subnet
    end

  end

end