class MembersToTitles < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :twitter, :string
    add_column :members, :instagram, :string
    add_column :members, :email, :string
    add_column :members, :birthday, :date
  end
end
