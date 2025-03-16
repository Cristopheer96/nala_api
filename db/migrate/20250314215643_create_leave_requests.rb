# frozen_string_literal: true

# This migration creates the leave_requests table with references to user.
# It includes columns for leave_type, start_date, end_date, status, and notes.
# Additionally, it adds an index on user_id, leave_type, start_date, and end_date to improve performance this 
# is helpful to filters.
class CreateLeaveRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :leave_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :leave_type
      t.date :start_date
      t.date :end_date
      t.string :status, default: 'pendiente'
      t.text :notes

      t.timestamps
    end

    add_index :leave_requests, %i[user_id leave_type start_date end_date status]
  end
end
