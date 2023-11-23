FactoryBot.define do 
  factory :chapter do
    name { Faker::Name.name }
    seq { Faker::Number.between(from: 1, to: 50) }

    course
  end
end