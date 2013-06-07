class SignupForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  def persisted?
    false
  end

  delegate :username, :email, :password, :password_confirmation, :to => :user
  delegate :twitter_name, :github_name, :bio, :to => :profile

  def user
    @user ||= User.new
  end

  def profile
    @profile ||= user.build_profile
  end

  def submit(params)
    user.attributes = params.slice(:username, :email, :password, :password_confirmation)
    profile.attributes = params.slice(:twitter_name, :github_name, :bio)

    self.subscribed = params[:subscribed]

    if user.valid? and profile.valid?
      generate_token

      user.save!
      profile.save!

      true
    else
      false
    end
  end

  def subscribed
    user.subscribed_at
  end

  def subscribed=(checkbox)
    user.subscribed_at = Time.zone.now if checkbox == "1"
  end

  def generate_token
    begin
      user.token = SecureRandom.hex
    end while User.exists?(token: user.token)
  end
end
