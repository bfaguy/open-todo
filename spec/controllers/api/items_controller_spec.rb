require 'spec_helper'

describe Api::ItemsController do 

  let(:user) { create(:user) }
  let(:credentials) {{:username => user.username, :password => user.password}}
  let(:invalid_credentials) { {:username => user.username, :password => "failed"}} 
  let(:list) { create(:list, user: user) }

  describe "#create" do
    context "with correct user credential and list name" do
      it "creates an item on the list" do
        item = {description: "Feed boy"}
        post :create, :list_id => list, item: item, user: credentials

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

  describe "#update" do
    context "with correct user credential and list name" do
      it "marks a item as complete when completed true is passed in" do
        item = create(:item, list_id: list.id)
        Item.find(item.id).completed.should be_false
        patch :update, list_id: list, id: item, completed: true, user: credentials
        expect(response.status).to eql 200
        Item.find(item.id).completed.should be_true
      end
    end
  end
end
