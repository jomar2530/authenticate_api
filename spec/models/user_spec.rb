require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  context "validations" do
    it "is not valid without username" do
      user.username = nil
      expect(user).to_not be_valid
      expect(user.errors).to be_present
      expect(user.errors.to_h.keys).to include(:username)
    end

    it "is not valid without password" do
      user.password = nil
      expect(user).to_not be_valid
      expect(user.errors).to be_present
      expect(user.errors.to_h.keys).to include(:password)
    end

    it "should have a unique username" do
      user.save!
      new_user = User.new(username: 'JohnSmith1234', password: '12345')
      new_user.should_not be_valid
      new_user.errors[:username].should include("has already been taken")
    end
  end

  context "Check Password" do
    it "should authenticate password" do
      user.save!

      valid_user = User.find_by_username(user.username).try(:check_password, 'PASSWORD')
      expect(valid_user).to eq false
    end
  end
end
