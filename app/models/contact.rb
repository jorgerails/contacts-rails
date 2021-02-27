class Contact < ApplicationRecord
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :phone_number,
            presence: true,
            length: { minimum: 9, maximum: 255 }

  def email
    self[:email].downcase
  end
end
