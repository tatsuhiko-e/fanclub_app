FactoryBot.define do
  factory :relationship do
    user { nil }
    follow { "" }
    g { "MyString" }
    model { "MyString" }
    Relationship { "MyString" }
    user { nil }
    follow { nil }
  end
end
