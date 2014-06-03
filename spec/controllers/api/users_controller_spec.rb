require 'spec_helper'

describe Api::UsersController do

  before do
    User.destroy_all
  end

  describe "create" do
    it "creates and returns a new user from username and password params" do
      params = { 'user' => { 'username' => 'testuser', 'password' => 'testpass' } }
      expect{ post :create, params }.to change{ User.count }.by 1
      expect(JSON.parse(response.body)).to eql(params)
    end

    it "returns an error when not given a password" do
      post :create, { 'user' => { username: 'testuser' } }
      expect(response).to be_error 
      expect(response.body).to include "User was not create"
    end

    it "returns an error when not given a username" do
      post :create, { 'user' => { password: 'testpass' } }
      response.should be_error
    end
  end

  describe "index" do

    before do 
      (1..3).each{ |n| User.create( id: n, username: "name#{n}", password: "pass#{n}" ) }
    end

    it "lists all usernames and ids" do
      get :index

      JSON.parse(response.body).should == 
        { 'users' => 
          [
            { 'id' => 1, 'username' => 'name1' },
            { 'id' => 2, 'username' => 'name2' },
            { 'id' => 3, 'username' => 'name3' }
          ]
      }
    end
  end
end
