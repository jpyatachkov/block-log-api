json.id solution.id
json.program solution.program
json.is_correct solution.is_correct
json.created_at solution.created_at

json.assignment do
  json.partial! '/api/v1/assignments/assignment_min', assignment: solution.assignment
end
