require 'test_helper'


describe User do

  let(:user) { users(:normal_user) }

  describe "attributes" do
    it "name is required" do
      proc = Proc.new do
        user.update!(name: '')
      end
      proc.must_raise ActiveRecord::RecordInvalid
    end

  end
end
