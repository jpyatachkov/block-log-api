class AddCourseToCommentary < ActiveRecord::Migration[5.2]
  def change
    add_reference :commentaries, :course, foreign_key: true
  end
end
