json.extract! account_request, :id, :userid, :created, :created_at, :updated_at
json.url account_request_url(account_request, format: :json)