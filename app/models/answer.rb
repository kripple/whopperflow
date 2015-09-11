class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: "id"
  has_many :comments, as: :commentable
  has_many :votes, as: :votable
end