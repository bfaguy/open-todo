require 'spec_helper'

describe Api::Lists::ItemsController do 
  describe "#create" do
    let(:user) { create(:user) }
    let(:credentials) { {:user => {:username => user.username, :password => user.password}} }
    let(:invalid_credentials) { {:user => {:username => user.username, :password => "failed"}} }
    let(:list) { create(:list, user: user) }
    
    context "with correct user credential and list name" do
      it "creates an item on the list" do
        item = {description: "Feed boy"}
        post :create, :list_id => list, :item => item
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)).to eql(
          {"item"=>{"id"=>list.items.first.id, "description"=>"test item", "completed"=>false}}
        )
      end
    end
  end
end
