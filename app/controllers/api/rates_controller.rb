# frozen_string_literal: true

module Api
  class RatesController < ApplicationController
    before_action :check_ip_address, only: [:index]
    before_action :check_date_params, only: [:index]

    def index
      render json: Rates::Index.new(params).perform
    end

    private

    def check_date_params
      return unless data_params?

      %i[date end_date start_date].map do |date_symbol_name|
        next if params[date_symbol_name].blank?

        Date.parse(params[date_symbol_name])
      rescue ArgumentError
        return render json:   { status: 422, message: t('.invalid_date_format', date: params[date_symbol_name]) },
                      status: :unprocessable_entity
      end
    end

    def data_params?
      (params[:start_date] && params[:end_date]) || params[:date]
    end
  end
end
