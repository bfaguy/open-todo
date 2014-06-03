class Api::UsersController < ApiController

  def create
    @user = User.new(user_params)

    if @user.save
      #render json: UserSerializer.new(@user).to_json
      render json: @user
    else
      message = "User was not created"
      
      render :json => { :errors => @user.errors.as_json }, :status => 420
      # render :json => { :errors => message }, :status => 422
    end
  end

  def index
    @users = User.all 
    render json: @users, each_serializer: IndexUserSerializer
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
