class CreateResults < ActiveRecord::Migration[8.1]
  def change
    create_table :results do |t|
      t.references :enrolment, null: false, foreign_key: true
      t.decimal :mark
      t.string :grade

      t.timestamps
    end
  end
end
