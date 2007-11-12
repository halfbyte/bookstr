class CreateCreators < ActiveRecord::Migration
  def self.up
    create_table :creators do |t|
      t.column :name, :string
      t.column :role, :string
    end
  end

  def self.down
    drop_table :creators
  end
end
