class CreateReferrals < ActiveRecord::Migration[6.0]
  def change
    create_table :referrals do |t|
      t.integer   :referrer_id
      t.float     :referrer_credit, default: 0.0
      t.float     :user_credit, default: 0.0
      t.integer   :usage_count, default: 0
      t.integer   :reward_per_usage, default: 0
      t.string    :code

      t.timestamps
    end

    add_index :referrals, :code,  unique: true
    add_index :referrals, :referrer_id
  end
end
