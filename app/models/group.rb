class Group < ApplicationRecord
  belongs_to :user
  validates :电影名称, presence: true
  has_many :group_relationships
  has_many :members, through: :group_relationships, source: :user
end
