# frozen_string_literal: true

FactoryBot.define do
  factory :rate do
    date { Time.zone.today }
    code { 'USD' }
    currency_name { 'U.S. dollar' }
    average { '5.1400' }
  end
end
