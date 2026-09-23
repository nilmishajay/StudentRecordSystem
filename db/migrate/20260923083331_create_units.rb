class CreateUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :units do |t|
      t.string :code
      t.string :name
      t.integer :credit
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
