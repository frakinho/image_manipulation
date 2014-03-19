json.array!(@books) do |book|
  json.extract! book, :id, :barcode, :double, :title
  json.url book_url(book, format: :json)
end
