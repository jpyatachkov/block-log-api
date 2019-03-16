json.id solution.id
json.content solution.content

json.assignment do
  json.partial! '/api/v1/assignments/assignment_min', assignment: solution.assignment
end
