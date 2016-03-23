class Image < ActiveRecord::Base
  has_attached_file :image,
                    styles: { thumb: ["64x64#", :jpg],
                              original: ['1130x350>', :jpg] },
                    convert_options: { thumb: "-quality 75 -strip",
                                       original: "-quality 100 -strip" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
