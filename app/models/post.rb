class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :unreads, dependent: :destroy, as: :resource

  validates :user_id, presence: true
  validates :body, presence: true

  after_create :create_unreads

  def title
    body.split("¥n").find{|str| str.present?}.gsub(/^#+ /,'')
  end

  def create_unreads

  end
end
