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
    @user = User.where(user_params).first
    if @user
      lists = @user.lists
      render json: lists, each_serializer: IndexListSerializer
    else
      error(422, "User credentials are not correct") # unprocessable_entity
    end
  end

  def show
    @user = User.where(user_params).first
    @list = @user.lists.find(params[:id])
    if @user
      # items = @user.lists.find(params[:id]).items.all
      render json: @list
    else
      error(422, "User credentials are not correct") # unprocessable_entity
    end
  end

  def destroy
    @user = User.where(user_params).first
    @list = @user.lists.find(params[:id])
    if @user
      if @list.destroy
        render json: @list, serializer: BasicListSerializer
      else
        error(422, "List could not be deleted")
      end
    else
      error(422, "User credentials are not correct") 
    end
  end

  private


  def user_params
    params.require(:user).permit(:username, :password)
  end
  def list_params
    params.require(:list).permit(:name, :permissions)
  end
end
