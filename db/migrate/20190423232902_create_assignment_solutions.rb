class CreateAssignmentSolutions < ActiveRecord::Migration[5.2]
  def change
    create_table :assignment_solutions do |t|
      t.references :user, foreign_key: true
      t.references :assignment, foreign_key: true
      t.references :solution, default: 0

      t.integer :count_attempts, :integer, default: 0
      t.integer :course_id, :integer
      t.boolean :is_correct, :boolean, default: false
    end
  end
end
