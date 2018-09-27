json.extract! user, :id, :name, :email, :password, :age, :caste, :gender, :address, :religion, :phone, :qualification, :current_job, :status, :adminid, :created_at, :updated_at
json.url user_url(user, format: :json)
