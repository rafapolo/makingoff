class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :nome
      t.string :original
      t.integer :mko_id
      t.integer :ano

      t.timestamps
    end
  end
end
