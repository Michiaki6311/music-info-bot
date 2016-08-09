class CreateMusic < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :artist
      t.string :genre
      t.text   :url
    end
  end
end
