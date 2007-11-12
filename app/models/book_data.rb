class BookData < ActiveRecord::Base
  has_one :book, :as => 'data'
end
