class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  validates :user_id, presence: true
  validates :content, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 150}
end