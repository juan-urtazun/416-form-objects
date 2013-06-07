class User < ActiveRecord::Base
  has_secure_password

  attr_accessor :changing_password, :original_password, :new_password

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
  validates_length_of :password, minimum: 6, on: :create

  validates_presence_of :original_password, :new_password, if: :changing_password
  validates_confirmation_of :new_password, if: :changing_password
  validates_length_of :new_password, minimum: 6, if: :changing_password

  has_one :profile
end
