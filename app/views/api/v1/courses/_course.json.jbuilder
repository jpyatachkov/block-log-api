json.id course.id
json.title course.title
json.short_description course.short_description
json.description course.description
roles = @_current_user.roles.select(:name).where(resource_type: :Course, resource_id: course.id).map(&:name)
roles = nil if roles.empty?
json.user_rights roles
