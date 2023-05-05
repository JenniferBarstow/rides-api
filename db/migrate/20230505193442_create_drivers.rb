class CreateDrivers < ActiveRecord::Migration[7.0]
  def change
    create_table :drivers do |t|
      t.string :home_address, null: false

      t.timestamps
    end
  end
end
