require 'ECS'
class Product < ActiveRecord::Base
  belongs_to :data, :polymorphic => true
  validates_presence_of :title
  has_many :creatorships
  has_many :creators, :through => :creatorship
  
  def Product.find_or_create_from_amazon(code)
    product = Product.find_by_product_code(code)
    return product unless product.nil?
    product = Product.amazon_lookup(code)
    if product.IsValid.content == "True"
      Product.new(:product_code => code)
    end
  end
  
  
  def Product.amazon_lookup(code)
    ECS.access_key_id = '0BCRK8ZF0WS5EXBV6182'
    ECS.cache_directory = RAILS_ROOT + '/tmp/ecs_cache'
    ECS::TimeManagement.time_file = RAILS_ROOT + '/tmp/ecs_time_file'

    code.gsub!(/[^0-9X]/, '')
    if code.size == 13
      # try ASIN lookup if bookland code is 978
      if code[0..2] == '978'
        asin = self.isbn_to_asin(code) 
        book = ECS.item_lookup(:locale => :de, :IdType => 'ASIN', :ItemId => asin, :ResponseGroup => 'Large')
        return book
      end
    end
      
  end
  
private
  def self.isbn_to_asin(code)
    return code if code.size != 13
    return code unless code.match(/^978/)
    code = code[3,9]
    code += isbn_checksum(code).to_s
  end
  
  def self.isbn_checksum(isbn)
    sum = 0 
    10.step( 2, -1 ) do |n|
   	  m = 10 - n 
   	  sum += n * isbn[m..m].to_i 
   	end 
   	checksum = ( 11 - (sum % 11 ) ) % 11 
   	checksum = 'X' if checksum == 10 
   	checksum.to_s 
  end  
end
