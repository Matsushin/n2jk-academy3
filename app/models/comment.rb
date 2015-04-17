class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_many :unreads, dependent: :destroy, as: :resource

  validates :body, presence: true
  validates :user_id, presence: true
  validates :post_id, presence: true

  after_create :create_unreads


  def create_unreads

  end
end
