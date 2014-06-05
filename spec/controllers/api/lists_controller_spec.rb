require 'spec_helper'

describe Api::ListsController do 

  describe "#create" do
    context "with correct user's password" do

      it "creates list succesfully" do
        user = create(:user)
        json = {:user => {:username => user.username, :password => user.password}, :list => {:name => "Shopping List", :permissions => "private"}}
        expect{ post :create, json }.to change{ List.count }.by 1
      end

      it "cannot create list if list name already exists" do
        user = create(:user)
        list = create(:list, user_id: user.id)
        json = {:user => {:username => user.username, :password => user.password},
          :list => {:name => list.name, :permissions => "private"}}
        expect{ post :create, json }.to_not change{ List.count }.by 1
        expect(response.body).to include "List was not created"
        expect(assigns(:list).errors.messages.to_s).to include "List name already exists"
      end
    end

    context "without correct user's password" do
      it "should return an error" do
        user = create(:user)
        json = {:user => {:username => user.username, :password => "failed"}, :list => {:name => "Shopping List", :permissions => "private"}}
        expect{ post :create, json }.to_not change{ List.count }.by 1
        expect(response.body).to include "User credentials are not correct"
      end
    end
  end

  describe "#index" do
    context "with correct user's password" do

      it "returns all lists associated with the user" do
        user = create(:user)
        ids = []
        3.times do |n|
          list = create(:list, user_id: user.id, name: "list #{n}")
          ids << list.id 
        end
        json = {:user => {:username => user.username, :password => user.password} }
        get :index, json
        expect(JSON.parse(response.body)).to eql(
          {"lists" =>
            [
              {"id"=>ids[0], "name"=>"list 0"},
              {"id"=>ids[1], "name"=>"list 1"},
              {"id"=>ids[2], "name"=>"list 2"}
            ]
          }
        )
      end

      it "does not return lists associated with other users" do
        user = create(:user)
        user2 = create(:user)
        ids = []
        3.times do |n|
          list = create(:list, user_id: user.id, name: "list #{n}")
          create(:list, user_id: user2.id, name: "user2 list #{n}")
          ids << list.id 
        end
        json = {:user => {:username => user.username, :password => user.password} }
        get :index, json
        binding.pry
        expect(JSON.parse(response.body)).to eql(
          {"lists" =>
            [
              {"id"=>ids[0], "name"=>"list 0"},
              {"id"=>ids[1], "name"=>"list 1"},
              {"id"=>ids[2], "name"=>"list 2"}
            ]
          }
        )
      end
    end

    context "without correct user's password" do
      it "returns all visible and open lists"
    end
  end

end
