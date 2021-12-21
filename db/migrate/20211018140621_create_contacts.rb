class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string     :name
      t.text       :message, null: false
      t.string     :to_email, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
