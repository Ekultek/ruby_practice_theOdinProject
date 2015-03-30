class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true, length: { maximum: 15}
  has_many :posts
  has_many :comments
end
