class AddTokenToPassport < ActiveRecord::Migration
  def change
    change_table :sso_client_passports do |t|
      t.string  :mobile_token
      t.string  :client_uid, index: true
    end

    DoorkeeperSsoClient::Passport.find_each do |p|
      p.save
    end

    change_column_null :sso_client_passports, :mobile_token, :string, false
  end
end
