class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :nome

      t.timestamps
    end
  end
end
