require 'spec_helper'

describe Api::ListsController do 

  describe "#create" do
    let(:user) { FactoryGirl.create(:user) }
    let(:credentials) { {:user => {:username => user.username, :password => user.password}} }
    let(:invalid_credentials) { {:user => {:username => user.username, :password => "failed"}} }

    context "with correct user's password" do

      it "creates list succesfully" do
        json = credentials.merge({:list => {:name => "Shopping List", :permissions => "private"}})
        expect{ post :create, json }.to change{ List.count }.by 1
      end

      it "cannot create list if list name already exists" do
        list = FactoryGirl.create(:list, user: user)
        json = credentials.merge(:list => {:name => list.name, :user_id => user.id, :permissions => "private"})
        expect{ post :create, json }.to_not change{ List.count }.by 1
        expect(response.body).to include "List was not created"
        expect(assigns(:list).errors.messages.to_s).to include "List name already exists"
      end
    end

    context "without correct user's password" do
      it "it errors" do
        json = invalid_credentials.merge({:list => {:name => "Shopping List", :permissions => "private"}})
        expect{ post :create, json }.to_not change{ List.count }.by 1
        expect(response.body).to include "User credentials are not correct"
      end
    end
  end

  describe "#index" do
    context "with correct user's password" do
      it "returns all lists associated with the user"
    end

    context "without correct user's password" do
      it "returns all visible and open lists"
    end
  end

end
