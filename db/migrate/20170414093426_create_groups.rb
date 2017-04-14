class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.text :电影名称
      t.text :电影类型
      t.integer :上映年份

      t.timestamps
    end
  end
end
