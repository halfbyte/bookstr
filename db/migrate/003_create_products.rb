class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.column :title, :string
      t.column :product_code, :string
      t.column :data_type, :string
      t.column :data_id, :integer
      t.column :amazon_asin, :string
      t.column :amazon_detail_page_url, :string
      t.column :amazon_small_image_url, :string
      t.column :amazon_medium_image_url, :string
      t.column :amazon_large_image_url, :string
      
    end
  end

  def self.down
    drop_table :products
  end
end
