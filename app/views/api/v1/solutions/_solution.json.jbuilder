json.id solution.id
json.program solution.program
json.is_correct solution.is_correct

json.assignment do
  json.partial! '/api/v1/assignments/assignment_min', assignment: solution.assignment
end
