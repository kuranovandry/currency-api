# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::RatesController, type: :controller do
  let(:rate) { create :rate }

  describe 'GET index' do
    it 'has a 200 status code' do
      get :index
      expect(response.status).to eq(200)
    end

    it 'has correct data in response content type json' do
      rate
      get :index
      attributes = JSON.parse(response.body).dig('data', 0, 'attributes')
      expect(attributes['date']).to eq Time.zone.today.to_s
    end

    it 'returns a 422 status' do
      get :index, params: { date: '0000-0000' }
      expect(response.status).to eq(422)
    end
  end
end
