class AddUniqueIndexToEnrolments < ActiveRecord::Migration[8.1]
  def change
    add_index :enrolments,
              %i[student_id unit_id semester academic_year],
              unique: true,
              name: "index_enrolments_on_student_unit_term_unique"
  end
end
