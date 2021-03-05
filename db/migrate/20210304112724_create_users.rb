class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string  :name, default: ""
      t.string  :email, default: ""
      t.string  :password_digest
      t.float   :balance, default: 0.0
      t.string  :referral_code
      t.timestamps
    end

    add_index :users, :email,  unique: true
  end
end
