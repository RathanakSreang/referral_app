class CreateAccessTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :access_tokens do |t|
      t.integer   :user_id
      t.string    :token, default: ""
      t.datetime  :expires_at
      t.timestamps
    end

    add_index :access_tokens, :token,  unique: true
    add_index :access_tokens, :expires_at
    add_index :access_tokens, :user_id
  end
end
