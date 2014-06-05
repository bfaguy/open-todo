class Api::ListsController < ApiController
  def create 
    @user = User.where(user_params).first
    if @user
      @list = @user.lists.build(list_params)
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

  def index
    lists = User.where(user_params).first.lists
    render json: lists, each_serializer: IndexListSerializer
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
  def list_params
    params.require(:list).permit(:name, :permissions)
  end
end
