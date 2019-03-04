class CreateAssignmentUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :assignment_users do |t|
      t.references :user, foreign_key: true
      t.references :assignment, foreign_key: true
      t.integer :assignment_mark, default: 0

      t.timestamps
    end
  end
end
