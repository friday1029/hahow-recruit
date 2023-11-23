FactoryBot.define do 
  factory :unit do 
    name { Faker::Name.name }
    desc { Faker::Lorem.paragraph }
    content { Faker::Lorem.paragraph }
    seq { Faker::Number.between(from: 1, to: 50) }
    
    chapter
  end
end