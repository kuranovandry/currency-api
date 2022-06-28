# frozen_string_literal: true

class Rate < ApplicationRecord
  validates :code, :date, :average, :currency_name, presence: true
  validates :date, uniqueness: { scope: :code }
end
