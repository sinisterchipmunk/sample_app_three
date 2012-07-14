# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  valid_email_regex = /\A[\w+\-.]+@[\w\-.]+\.[a-z]+\z/i
  # \A    Start of string 
  # \w    Any word character (letter, number, underscore)
  # [a-z] Any single character in the range a-z
  # \z    End of string
  # i     Case insensitive
  # Note: Everything before the +@ and before the +\. will verify that the first portion of the email address  
  #       will only contain letters, numbers, underscores, hyphens and periods.  Everything after the +\. will 
  #       only contain letters.
  validates :email, presence:   true,
                    format:     { with: valid_email_regex },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
  
end