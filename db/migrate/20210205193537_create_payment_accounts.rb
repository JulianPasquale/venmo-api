# frozen_string_literal: true

class CreatePaymentAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :balance, precision: 10, scale: 2, default: 0

      t.timestamps
    end
  end
end
