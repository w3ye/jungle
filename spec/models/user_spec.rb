require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'Validation' do

    before(:all) do
      ActiveRecord::Base.subclasses.each(&:delete_all)
    end

    it 'should be a valid user if password and password_confirmation match' do
      user = User.new(name: "Presly Dodson", email: "test@test.com", password: "123", password_confirmation: "123")
      user.save
      expect(user).to be_a User
    end

    it "should return an error if password and password_confirmation doesn't match" do
      user = User.new(name: "Presly Dodson", email: "test@test.com", password: "123", password_confirmation: "12abc")
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should return error if email is all caps" do
      user = User.new(name: "Presly Dodson", email: "TEST@TEST.COM", password: "123", password_confirmation: "123")
      user.save

      user_with_same_email =  User.new(name: "Dallen Jay", email: "test@test.com", password: "123", password_confirmation: "123")
      expect { user_with_same_email.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should return error if name or email is not provided" do
      user = User.new(name: nil , email: "TEST@TEST.COM", password: "123", password_confirmation: "123")
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)

      user = User.new(name: "Presly Dodson", email: nil, password: "123", password_confirmation: "123")
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should return error if the password length is under 3 characters or over 16 characters long" do
      user = User.new(name: nil , email: "TEST@TEST.COM", password: "12", password_confirmation: "12")
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)

      user = User.new(name: "Presly Dodson", email: "testnew@test.com", password: "12345678901234567", password_confirmation: "12345678901234567")
      user.save
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '.authenticate_with_credentials' do

    before(:all) do
      ActiveRecord::Base.subclasses.each(&:delete_all)
      user = User.new(name: "Presly Dodson", email: "test@test.com", password: "123", password_confirmation: "123")
      user.save!
    end

    it "should return user if the user exists and the password is correct" do
      auth_user = User.authenticate_with_credentials("test@test.com", "123")
      expect(auth_user).to be_a User

      auth_user = User.authenticate_with_credentials("tes@test.com", "123")
      expect(auth_user).to be_nil

      auth_user = User.authenticate_with_credentials("test@test.com", "1123")
      expect(auth_user).to be_nil
    end

    it "should return user if the emails contains padding of spaces before or after the address" do
      auth_user = User.authenticate_with_credentials("  test@test.com", "123")
      expect(auth_user).to be_a User
      auth_user = User.authenticate_with_credentials("  test@test.com   ", "123")
      expect(auth_user).to be_a User
    end

    it "should return user if the email is in a typed in a different case" do
      auth_user = User.authenticate_with_credentials("TEST@test.com", "123")
      expect(auth_user).to be_a User
      auth_user = User.authenticate_with_credentials("TEST@TEST.com", "123")
      expect(auth_user).to be_a User
    end
  end
end
