require 'ECS'
class Product < ActiveRecord::Base
  belongs_to :data, :polymorphic => true, :dependent => :destroy
  validates_presence_of :title
  has_many :creatorships, :dependent => :destroy
  has_many :creators, :through => :creatorship

  def book_attributes=(attrs)
    self.data = BookData.create(attrs)
  end
  
  def creator_attributes=(attrs_array)
    attrs_array.each do |attrs|
      creator = Creator.find_or_create_by_role_and_name(attrs[:role], attrs[:name])
      self.creatorships.build(:creator => creator)
    end
  end

  
  def Product.find_or_create_from_amazon(code)
    product = Product.find_by_product_code(code)
    return product unless product.nil?
    product = Product.amazon_lookup(code)
    product.save
    return product
  end
  
  
  def Product.amazon_lookup(code)
    product = Product.new(:product_code => code)
    ECS.access_key_id = '0BCRK8ZF0WS5EXBV6182'
    ECS.cache_directory = RAILS_ROOT + '/tmp/ecs_cache'
    ECS::TimeManagement.time_file = RAILS_ROOT + '/tmp/ecs_time_file'
    code.upcase!
    code.gsub!(/[^0-9X]/, '')
    @product_attributes = {}
    # size 13 sugges
    if code.size == 13
      # try ASIN lookup if bookland code is 978
      if code[0..2] == '978'
        asin = self.isbn_to_asin(code) 
        item = ECS.item_lookup(:locale => :de, :IdType => 'ASIN', :ItemId => asin, :ResponseGroup => 'Large')
        begin
          product.title = item.ItemAttributes.Title.content
          product.amazon_asin = item.Item.ASIN.content
          product.amazon_detail_page_url = item.Item.DetailPageURL.content
          product.amazon_small_image_url = item.Item.SmallImage.URL.content
          product.amazon_medium_image_url = item.Item.MediumImage.URL.content
          product.amazon_large_image_url = item.Item.LargeImage.URL.content
          
          product.book_attributes = { :pages => item.NumberOfPages.content, :published_at => item.PublicationDate.content }
          product.creator_attributes = item.Creator.map {|c| {:role => c['Role'], :name => c.content}}
          
          
        rescue => exp
          logger.error("We has Error: #{exp}")
          product.errors.add(:product_code, 'konnte per Amazon nicht gefunden werden, bzw bei der Verarbeitung der Daten trat ein Fehler auf')
        end
        
      end
    end
    product
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
