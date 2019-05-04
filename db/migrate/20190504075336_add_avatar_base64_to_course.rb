class AddAvatarBase64ToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :avatar_base64, :text
  end
end
