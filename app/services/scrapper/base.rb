# frozen_string_literal: true

module Scrapper
  class Base
    NBP_BASE_URL = 'http://api.nbp.pl/api/exchangerates/tables/'

    attr_reader :url

    def initialize(table_name)
      @url = "#{NBP_BASE_URL}#{table_name}"
    end

    def perform
      logger.info I18n.t('info.beginning', date: DateTime.now)
      date, rates = receive_request_results
      return if rates.nil?

      rate_instances = prepare_rate_instances(rates, date)
      result = Rate.import rate_instances, on_duplicate_key_update: [:average]
      logger.info I18n.t('info.ending', count: result.count)
    end

    private

    def receive_request_results
      result = bank_request
      return if result.nil?

      check_status(result.status)
      return if result.status != Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok]

      table_a_json = parse_result(result)
      return if table_a_json.nil?

      rates = table_a_json.dig(0, 'rates')
      date = table_a_json.dig(0, 'effectiveDate').to_datetime
      [date, rates]
    end

    def parse_result(result)
      JSON.parse(result.body)
    rescue JSON::ParserError => e
      logger.error I18n.t('errors.json_parse', message: e.message, url: url)
      nil
    end

    def check_status(code)
      case code
      when Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request]
        logger.error I18n.t('errors.bad_request', url: url)
      when Rack::Utils::SYMBOL_TO_STATUS_CODE[:not_found]
        logger.error I18n.t('errors.not_found', url: url)
      end
    end

    def bank_request
      Faraday.new(url: url, headers: { Accept: 'application/json' }).get
    rescue StandardError => e
      logger.error I18n.t('errors.request_exception', message: e.message, url: url)
      nil
    end

    def prepare_rate_instances(rates, date)
      rates.map do |currency|
        Rate.new(
          currency_name: currency['currency'],
          average:       currency['mid'],
          date:          date,
          code:          currency['code']
        )
      end
    end

    def logger
      @logger ||= Logger.new(Rails.root.join('log/scrapper.log'))
    end
  end
end
