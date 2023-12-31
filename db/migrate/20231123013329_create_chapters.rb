class CreateChapters < ActiveRecord::Migration[6.1]
  def change
    create_table :chapters do |t|
      t.string :name
      t.references :course, null: false, foreign_key: true
      t.integer :seq

      t.timestamps
    end
  end
end
