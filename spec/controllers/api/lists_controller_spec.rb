require 'spec_helper'

describe Api::ListsController do 
  describe "create" do

    context "with correct user's password" do
      it "takes a list name, creates it if it doesn't exist, and returns false if it does" do
        user = FactoryGirl.create(:user)
        json = { :user_id => user.id, :format => 'json', :list => { :name => "testlist" } }
        post :create, json
        expect(response.status).to eql 200

        # params = { 'list' => { listname: 'testlist' } } 
        # expect{ post :create, params }.to change{ List.count }.by 1 
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
end
