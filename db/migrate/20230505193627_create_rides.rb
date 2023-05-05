class CreateRides < ActiveRecord::Migration[7.0]
  def change
    create_table :rides do |t|
      t.string :start_address, null: false
      t.string :destination_address, null: false
      t.bigint :driver_id

      t.timestamps
    end
  end
end
