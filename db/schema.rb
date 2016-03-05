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

ActiveRecord::Schema.define(version: 20160303144558) do

  create_table "yahoo_news", force: :cascade do |t|
    t.string   "topic_id",                limit: 255
    t.string   "category",                limit: 255
    t.boolean  "is_top",                  limit: 1,     default: false
    t.string   "title",                   limit: 255
    t.text     "text",                    limit: 65535
    t.string   "topic_link",              limit: 255
    t.string   "detail_link",             limit: 255
    t.datetime "posted_at"
    t.datetime "last_posted_at"
    t.integer  "posted_duration_minutes", limit: 4
  end

  add_index "yahoo_news", ["posted_at"], name: "index_yahoo_news_on_posted_at", using: :btree
  add_index "yahoo_news", ["topic_id"], name: "index_yahoo_news_on_topic_id", using: :btree

  create_table "yahoo_news_keywords", force: :cascade do |t|
    t.date     "week_start_date"
    t.string   "word",            limit: 255
    t.integer  "count",           limit: 4
    t.datetime "updated_at"
  end

  add_index "yahoo_news_keywords", ["week_start_date", "word"], name: "index_yahoo_news_keywords_on_week_start_date_and_word", using: :btree
  add_index "yahoo_news_keywords", ["week_start_date"], name: "index_yahoo_news_keywords_on_week_start_date", using: :btree

end