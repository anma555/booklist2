class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :isbn
      t.string :title
      t.string :author
      t.integer :status
      t.text :memo
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
