class AddUniqueIndexToResults < ActiveRecord::Migration[8.1]
  def change
    add_index :results, :enrolment_id, unique: true, name: "index_results_on_enrolment_id_unique"
  end
end
