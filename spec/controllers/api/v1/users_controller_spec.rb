require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  let(:user) { create(:user) }

  describe 'GET #show' do
    before(:each) do
      get :show, params: { id: user.id }, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      user_response = json_response[:user][:email]
      expect(user_response).to eql user.email
    end

    it 'has the product ids as an embeded object' do
      user_response = json_response[:user][:product_ids]
      expect(user_response).to eql []
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @user_attributes = attributes_for :user
        post :create, params: { user: @user_attributes }, format: :json
      end

      it 'renders the json representation for the user record just created' do
        user_response = json_response[:user][:email]
        expect(user_response).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_user_attributes = { password: "12345678", password_confirmation: "12345678" }
        post :create, params: { user: @invalid_user_attributes }, format: :json
      end

      it 'renders an errors json' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        user_response = json_response[:errors][:email]
        expect(user_response).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      api_authorization_header user.auth_token
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, params: { id: user.id, user: { email: "newmail@example.com" } }, format: :json
      end

      it 'renders the json representation for the updated user' do
        user_response = json_response[:user][:email]
        expect(user_response).to eql 'newmail@example.com'
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, params: { id: user.id, user: { email: 'bademail.com' } }, format: :json
      end

      it 'renders an errors json' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        user_response = json_response[:errors][:email]
        expect(user_response).to include 'is invalid'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      api_authorization_header user.auth_token
      delete :destroy, params: { id: user.id }, format: :json
    end

    it { should respond_with 204 }
  end
end
