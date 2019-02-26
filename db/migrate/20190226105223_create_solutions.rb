class CreateSolutions < ActiveRecord::Migration[5.2]
  def change
    create_table :solutions do |t|
      t.text :content
      t.references :assignment, foreign_key: true

      t.timestamps
    end
  end
end
