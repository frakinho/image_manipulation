json.array!(@lendings) do |lending|
  json.extract! lending, :id, :user_id, :book_id, :size_widht, :size_height, :weight
  json.url lending_url(lending, format: :json)
end
