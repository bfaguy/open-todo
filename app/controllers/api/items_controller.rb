class Api::ItemsController < ApiController

  def create
    @user = User.where(user_params).first
    if @user
      @list = @user.lists.find(params[:list_id])
      if @list.add(item_params[:description])
        render json: @list.items.last
      else
        error(422, "Item was not created")
      end
    else
      error(422, "User credentials are not correct")
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
  def item_params
    params.require(:item).permit(:description)
  end
end
