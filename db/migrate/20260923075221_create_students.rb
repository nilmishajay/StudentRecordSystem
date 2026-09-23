class CreateStudents < ActiveRecord::Migration[8.1]
  def change
    create_table :students do |t|
      t.string :student_number
      t.string :first_name
      t.string :last_name
      t.string :email
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
