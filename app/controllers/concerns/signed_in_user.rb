# Controller Concern Example
# Place this in controllers that have all actions having a signed in user
# include SignedInUser
module SignedInUser
  extend ActiveSupport::Concern

  included do
    before_action :signed_in_user
  end
end
