class Post < ApplicationRecord
    belongs_to :user
    has_many :comments
    has_many :tags, dependent: :destroy
    validates :title, presence: true
    validates :text, presence: true
end
