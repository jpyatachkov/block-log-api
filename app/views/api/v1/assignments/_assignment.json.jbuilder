json.id assignment.id
json.title assignment.text
json.inputs assignment.tests['inputs']
json.course do
  json.partial! '/api/v1/courses/course_min', course: assignment.course
end
