require 'spec_helper'

describe Api::ListsController do 

  let(:user) { create(:user) }
  let(:credentials) { {:user => {:username => user.username, :password => user.password}} }
  let(:invalid_credentials) { {:user => {:username => user.username, :password => "failed"}} }

  describe "#create" do

    context "with correct user's password" do
      it "creates list succesfully" do
        json = credentials.merge({:list => {:name => "Shopping List", :permissions => "private"}})
        expect{ post :create, json }.to change{ List.count }.by 1
      end

      it "cannot create list if list name already exists" do
        list = create(:list, user: user)
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

      it "returns all lists associated with the user" do
        ids = []
        3.times do |n|
          list = create(:list, user_id: user.id, name: "list #{n}")
          ids << list.id 
        end
        get :index, credentials
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
        user2 = create(:user)
        ids = []
        3.times do |n|
          list = create(:list, user_id: user.id, name: "list #{n}")
          create(:list, user_id: user2.id, name: "user2 list #{n}")
          ids << list.id 
        end
        get :index, credentials
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
      it "returns all visible and open lists" do
        get :index, invalid_credentials
        expect(response.body).to include "User credentials are not correct"
      end
    end
  end

  describe "#show" do
    context "with correct user's password" do
      it "returns a list based on a list id" do
        list = create(:list, user_id: user.id, name: "list n")
        item = create(:item, list_id: list.id, description: "item 1") 
        item2 = create(:item, list_id: list.id, description: "item 2") 

        get :show, :id => list, user: credentials[:user]
        expect(JSON.parse(response.body)).to eql(
          {"list" =>
            {"id" => list.id, 
              "name" => list.name,
              "permissions" => "private",
              "items" =>
              [
                {"id" => item.id, "description" => item.description },
                {"id" => item2.id, "description" => item2.description }
              ]
            }
          }
        )
      end
    end
  end

  describe "#update" do
    context "with correct user's password, and ownder of list, can update permissions and name" do
      it "returns an updated list with permissions changed" do
        list = create(:list, user_id: user.id, name: "list n")
        item = create(:item, list_id: list.id, description: "item 1") 

        put :update, :id => list.id, :user=> credentials, :list => {:name => "I'm the owner", :permissions => "viewable"}
        expect(JSON.parse(response.body)).to eql(
          {"list" =>
            {"id" => list.id, 
              "name" => "I'm the owner",
              "permissions" => "viewable",
              "items" =>
                [
                  {"id" => item.id, "description" => item.description },
                ]
            }
          }
        )
      end
    end

    context "with correct user's password, but not owner" do
      it "can update open lists names and items, but not permissions" do
        @list_owner = create(:user)
        list = create(:list, user_id: @list_owner.id, name: "list n", permissions: "open")
        item = create(:item, list_id: list.id, description: "item 1") 

        put :update, :id => list.id, :user=> credentials[:user], :list => {:name => "I'm not the owner", :permissions => "viewable"}
        expect(JSON.parse(response.body)).to eql(
          {"list" =>
            {"id" => list.id, 
              "name" => "I'm not the owner",
              "permissions" => "open",
              "items" =>
                [
                  {"id" => item.id, "description" => item.description },
                ]
            }
          }
        )
      end
      it "can not update private lists" do
        @list_owner = create(:user)
        list = create(:list, user_id: @list_owner.id, name: "list n", permissions: "private")

        put :update, :id => list.id, :user=> credentials[:user], :list => {:name => "I'm not the owner", :permissions => "viewable"}
        expect(response.status).to eq(401)
      end

      it "can not update viewable lists" do
        @list_owner = create(:user)
        list = create(:list, user_id: @list_owner.id, name: "list n", permissions: "viewable")

        put :update, :id => list.id, :user=> credentials[:user], :list => {:name => "I'm not the owner", :permissions => "viewable"}
        expect(response.status).to eq(401)
      end

    end
  end

end
