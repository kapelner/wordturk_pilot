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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111111023308) do

  create_table "big_brother_params", :force => true do |t|
    t.string  "param"
    t.text    "value"
    t.integer "big_brother_track_id"
  end

  add_index "big_brother_params", ["big_brother_track_id"], :name => "index_big_brother_params_on_big_brother_track_id"

  create_table "big_brother_tracks", :force => true do |t|
    t.string   "mturk_worker_id"
    t.string   "ip"
    t.string   "controller"
    t.string   "action"
    t.string   "method"
    t.boolean  "ajax"
    t.datetime "created_at"
  end

  add_index "big_brother_tracks", ["ip"], :name => "index_big_brother_tracks_on_ip"
  add_index "big_brother_tracks", ["mturk_worker_id"], :name => "index_big_brother_tracks_on_mturk_worker_id"

  create_table "browser_statuses", :force => true do |t|
    t.integer  "disambiguation_id"
    t.string   "status"
    t.datetime "created_at"
  end

  add_index "browser_statuses", ["disambiguation_id"], :name => "index_browser_statuses_on_disambiguation_id"

  create_table "disambiguations", :force => true do |t|
    t.integer  "snippet_id"
    t.string   "mturk_hit_id"
    t.string   "mturk_group_id"
    t.integer  "version",                :limit => 3
    t.float    "wage"
    t.string   "country",                :limit => 2
    t.datetime "to_be_expired_at"
    t.integer  "treatment",              :limit => 3
    t.string   "mturk_assignment_id"
    t.string   "mturk_worker_id"
    t.string   "ip_address"
    t.datetime "started_at"
    t.datetime "read_consent_at"
    t.integer  "age",                    :limit => 3
    t.string   "gender",                 :limit => 1
    t.datetime "read_directions_at"
    t.datetime "finished_at"
    t.text     "browser_info"
    t.text     "comments"
    t.text     "notes"
    t.datetime "rejected_at"
    t.datetime "paid_at"
    t.float    "bonus"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "senseeval_inventory_id"
  end

  add_index "disambiguations", ["mturk_hit_id"], :name => "index_disambiguations_on_mturk_hit_id"
  add_index "disambiguations", ["mturk_worker_id"], :name => "index_disambiguations_on_mturk_worker_id"
  add_index "disambiguations", ["snippet_id"], :name => "index_disambiguations_on_snippet_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "rounded_corners", :force => true do |t|
    t.integer  "radius"
    t.string   "border"
    t.string   "interior"
    t.datetime "created_at"
  end

  add_index "rounded_corners", ["radius"], :name => "index_rounded_corners_on_radius"

  create_table "senseeval_inventories", :force => true do |t|
    t.integer  "word_id"
    t.string   "basic_definition"
    t.text     "commentary"
    t.text     "examples"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "n",                :limit => 3
  end

  create_table "snippets", :force => true do |t|
    t.integer "word_id"
    t.integer "senseeval_inventory_id"
    t.text    "context"
    t.boolean "experimental"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "version_infos", :force => true do |t|
    t.integer  "version"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "version_infos", ["version"], :name => "index_version_infos_on_version"

  create_table "wordnet_definitions", :force => true do |t|
    t.integer  "word_id"
    t.text     "definition_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wordnet_definitions", ["word_id"], :name => "index_wordnet_definitions_on_word_id"

  create_table "words", :force => true do |t|
    t.string   "entry"
    t.string   "url",                      :limit => 500
    t.integer  "version",                  :limit => 3,   :default => 1, :null => false
    t.datetime "created_at"
    t.string   "sense_inventory_filename"
    t.string   "part_of_speech"
  end

  add_index "words", ["entry"], :name => "index_words_on_entry"
  add_index "words", ["part_of_speech"], :name => "index_words_on_part_of_speech"

end
