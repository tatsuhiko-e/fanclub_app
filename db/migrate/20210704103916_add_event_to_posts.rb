class AddEventToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :event, :boolean, default: false, null: false
  end
end
