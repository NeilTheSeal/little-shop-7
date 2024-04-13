class AddColumnToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :status, :integer
  end
end
