json.total @total_pages
json.items @items.each do |item|
  json.partial! path, item: item
end
