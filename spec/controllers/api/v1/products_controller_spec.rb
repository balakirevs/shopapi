require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  let(:user)    { create(:user) }
  let(:product) { create(:product, user: user) }
  before(:each) { api_authorization_header user.auth_token }

  describe 'GET #index' do
    before(:each) do
      4.times { create :product, user: user }
      get :index
    end

    let(:products_response) { json_response[:products] }

    context 'when is not receiving any product_ids parameter' do
      it 'returns 4 records from the database' do
        expect(products_response.size).to eql(4)
      end

      it 'returns the user object into each product' do
        products_response.each do |product_response|
          expect(product_response[:user]).to be_present
        end
      end

      it_behaves_like 'paginated list'

      it { should respond_with 200 }
    end

    context 'when product_ids parameter is sent' do
      before(:each) { get :index, params: { product_ids: user.product_ids } }

      it 'returns just the products that belong to the user' do
        products_response.each do |product_response|
          expect(product_response[:user][:email]).to eql user.email
        end
      end
    end
  end

  describe 'GET #show' do
    before(:each) { get :show, params: { id: product.id } }
    let(:product_response) { json_response[:product] }

    it 'returns the information about a reporter on a hash' do
      expect(product_response[:title]).to eql product.title
    end

    it 'has the user as a embeded object' do
      expect(product_response[:user][:email]).to eql product.user.email
    end

    it "should not reveal the user's token" do
      expect(product_response[:user][:token]).to be_falsey
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @product_attributes = attributes_for :product
        post :create, params: { user_id: user.id, product: @product_attributes }
      end

      let(:product_response) { json_response[:product] }

      it 'renders the json representation for the product record just created' do
        expect(product_response[:title]).to eql @product_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_product_attributes = { title: '', price: 'Twelve dollars' }
        post :create, params: { user_id: user.id, product: @invalid_product_attributes }
      end

      let(:product_response) { json_response }

      it 'renders an errors json' do
        expect(product_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(product_response[:errors][:price]).to include 'is not a number'
        expect(product_response[:errors][:title]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when is successfully updated' do
      before(:each) { patch :update, params: { user_id: user.id, id: product.id, product: { title: 'An expensive TV' } } }
      let(:product_response) { json_response[:product] }

      it 'renders the json representation for the updated product' do
        expect(product_response[:title]).to eql 'An expensive TV'
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) { patch :update, params: { user_id: user.id, id: product.id, product: { price: '' } } }
      let(:product_response) { json_response }

      it 'renders an errors json' do
        expect(product_response).to have_key(:errors)
      end

      it 'renders the json errors on why the product could not be updated' do
        expect(product_response[:errors][:price]).to include 'is not a number'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) { delete :destroy, params: { user_id: user.id, id: product.id } }

    it { should respond_with 204 }
  end
end
