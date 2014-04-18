require 'spec_helper'

describe MicropostDecorator do
  let(:user) { FactoryGirl.create(:user) }

  it "prints time ago in words" do
    micropost = Micropost.create(content: "Lorem ipsum", user_id: user.id)
    expect(micropost.decorate.posted_ago).to match /Posted less than a minute ago./
  end
end
