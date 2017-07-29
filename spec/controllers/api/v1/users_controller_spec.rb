require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #show' do
    before(:each) { get :show, params: { id: user.id } }

    let(:user_response) { json_response[:user] }

    it 'returns the information about a reporter on a hash' do
      expect(user_response[:email]).to eql user.email
    end

    it 'has the product ids as an embeded object' do
      expect(user_response[:product_ids]).to eql []
    end

    it 'should exclude user token' do
      expect(user_response[:token]).to be_falsey
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @user_attributes = attributes_for :user
        post :create, params: { user: @user_attributes }
      end

      let(:user_response) { json_response[:user] }

      it 'renders the json representation for the user record just created' do
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_user_attributes = attributes_for :user, email: nil
        post :create, params: { user: @invalid_user_attributes }
      end

      let(:user_response) { json_response }

      it 'renders an errors json' do
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) { api_authorization_header user.auth_token }

    context 'when is successfully updated' do
      before(:each) { patch :update, params: { id: user.id, user: { email: 'newmail@example.com' } } }

      let(:user_response) { json_response[:user] }

      it 'renders the json representation for the updated user' do
        expect(user_response[:email]).to eql 'newmail@example.com'
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) { patch :update, params: { id: user.id, user: { email: 'bademail.com' } } }

      let(:user_response) { json_response }

      it 'renders an errors json' do
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        expect(user_response[:errors][:email]).to include 'is invalid'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      api_authorization_header user.auth_token
      delete :destroy, params: { id: user.id }
    end

    it { should respond_with 204 }
  end
end
