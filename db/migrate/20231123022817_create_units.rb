class CreateUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :units do |t|
      t.string :name
      t.text :desc
      t.text :content
      t.references :chapter, null: false, foreign_key: true
      t.integer :seq

      t.timestamps
    end
  end
end
