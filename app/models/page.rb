class Page < ActiveRecord::Base
  translates :name, :content
end
