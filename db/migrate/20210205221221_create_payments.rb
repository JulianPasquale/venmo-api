# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.decimal :amount, precision: 10, scale: 2, default: 0, null: false
      t.string :description

      t.timestamps
    end
  end
end
