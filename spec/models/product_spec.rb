require 'rails_helper'

RSpec.describe Product, type: :model do

  describe Product do
    let!(:product_1) { create(:product, title: 'A plasma TV', price: 100) }
    let!(:product_2) { create(:product, title: 'Fastest Laptop', price: 50) }
    let!(:product_3) { create(:product, title: 'CD player', price: 150) }
    let!(:product_4) { create(:product, title: 'LCD TV', price: 99) }

    subject { create(:product) }

    describe 'respond' do
      it { should respond_to(:title) }
      it { should respond_to(:price) }
      it { should respond_to(:published) }
      it { should respond_to(:user_id) }
      it { should respond_to(:user) }

      it { should be_valid }
    end

    describe 'validation' do
      it { should validate_presence_of :title }
      it { should validate_presence_of :price }
      it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
      it { should validate_presence_of :user_id }
    end

    describe 'relation' do
      it { should belong_to :user }
      it { should have_many(:placements) }
      it { should have_many(:orders).through(:placements) }
    end

    describe '.filter_by_title' do
      context "when a 'TV' title pattern is sent" do
        it 'returns the 2 products matching' do
          expect(Product.filter_by_title('TV').size).to eq(2)
        end

        it 'returns the products matching' do
          expect(Product.filter_by_title('TV').sort).to match_array([product_1, product_4])
        end
      end
    end

    describe '.filter_by_above_or_equal_to_price' do
      it 'returns the products which are above or equal to the price' do
        expect(Product.above_or_equal_to_price(100).sort).to match_array([product_1, product_3])
      end
    end

    describe '.below_or_equal_to_price' do
      it 'returns the products which are below or equal to the price' do
        expect(Product.below_or_equal_to_price(99).sort).to match_array([product_2, product_4])
      end
    end

    describe '.recent' do
      before(:each) do
        # Touch some products to update them
        product_2.touch
        product_3.touch
      end

      it 'returns the most updated records' do
        expect(Product.recent).to match_array([product_3, product_2, product_4, product_1])
      end
    end

    describe '.search' do
      context "when title 'A plasma TV' and '100' a min price are set" do
        it 'returns an empty array' do
          search_hash = { keyword: 'A plasma TV', min_price: 150 }
          expect(Product.search(search_hash)).to be_empty
        end
      end

      context "when title 'CD player', '150' as max price, and '50' as min price are set" do
        it 'returns the product_3' do
          search_hash = { keyword: 'CD player', min_price: 50, max_price: 150 }
          expect(Product.search(search_hash)).to match_array([product_3])
        end
      end

      context "when title 'CD', '150' as max price, and '99' as min price are set" do
        it 'returns the product_3, product_4' do
          search_hash = { keyword: 'CD', min_price: 99, max_price: 150 }
          expect(Product.search(search_hash)).to match_array([product_3, product_4])
        end
      end

      context 'when an empty hash is sent' do
        it 'returns all the products' do
          expect(Product.search({})).to match_array([product_1, product_2, product_3, product_4])
        end
      end

      context 'when product_ids is present' do
        it 'returns the product from the ids' do
          search_hash = { product_ids: [product_1.id, product_2.id]}
          expect(Product.search(search_hash)).to match_array([product_1, product_2])
        end
      end
    end
  end
end
