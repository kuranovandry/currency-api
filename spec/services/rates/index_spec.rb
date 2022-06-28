# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rates::Index do
  describe '#perform' do
    let(:today) { Time.zone.today }

    before do
      30.times do |num|
        create(:rate, date: today - num.days)
        create(:rate, date: today - num.days, code: 'CAD')
      end
    end

    it 'return correct date' do
      yesterday = today - 1.day
      result = described_class.new({}).perform
      expect(result.instance_values['resource'].first.date).to eq today
      result = described_class.new({ date: yesterday }).perform
      expect(result.instance_values['resource'].first.date).to eq yesterday
      result = described_class.new({ end_date: today, start_date: yesterday }).perform
      expect(result.instance_values['resource'].pluck(:date).uniq).to include(today).and include(yesterday)
    end

    it 'return records for today by default' do
      result = described_class.new({}).perform
      dates = result.instance_values['resource'].pluck(:date).uniq
      expect(dates.count).to eq 1
      expect(dates.first).to eq Time.zone.today
    end

    it 'return records for specified date' do
      specified_date = today - 10.days
      result = described_class.new({ date: specified_date }).perform
      dates = result.instance_values['resource'].pluck(:date).uniq
      expect(dates.count).to eq 1
      expect(dates.first).to eq specified_date
    end

    it 'return records for specified date range' do
      start_date = today - 10.days
      end_date = today
      result = described_class.new({ start_date: start_date, end_date: end_date }).perform
      rates = result.instance_values['resource']
      expect(rates.count).to eq 22 # we create 2 records for each day
      expect(rates.pluck(:date).uniq.min).to eq start_date
      expect(rates.pluck(:date).uniq.max).to eq end_date
    end

    it 'return records for specified currency' do
      currency = 'USD'
      result = described_class.new({ currency: currency }).perform
      rates = result.instance_values['resource']
      expect(rates.count).to eq 1
      expect(rates.pluck(:code).uniq.first).to eq currency
    end
  end
end
