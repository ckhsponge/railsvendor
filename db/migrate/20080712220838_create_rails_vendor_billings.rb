class CreateRailsVendorBillings < ActiveRecord::Migration
  def self.up
      create_table "billings", :force => true do |t|
        t.column "external_id",         :string
        t.column "tail_digits",         :string,                :default => "",    :null => false
        t.column "created_at",          :datetime,                                 :null => false
        t.column "active",              :boolean,               :default => false, :null => false
        t.column "updated_at",          :datetime,                                 :null => false
        t.column "recurring",           :boolean,               :default => false, :null => false
        t.column "phone_number",        :string,                :default => "",    :null => false
        t.column "email_address",       :string,                :default => "",    :null => false
        t.column "expiration_date",     :date,                                     :null => false
        t.column "credit_type",         :string,                :default => "",    :null => false
        t.column "first_name",          :string,                :default => "",    :null => false
        t.column "last_name",           :string,                :default => "",    :null => false
        t.column "street",  :string,  :default => "",    :null => false
        t.column "city",    :string,  :default => "",    :null => false
        t.column "state",   :string,  :default => "",    :null => false
        t.column "zip",     :string,  :default => "",    :null => false
        t.column "country", :string,  :default => "",    :null => false
      end

  end

  def self.down
    drop_table "billings"
  end
end
