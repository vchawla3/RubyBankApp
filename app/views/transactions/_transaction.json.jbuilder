json.extract! transaction, :id, :type, :sender, :receiver, :status, :amount, :start_date, :effective_date, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)