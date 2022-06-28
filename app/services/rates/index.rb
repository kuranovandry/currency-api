# frozen_string_literal: true

module Rates
  class Index
    attr_reader :params

    %i[start_date end_date date currency].each do |meth|
      define_method(meth) { params[meth] }
    end

    def initialize(params)
      @params = params.compact_blank!
    end

    def perform
      RateSerializer.new(data_from_db)
    end

    private

    def data_from_db
      result = filter_by_date
      result = filter_by_currency(result)
      result.order(:date)
    end

    def filter_by_date
      return Rate.where('date >= ? AND date <= ?', start_date, end_date) if start_date && end_date

      Rate.where(date: date || Time.zone.today)
    end

    def filter_by_currency(scoped)
      currency ? scoped.where(code: currency) : scoped
    end
  end
end
