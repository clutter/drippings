FactoryBot.define do
  factory :scheduling, class: 'Drippings::Scheduling' do
    name { "Greetings" }
    resource factory: :lead

    trait :processed do
      processed_at { 1.hour.ago }
    end
  end
end
