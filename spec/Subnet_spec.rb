require 'iputils'

RSpec.describe Subnet, '#includes' do
  it 'should include' do
    subnet = Subnet.new("192.168.0.1", "192.168.0.30")
    expect(subnet.includes?("192.168.0.15")).to be_truthy
  end

  it 'should not include' do
    subnet = Subnet.new("192.168.0.1", "192.168.0.30")
    expect(subnet.includes?("192.168.0.31")).to be_falsey
  end
end



=begin

it 'should not ivntersects' do
    subnet1 = Subnet.new("127.0.0.1", "127.0.0.10")
    subnet2 = Subnet.new("127.0.0.11", "127.0.0.20")

    intersects = subnet1.intersects?(subnet2)
    expect(intersects).to be_falsey
end


require 'bowling'

RSpec.describe Bowling, "#score" do
  context "with no strikes or spares" do
    it "sums the pin count for each roll" do
      bowling = Bowling.new
      20.times {bowling.hit(4)}
      expect(bowling.score).to eq 80
    end
  end
end

=end