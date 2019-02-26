class AddTestsToAssignment < ActiveRecord::Migration[5.2]
  def change
    add_column :assignments, :tests, :jsonb
  end
end
