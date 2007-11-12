class CreateBookDatas < ActiveRecord::Migration
  def self.up
    create_table :book_datas do |t|
      t.column :pages, :integer
      t.column :published_at, :datetime
      t.column :binding, :string
    end
    
  end

  def self.down
    drop_table :book_datas
  end
end
