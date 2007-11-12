class Creator < ActiveRecord::Base
  has_many :creatorships
  has_many :products, :through => :creatorship
end
