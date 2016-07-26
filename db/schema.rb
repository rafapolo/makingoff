# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140227120017) do

  create_table "countries", force: true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count"
  end

  create_table "countries_movies", id: false, force: true do |t|
    t.integer "movie_id"
    t.integer "country_id"
  end

  add_index "countries_movies", ["movie_id", "country_id"], name: "unique_index", unique: true, using: :btree

  create_table "directors", force: true do |t|
    t.string   "nome"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "directors_movies", id: false, force: true do |t|
    t.integer "movie_id"
    t.integer "director_id"
  end

  add_index "directors_movies", ["movie_id", "director_id"], name: "unique_index", unique: true, using: :btree

  create_table "genres", force: true do |t|
    t.string   "nome"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres_movies", id: false, force: true do |t|
    t.integer "movie_id"
    t.integer "genre_id"
  end

  add_index "genres_movies", ["movie_id", "genre_id"], name: "unique_index", unique: true, using: :btree

  create_table "movies", force: true do |t|
    t.string   "nome"
    t.string   "original"
    t.integer  "mko_id"
    t.integer  "ano"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count"
    t.string   "torrent_size", limit: 15
    t.string   "torrent_name"
    t.string   "torrent_hash", limit: 45
    t.datetime "last_show"
    t.string   "urlized"
    t.text     "magnet_link"
  end

  create_table "movies_trackers", id: false, force: true do |t|
    t.integer "tracker_id"
    t.integer "movie_id"
  end

  create_table "seeds", force: true do |t|
    t.integer  "movie_id"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trackers", force: true do |t|
    t.string   "url"
    t.datetime "last_alive_at"
    t.datetime "last_error_at"
  end

end
