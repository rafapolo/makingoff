class CreateSeeds < ActiveRecord::Migration
  def change
    create_table :seeds do |t|
      t.integer :movie_id
      t.integer :count

      t.timestamps
    end
  end
end
