class Api::ListsController < ApiController
  def create 
    @list = List.new(name: params[:list][:name], user_id: params[:list][:user_id], permissions: params[:list][:permissions])
    if User.where(username: params[:user][:username], password: params[:user][:password]).exists?
      if @list.save
        render json: @list
      else
        message = "List was not created"
        error(422, message) # unprocessable_entity
      end
    else
        message = "User credentials are not correct"
        error(422, message) # unprocessable_entity
    end
  end

end
