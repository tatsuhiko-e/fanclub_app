class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :name
      t.text :profile
      t.integer :age
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
