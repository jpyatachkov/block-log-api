if user.nil?
  json.user nil
else
  json.user user, :id, :username, :first_name, :last_name
end
