class Auth < ApplicationRecord
  passwordless_with :mail
  validates :mail, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.fetch_resource_for_passwordless(name)
    mail = [name.strip, ENV.fetch('AUTH_DOMAIN', 'localhost')].join('@')
    find_or_create_by(mail: mail)
  end

  def name
    name, _ = self.mail.split('@', 2)
    name
  end
end
