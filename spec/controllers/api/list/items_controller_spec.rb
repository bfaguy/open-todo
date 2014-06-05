scribe Api::ListsController::ItemsController do 
  describe "#create" do
    let(:user) { FactoryGirl.create(:user) }
    let(:credentials) { {:user => {:username => user.username, :password => user.password}} }
    let(:invalid_credentials) { {:user => {:username => user.username, :password => "failed"}} }
    let(:list) {FactoryGirl.create(:list, user: user)}
    
    context "with correct user credential and list name" do
      it "creates an item on the list" do
        items = {items => {1 => "Clean", 2 => "Feed dog", 3 => "Feed boy"}}
        post :create, list => attributes_for(list, items: items)
      end
    end
  end
end
