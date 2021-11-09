class CreateAdminrequests < ActiveRecord::Migration[5.2]
  def change
    create_table :adminrequests do |t|
      t.string :teamname
      t.string :twitter_url
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
