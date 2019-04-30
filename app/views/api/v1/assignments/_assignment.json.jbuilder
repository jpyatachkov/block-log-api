json.id assignment.id
json.title assignment.title
json.description assignment.description
json.program assignment.program
json.tests assignment.tests || []
if @assignment_additional_info.nil?
  json.count_attempts assignment.count_attempts
  json.passed assignment.is_correct
else
  json.count_attempts @assignment_additional_info.count_attempts
  json.passed @assignment_additional_info.is_correct
end 
json.course do
  json.partial! '/api/v1/courses/course_min', course: assignment.course
end
