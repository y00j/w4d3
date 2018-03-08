class User < ApplicationRecord
  validates :username, uniqueness: true, presence: true
  validates :password_digest, presence: { message: 'Password cant be blank' }
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :session_token, presence: true
  after_initialize :ensure_session_token

  attr_reader :password


  def reset_session_token!
    self.update(session_token: User.generate_session_token)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by_username(user_name)
    return nil if user.nil?
    return user if user.is_password?(password)
    nil
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

end
