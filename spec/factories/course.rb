FactoryBot.define do 
  factory :course do 
    name { Faker::Name.name }
    lecturer { Faker::Name.name }
    desc { Faker::Lorem.paragraph }
  end
end