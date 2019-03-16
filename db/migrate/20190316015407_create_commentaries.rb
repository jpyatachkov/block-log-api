class CreateCommentaries < ActiveRecord::Migration[5.2]
  def change
    create_table :commentaries do |t|
      t.text :comment
      t.boolean :is_active
      t.integer :user_id
      t.string :username
      t.references :profileable, polymorphic: true

      t.timestamps
    end
    add_index :commentaries, :username
  end
end
