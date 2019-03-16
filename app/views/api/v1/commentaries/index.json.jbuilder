json.total @total_pages
json.items @items.each do |item|
  json.partial! '/api/v1/commentaries/commentary', commentary: item
end
