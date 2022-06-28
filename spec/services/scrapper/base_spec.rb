# frozen_string_literal: true

# rubocop:disable RSpec/AnyInstance

require 'rails_helper'

RSpec.describe Scrapper::Base do
  before do
    Faraday.default_adapter = :test
    allow_any_instance_of(Faraday::Adapter::Test).to receive(:stubs).and_return(request_stub)
  end

  let(:body) do
    [{
      effectiveDate: Time.zone.today.to_s,
      rates:         [
        {
          currency: 'USD',
          mid:      '10',
          code:     'USD'
        }
      ]
    }]
  end
  let(:default_table_name) { 'A' }

  let(:request_stub) do
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get([Scrapper::Base::NBP_BASE_URL, default_table_name].join) { |_| [200, {}, body.to_json] }
    end
  end

  describe '#perform' do
    it 'added all rate to DB' do
      described_class.new(default_table_name).perform
      expect(Rate.count).to eq 1
    end
  end
end
# rubocop:enable RSpec/AnyInstance
