class CreateDoorkeeperSsoClientPassports < ActiveRecord::Migration
  def change
    create_table :sso_client_passports do |t|
      t.references :identity, polymorphic: true, index: true
      t.string :secret
      t.string :state
      t.string :chip
      t.string :user
      t.boolean :verified, default: false
      t.boolean :modified, default: false
      t.timestamps null: false
    end
  end
end
