# frozen_string_literal: true

class CreateRates < ActiveRecord::Migration[7.0]
  def change
    create_table :rates do |t|
      t.date    :date, index: true, null: false
      t.string  :code, null: false
      t.string  :currency_name, null: false
      t.decimal :average, precision: 8, scale: 2

      t.index %i[date code], unique: true

      t.timestamps
    end
  end
end
