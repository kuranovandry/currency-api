# frozen_string_literal: true

class ScrapperJob
  include Sidekiq::Job
  sidekiq_options retry: 0

  NBP_TABLE_NAMES = %w[A B].freeze

  def perform(tables = NBP_TABLE_NAMES, date = DateTime.now)
    return if date.end_of_day < DateTime.now # checking date for custom retry if it's take more then one day

    tables.each do |table|
      result = Scrapper::Base.new(table).perform
      next unless result.nil?

      ScrapperJob.perform_at(1.hour.from_now, [table], date) # custom retry for a table that wasn't collected for today
    end
  end
end
