class AddJtiAndNameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :jti, :string
    add_index :users, :jti, unique: true
    add_column :users, :name, :string
    add_column :users, :reset_password_otp, :string
    add_column :users, :reset_password_otp_sent_at, :datetime
    add_column :users, :role, :integer, default: 1, null: false 
  end
end
