json.extract! user, :id, :name, :email, :password, :password_confirmation, :is_admin, :is_user, :is_super
json.url user_url(user, format: :json)