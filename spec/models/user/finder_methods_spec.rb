require 'spec_helper'

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
