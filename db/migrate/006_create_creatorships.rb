class CreateCreatorships < ActiveRecord::Migration
  def self.up
    create_table :creatorships do |t|
      t.column :creator_id, :integer
      t.column :product_id, :integer
    end
  end

  def self.down
    drop_table :creatorships
  end
end
