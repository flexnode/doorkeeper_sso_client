class AddRevokeInformationToPassports < ActiveRecord::Migration
  def change
    change_table :sso_client_passports do |t|
      t.datetime "revoked_at"
      t.string   "revoke_reason"
      t.datetime "last_login_at"
    end
  end
end
