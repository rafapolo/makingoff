class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.string :url
      t.datetime :last_alive_at
      t.datetime :last_error_at
    end
  end
end
