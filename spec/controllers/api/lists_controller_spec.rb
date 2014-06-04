require 'spec_helper'

describe Api::ListsController do 

  describe "#create" do
    context "with correct user's password" do

      it "creates list succesfully" do
        user = FactoryGirl.create(:user)
        json = {:user => {:username => user.username, :password => user.password}, 
          :list => {:name => "Shopping List", :user_id => user.id, :permissions => "private"}}
        expect{ post :create, json }.to change{ List.count }.by 1
      end

      it "cannot create list if list name already exists" do
        user = FactoryGirl.create(:user)
        list = FactoryGirl.create(:list, user_id: user.id)
        json = {:user => {:username => user.username, :password => user.password},
          :list => {:name => list.name, :user_id => user.id, :permissions => "private"}}
        expect{ post :create, json }.to_not change{ List.count }.by 1
        expect(response.body).to include "List was not created"
        expect(assigns(:list).errors.messages.to_s).to include "List name already exists"
      end
    end

    context "without correct user's password" do
      it "it errors"
    end
  end

  describe "index" do
    context "with correct user's password" do
      it "returns all lists associated with the user"
    end

    context "without correct user's password" do
      it "returns all visible and open lists"
    end
  end

end
