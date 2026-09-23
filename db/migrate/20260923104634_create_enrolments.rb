class CreateEnrolments < ActiveRecord::Migration[8.1]
  def change
    create_table :enrolments do |t|
      t.references :student, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.string :semester
      t.integer :academic_year

      t.timestamps
    end
  end
end
