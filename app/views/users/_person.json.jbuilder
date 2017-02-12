json.extract! person, :id, :LName, :FName, :init, :email, :password, :is_admin, :is_user, :is_super, :created_at, :updated_at
json.url person_url(person, format: :json)