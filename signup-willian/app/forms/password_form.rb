class PasswordForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  validate :verify_original_password

  def persisted?
    false
  end

  delegate :changing_password, :original_password, :new_password, :new_password_confirmation, :to => :user

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def submit(params)
    user.attributes = params.slice(:original_password, :new_password, :new_password_confirmation)
    user.changing_password = true

    if valid? && user.valid?
      change_password

      true
    else
      false
    end
  end

  private

  def change_password
    user.password = user.new_password
    user.save!
  end

  def verify_original_password
    unless user.authenticate(user.original_password)
      errors.add :original_password, "is not correct"
    end
  end
end
