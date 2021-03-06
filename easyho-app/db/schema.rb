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

ActiveRecord::Schema.define(:version => 20130331084141) do

  create_table "main_users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "mobile"
    t.string   "status"
    t.boolean  "isadmin"
    t.date     "dob"
    t.datetime "lastlogin"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "main_users", ["email"], :name => "index_main_users_on_email", :unique => true
  add_index "main_users", ["remember_token"], :name => "index_main_users_on_remember_token"

  create_table "patient_followups", :force => true do |t|
    t.integer  "patient_id"
    t.text     "observations"
    t.text     "medicines"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "patients", :force => true do |t|
    t.string   "firstname"
    t.string   "middlename"
    t.string   "lastname"
    t.string   "email"
    t.string   "mobile"
    t.string   "homeaddress"
    t.string   "homephone"
    t.date     "dob"
    t.string   "jobdescription"
    t.string   "jobaddress"
    t.string   "jobphone"
    t.string   "jobemail"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "doctor_id"
    t.string   "opd_number"
  end

  add_index "patients", ["opd_number"], :name => "index_patients_on_opd_number"

  create_table "pch_records", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "pch_sec_id"
    t.text     "htmltext"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pch_sections", :force => true do |t|
    t.string   "displayname"
    t.integer  "displayorder"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
