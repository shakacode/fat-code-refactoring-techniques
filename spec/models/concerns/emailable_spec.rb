require 'spec_helper'


describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  describe "#email_domain" do
    it "should equal example.com" do
      expect(@user.email_domain).to eq("example.com")
    end
  end

  describe "Email Validation" do
    describe "when email is not present" do
      before { @user.email = " " }
      it { should_not be_valid }
    end

    describe "when email format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
        addresses.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).not_to be_valid
        end
      end
    end

    describe "when email format is valid" do
      it "should be valid" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end
    end

    describe "when email address is already taken" do
      before do
        user_with_same_email       = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end

      it { should_not be_valid }
    end
  end
end

describe "User email queries" do
  before do
    @u1 = FactoryGirl.create(:user, email: "foobar@baz.com")
    @u2 = FactoryGirl.create(:user, email: "foobaz@bar.com")
    @u3 = FactoryGirl.create(:user, email: "abcdef@ghi.com")
  end

  describe ".by_email" do
    context "Using lower case" do
      it "finds the correct user" do
        expect(User.by_email(@u2.email).id).to eq(@u2.id)
      end
    end

    context "Using wrong case" do
      it "finds the correct user" do
        expect(User.by_email(@u1.email.upcase).id).to eq(@u1.id)
      end
    end

    context "Using no user" do
      it "finds no user" do
        expect(User.by_email("junk")).to be_nil
      end
    end
  end

  describe ".by_email_wildcard" do
    context "Using lower case" do
      it "finds the correct user" do
        expect(User.by_email_wildcard("foo").pluck(:id)).to match_array([@u1.id, @u2.id])
      end
    end

    context "Using wrong case" do
      it "finds the correct user" do
        expect(User.by_email_wildcard("FoO").pluck(:id)).to match_array([@u1.id, @u2.id])
      end
    end

    context "Using no match" do
      it "finds the correct user" do
        expect(User.by_email_wildcard("junk")).to be_empty
      end
    end
  end
end

