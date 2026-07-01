FactoryBot.define do
  factory :post do
    title { 'タイトル1' }
    content { '本文1' }
    # 定型
    association :user, factory: :user
  end
end
