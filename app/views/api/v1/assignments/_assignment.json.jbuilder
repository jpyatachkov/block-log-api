json.id assignment.id
json.text assignment.text
json.inputs assignment.tests['inputs'] unless assignment.tests.nil?
json.course do
  json.partial! '/api/v1/courses/course_min', course: assignment.course
end
