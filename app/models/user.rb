class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :unreads, dependent: :destroy

  validates :github_id, presence: true
  validates :name, presence: true
  validates :email, presence: true
  validates :icon, presence: true

  def self.create_by_github(auth)
    User.create!(github_id: auth[:uid],
      github_token: auth[:credentials][:token],
      name: auth[:info][:name] || auth[:info][:nickname],
      email: auth[:info][:email],
      icon: auth[:extra][:raw_info][:avatar_url])
  end
end
