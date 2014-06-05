class Api::ItemsController < ApiController

  def create
    @list = List.find(params[:list_id])
    if @list.add(item_params[:description])
      render json: @list.items.last
    else
      message = "Item was not created"
      error(422, message)
    end
  end

  private

  def item_params
    params.require(:item).permit(:description, :list_id, :completed)
  end
end
