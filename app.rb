require 'sinatra'
require 'json'
require_relative 'user'

enable :sessions

# GET on /users. This action will return all users (without their passwords).
get '/users' do
  users = User.all
  users.each { |user| user.delete("password") }
  users.to_json
end

# POST on /users. Receiving firstname, lastname, age, password and email. It will create a user and store in your database and returns the user created (without password).
post '/users' do
  user_info = {
    firstname: params[:firstname],
    lastname: params[:lastname],
    age: params[:age],
    password: params[:password],
    email: params[:email]
  }
  user = User.create(user_info)
  user.delete("password")
  user.to_json
end

# POST on /sign_in. Receiving email and password. It will add a session containing the user_id in order to be logged in and returns the user created (without password).
post '/sign_in' do
  user = User.find_by_email(params[:email])
  if user && user["password"] == params[:password]
    session[:user_id] = user["id"]
    user.delete("password")
    user.to_json
  else
    status 401
    "Unauthorized"
  end
end

# PUT on /users. This action require a user to be logged in. It will receive a new password and will update it. It returns the user created (without password).
put '/users' do
  user_id = session[:user_id]
  if user_id
    user = User.find(user_id)
    user["password"] = params[:password]
    User.update(user_id, "password", params[:password])
    user.delete("password")
    user.to_json
  else
    status 401
    "Unauthorized"
  end
end

# DELETE on /sign_out. This action require a user to be logged in. It will sign_out the current user. It returns nothing (code 204 in HTTP).
delete '/sign_out' do
  session[:user_id] = nil
  status 204
end

# DELETE on /users. This action require a user to be logged in. It will sign_out the current user and it will destroy the current user. It returns nothing (code 204 in HTTP).
delete '/users' do
  user_id = session[:user_id]
  if user_id
    User.destroy(user_id)
    session[:user_id] = nil
    status 204
  else
    status 401
    "Unauthorized"
  end
end

curl -X POST -i http://locasers -d firstname = "Nurislam" , -d lastname = "Shermatov" , -d age = 16 -d ,password = "palmangels", -d email= "nurislamshermatov280@gmail.com" , -c cookies.txt
curl -X GET -i http://localhostlhost:4567/u:4567/users -b cookies.txt
curl -X POST -i http://localhost:4567/sign_in -d "email=nurislamshermatov280@gmail.com" -d "password=palmangels" -c cookies.txt