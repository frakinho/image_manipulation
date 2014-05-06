json.array!(@settings) do |setting|
  json.extract! setting, :id, :debug, :security_level, :size_height, :size_width, :weight
  json.url setting_url(setting, format: :json)
end
