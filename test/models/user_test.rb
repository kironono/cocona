require 'test_helper'


describe User do

  describe "with valid information" do
    it do
      user = User.new(attributes_for(:user))
      assert user.save
    end
  end

  describe "attributes" do

    let(:user) { build(:user) }

    it "name is required" do
      proc = Proc.new do
        user.name = ''
        user.validate!
      end
      proc.must_raise ActiveRecord::RecordInvalid
    end

    it "email is required" do
      proc = Proc.new do
        user.email = ''
        user.validate!
      end
      proc.must_raise ActiveRecord::RecordInvalid
    end

    it "password confirmation" do
      proc = Proc.new do
        user.password = 'password1'
        user.password_confirmation = 'password2'
        user.validate!
      end
      proc.must_raise ActiveRecord::RecordInvalid
    end
  end
end
