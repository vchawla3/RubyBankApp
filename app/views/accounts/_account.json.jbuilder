json.extract! account, :id, :acc_number, :is_closed, :balance, :created_at, :updated_at
json.url account_url(account, format: :json)