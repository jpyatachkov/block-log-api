json.id assignment.id
json.title assignment.title
json.description assignment.description
json.program assignment.program
json.tests assignment.tests
json.course do
  json.partial! '/api/v1/courses/course_min', course: assignment.course
end
