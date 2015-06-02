class AddTokenInformationToPassports < ActiveRecord::Migration
  def change
    change_table :sso_client_passports do |t|
      t.string  :uid,           null: false, index: true
      t.string  :token
      t.string  :refresh_token
      t.integer :token_expiry
    end
  end
end
