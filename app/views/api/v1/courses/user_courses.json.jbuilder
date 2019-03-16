json.total @total_pages
json.items @items.each do |item|
  json.partial! '/api/v1/courses/course', course: item
end
