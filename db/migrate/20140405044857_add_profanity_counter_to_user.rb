class AddProfanityCounterToUser < ActiveRecord::Migration
  def change
    add_column :users, :profanity_count, :integer, default: 0
    add_column :users, :minor, :boolean, default: false
  end
end
