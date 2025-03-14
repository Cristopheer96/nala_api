# This migration adds two new columns to the users table: internal_id and leader_name.
# The internal_id column is a string that can be used to store an internal identifier for the user.
# The leader_name column is a string that can be used to store the name of the user's leader.
class AddInternalIdAndLeaderNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :internal_id, :string
    add_column :users, :leader_name, :string
  end
end
