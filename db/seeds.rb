alice = User.create name: "alice",
                    email: "alice@email.com",
                    password: "1234567890"


rederal = alice.build_referral
rederal.save

6.times do |n|
  user = User.create name: "user #{n}",
                    email: "user_#{n}@email.com",
                    password: "1234567890",
                    referral_code: rederal.code
end
