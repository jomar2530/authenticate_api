require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user_params) do
    { user: { username: 'John1234', password: 'Pass1234!', password_confirmation: 'Pass1234!' },
    format: :json}
  end

  before :each do
    post :create, params: user_params
  end

  context 'signup' do
    it "create user with valid params" do
      expect(response.status).to eql 200
      expect(JSON.parse(response.body)).to eq({"user"=>{"id"=>1, "username"=>"John1234"}})
    end

    it "should return an error if username is duplicate" do
      post :create, params: user_params
      expect(response.status).to eql 401
      expect(JSON.parse(response.body)).to eq({"errors"=>["Username has already been taken"]})
    end

    it "should return an error if password and confirm password is not equal" do
      post :create, params:  { user: { username: 'John1234', password: 'Pass1234!', password_confirmation: 'pass' }, format: :json }
      expect(response.status).to eql 401
      expect(JSON.parse(response.body)).to eq({"errors"=>["Password confirmation doesn't match Password", "Username has already been taken"]})
    end
  end

  context 'sign in' do
    it "login user with valid params" do
      post :auth, params: user_params

      expect(response.status).to eql 200
      expect(JSON.parse(response.body)).to eq({"user"=>{"id"=>1, "username"=>"John1234"}})
    end

    it "should return an error id user is not authenticated" do
      post :auth, params:  { user: { username: 'John1234', password: 'pass!', password_confirmation: 'pass!' }, format: :json }

      expect(response.status).to eql 401
      expect(JSON.parse(response.body)).to eq({"errors"=>["Wrong username or password"]})
    end
  end
end
