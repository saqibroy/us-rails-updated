class Post < ActiveRecord::Base
 
  belongs_to :user
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :comments

  translates :title, :body

    



end
