# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080712220838) do

  create_table "billings", :force => true do |t|
    t.string   "external_id"
    t.string   "tail_digits",     :default => "",    :null => false
    t.datetime "created_at",                         :null => false
    t.boolean  "active",          :default => false, :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "recurring",       :default => false, :null => false
    t.string   "phone_number",    :default => "",    :null => false
    t.string   "email_address",   :default => "",    :null => false
    t.date     "expiration_date",                    :null => false
    t.string   "credit_type",     :default => "",    :null => false
    t.string   "first_name",      :default => "",    :null => false
    t.string   "last_name",       :default => "",    :null => false
    t.string   "street",          :default => "",    :null => false
    t.string   "city",            :default => "",    :null => false
    t.string   "state",           :default => "",    :null => false
    t.string   "zip",             :default => "",    :null => false
    t.string   "country",         :default => "",    :null => false
  end

end
