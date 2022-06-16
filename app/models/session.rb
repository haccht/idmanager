class Session < ApplicationRecord
  passwordless_with :account
  validates :account, presence: true, uniqueness: true, format: { with: /\A[a-z0-9+\._-]+\z/ }

  def user
    User.first(account)
  end

  def mail
    account + '@' + ENV['SESSION_DOMAIN_NAME']
  end

  def self.fetch_resource_for_passwordless(account)
    find_or_create_by(account: account)
  end
end
