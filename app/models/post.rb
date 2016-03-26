class Post < ActiveRecord::Base
 
  belongs_to :user
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :comments

  translates :title, :body
  has_attached_file :image,
                    styles: { thumb: ["100x100#", :jpg],
                              original: ['1130x350>', :jpg] },
                    convert_options: { thumb: "-quality 75 -strip",
                                       original: "-quality 100 -strip" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

    



end
