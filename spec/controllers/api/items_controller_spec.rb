require 'spec_helper'

describe Api::ItemsController do 
  describe "#create" do
    let(:user) { create(:user) }
    let(:credentials) {{:username => user.username, :password => user.password}}
    let(:invalid_credentials) { {:username => user.username, :password => "failed"}} 
    let(:list) { create(:list, user: user) }
    
    context "with correct user credential and list name" do
      it "creates an item on the list" do
        item = {description: "Feed boy"}
        post :create, :list_id => list, item: item, user: credentials

        # Restclient.post 'http://lvh.m:3000/api/list#create', json
        # Restclient.post 'http://lvh.m:3000/api/list#create', json
        # /api/lists/:list_id/items(.:format) 

        expect(response.status).to eql 200
        expect(JSON.parse(response.body)).to eql(
          {"item" => 
            {"id"=>list.items.first.id, "description"=>"Feed boy", "completed"=>false}
          }
        )
      end
    end

    context "with incorrect credentials" do
      it "returns an error" do
        item = {description: "Feed boy"}
        post :create, :list_id => list, item: item, user: invalid_credentials
        expect(response.status).to eql 422
        expect(response.body).to include "User credentials are not correct"
      end
    end
  end
end
