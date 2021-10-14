class AddNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string, null: false, default: ""          
    add_column :users, :age, :integer  
    add_column :users, :area, :integer  
    add_column :users, :admin, :boolean, default: false
    add_column :users, :gender, :integer  
    add_column :users, :profile, :text   
    add_column :users, :theme, :integer, null: false, default: 0
  end
end
