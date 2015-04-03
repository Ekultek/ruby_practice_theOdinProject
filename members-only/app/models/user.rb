class User < ActiveRecord::Base
  has_secure_password
  has_many :posts
  before_create :create_remember_token
  
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end

