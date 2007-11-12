class Creatorship < ActiveRecord::Base
  belongs_to :product
  belongs_to :creator
end
