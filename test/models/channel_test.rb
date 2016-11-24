require 'test_helper'


describe Channel do

  describe "attributes" do
    let(:channel) { build(:channel) }

    it "name is required" do
      proc = Proc.new do
        channel.name = ''
        channel.validate!
      end
      proc.must_raise ActiveRecord::RecordInvalid
    end

  end
end
