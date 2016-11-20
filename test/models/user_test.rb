require 'test_helper'


describe User do

  let(:user) { create(:user) }

  describe "with valid information" do
    it do
      user = User.new(attributes_for(:user))
      assert user.save
    end
  end

  describe "attributes" do
    it "name is required" do
      proc = Proc.new do
        user.update!(name: '')
      end
      proc.must_raise ActiveRecord::RecordInvalid
    end
  end
end
