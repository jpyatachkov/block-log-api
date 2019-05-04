json.id course.id
json.title course.title
json.short_description course.short_description
json.description course.description
json.avatar_base64 course.avatar_base64
json.is_visible course.is_visible
json.user_rights @user_roles
json.complexity course.complexity
json.requirements course.requirements
json.count_assignments course.count_assignments
# maybe need to improve
if @course_additional_info.nil?
  json.count_passed course.count_passed
  json.passed course.passed
else
  json.count_passed @course_additional_info.count_passed
  json.passed @course_additional_info.passed
end
json.partial! '/api/v1/users/user', user: course.author
