json.extract! transaction, :id, :transtype, :account_id, :receiver, :status, :amount, :start_date, :effective_date, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)