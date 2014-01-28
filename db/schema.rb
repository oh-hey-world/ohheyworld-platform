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

ActiveRecord::Schema.define(:version => 20130614194007) do

  create_table "beta_access_requests", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "beta_users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "state_id"
    t.integer  "country_id"
    t.string   "slug"
  end

  add_index "cities", ["slug"], :name => "index_cities_on_slug", :unique => true

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.string   "title",            :default => ""
    t.text     "body",             :default => ""
    t.string   "subject",          :default => ""
    t.integer  "user_id",          :default => 0,     :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "link_name"
    t.string   "link_value"
    t.boolean  "private",          :default => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "communities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.text     "question"
    t.string   "brand_file_name"
    t.string   "brand_content_type"
    t.integer  "brand_file_size"
    t.datetime "brand_updated_at"
    t.string   "community_slug"
    t.string   "tagline"
    t.string   "custom_field_label"
  end

  create_table "community_profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "community_id"
    t.text     "tagline"
    t.text     "answer"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "admin",        :default => false
    t.string   "custom_field"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "link"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "flag_file_name"
    t.string   "flag_content_type"
    t.integer  "flag_file_size"
    t.datetime "flag_updated_at"
    t.string   "code"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "phone_code"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "local_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "locations", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "city_name"
    t.string   "state_name"
    t.string   "state_code"
    t.string   "postal_code"
    t.string   "country_name"
    t.string   "country_code"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "user_input"
    t.boolean  "residence"
    t.integer  "state_id"
    t.integer  "country_id"
    t.integer  "city_id"
  end

  create_table "notification_contact_details", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.string   "type"
    t.integer  "user_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.boolean  "enabled_to_send_notification", :default => true
  end

  create_table "preferences", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type_name"
  end

  create_table "provider_friends", :force => true do |t|
    t.string   "provider_name"
    t.string   "user_name"
    t.string   "uid"
    t.string   "picture_url"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "link"
    t.integer  "location_id"
    t.integer  "user_id"
    t.string   "username"
    t.string   "email"
    t.string   "phone"
  end

  create_table "registration_codes", :force => true do |t|
    t.string   "code"
    t.integer  "uses"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "original_amount"
    t.text     "description"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "link"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "country_id"
    t.string   "code"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "user_assets", :force => true do |t|
    t.integer  "user_id"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.string   "type"
    t.boolean  "default"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "user_cities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "city_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "user_city_tips_count"
    t.text     "summary"
  end

  create_table "user_city_tips", :force => true do |t|
    t.string   "tip"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "user_city_id"
    t.string   "travel_profile"
    t.string   "link_name"
    t.string   "link_value"
  end

  create_table "user_contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.string   "subject"
    t.text     "message"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_countries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_friends", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "send_sms",   :default => false
    t.boolean  "send_email", :default => false
    t.string   "phone"
  end

  create_table "user_languages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "language_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "user_location_assets", :force => true do |t|
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.string   "type"
    t.boolean  "default"
    t.integer  "user_location_id"
  end

  create_table "user_location_notes", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "note",                           :default => ""
    t.integer  "user_id"
    t.integer  "user_location_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "user_location_notes", ["user_id"], :name => "index_user_location_notes_on_user_id"
  add_index "user_location_notes", ["user_location_id"], :name => "index_user_location_notes_on_user_location_id"

  create_table "user_location_tagged_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "provider_friend_id"
    t.integer  "user_location_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "user_locations", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "location_id"
    t.boolean  "current",        :default => false
    t.datetime "ended_at"
    t.boolean  "residence"
    t.string   "slug"
    t.string   "name"
    t.text     "sent_snapshot"
    t.text     "custom_message"
    t.string   "source"
    t.boolean  "private",        :default => false
  end

  add_index "user_locations", ["user_id", "slug"], :name => "index_user_locations_on_user_id_and_slug", :unique => true

  create_table "user_provider_friends", :force => true do |t|
    t.integer  "user_id"
    t.integer  "provider_friend_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.boolean  "following"
    t.string   "email"
    t.string   "phone"
  end

  create_table "user_providers", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.integer  "timezone"
    t.string   "locale"
    t.string   "link"
    t.string   "hometown"
    t.string   "picture_url"
    t.string   "provider_token"
    t.integer  "provider_token_timeout"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "secret"
    t.string   "full_name"
    t.string   "nickname"
    t.text     "description"
    t.string   "website"
    t.boolean  "geo_enabled"
    t.boolean  "failed_post_deauthorized"
    t.boolean  "failed_token"
    t.boolean  "failed_app_deauthorized"
  end

  create_table "user_searches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "user_input"
    t.integer  "tag_id"
  end

  create_table "user_tag_notifications", :force => true do |t|
    t.integer  "user_id"
    t.string   "tag"
    t.boolean  "sms"
    t.boolean  "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                   :default => "", :null => false
    t.string   "encrypted_password",      :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.integer  "timezone"
    t.string   "locale"
    t.string   "picture_url"
    t.string   "link"
    t.text     "blurb"
    t.datetime "birthday"
    t.integer  "roles_mask"
    t.string   "blog_url"
    t.integer  "home_town_location_id"
    t.string   "nickname",                                :null => false
    t.string   "slug",                                    :null => false
    t.boolean  "agrees_to_terms"
    t.boolean  "completed_first_checkin"
    t.integer  "import_job_id"
    t.datetime "import_job_finished_at"
    t.text     "send_overrides"
    t.string   "authentication_token"
    t.string   "phone"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "phone_country_code_id"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["phone"], :name => "index_users_on_phone", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], :name => "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["votable_id", "votable_type"], :name => "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], :name => "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
