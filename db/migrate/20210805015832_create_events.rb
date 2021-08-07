class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title
      t.text :body
      t.string :place
      t.datetime :start_time, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
