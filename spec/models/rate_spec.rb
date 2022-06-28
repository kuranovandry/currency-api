# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rate, type: :model do
  let(:rate) { build :rate }
  let(:second_rate) { build :rate }

  it 'is valid with valid attributes' do
    expect(rate).to be_valid
  end

  it 'is not valid without a code' do
    rate.code = nil
    expect(rate).not_to be_valid
  end

  it 'is not valid without a date' do
    rate.date = nil
    expect(rate).not_to be_valid
  end

  it 'is not valid without a average' do
    rate.average = nil
    expect(rate).not_to be_valid
  end

  it 'is not valid without a currency_name' do
    rate.currency_name = nil
    expect(rate).not_to be_valid
  end

  it 'is not valid when record with the same date and currency exists' do
    expect(rate).to be_valid
    rate.save!
    expect(second_rate).not_to be_valid
  end
end
