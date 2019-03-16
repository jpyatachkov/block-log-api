class AddCourseToSolution < ActiveRecord::Migration[5.2]
  def change
    add_reference :solutions, :course, foreign_key: true
  end
end
