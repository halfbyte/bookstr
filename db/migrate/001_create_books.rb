class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.column :ean, :string
      t.column :title, :string
      t.column :description, :text
    end
  end

  def self.down
    drop_table :books
  end
end
