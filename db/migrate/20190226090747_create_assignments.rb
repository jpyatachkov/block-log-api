class CreateAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :assignments do |t|
      t.text :text
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
