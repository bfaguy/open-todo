class Api::UsersController < ApiController

  def create
    new_user = User.new(user_params)

    if new_user.save
      render json: UserSerializer.new(new_user).to_json
    else
      message = "User was not created"
      error(500, message)
    end
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
