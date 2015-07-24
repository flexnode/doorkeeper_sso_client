module DoorkeeperSsoClient
  class Passport < ActiveRecord::Base
    include DoorkeeperSsoClient::Mixins::PassportBase
  end
end

# == Schema Information
# Schema version: 20150603155315
#
# Table name: sso_client_passports
#
#   t.integer  "identity_id"
#   t.string   "identity_type"
#   t.string   "secret"
#   t.string   "state"
#   t.string   "chip"
#   t.string   "user"
#   t.boolean  "verified",      default: false
#   t.boolean  "modified",      default: false
#   t.datetime "created_at",                    null: false
#   t.datetime "updated_at",                    null: false
#   t.integer  "expiry"
#   t.string   "uid",                           null: false
#   t.string   "token"
#   t.string   "refresh_token"
#   t.integer  "token_expiry"
#   t.datetime "revoked_at"
#   t.string   "revoke_reason"
#   t.datetime "last_login_at"
