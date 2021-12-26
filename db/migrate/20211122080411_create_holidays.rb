class CreateHolidays < ActiveRecord::Migration[6.1]
  def change
    create_table :holidays do |t|
      t.integer :day
      t.string :wday
      t.integer :month
      t.integer :year
      t.string :reason

      t.timestamps
    end
  end
end
