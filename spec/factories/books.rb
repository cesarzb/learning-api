FactoryBot.define do
    factory :book do
        title { Faker::Book.title }
        author
    end
end