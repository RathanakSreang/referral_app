alice = User.create name: "alice",
                    email: "alice@email.com",
                    password: "1234567890"


rederal = alice.rederals.create referrer_credit: 10,
                                user_credit: 10,
                                usage_count: 0,
                                reward_per_usage: 5

6.times do |n|
  user = User.create name: "user #{n}",
                    email: "user_#{n}@email.com",
                    password: "1234567890",
                    referral_code: rederal.code
end
