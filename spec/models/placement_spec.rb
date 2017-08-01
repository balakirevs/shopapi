require 'rails_helper'

RSpec.describe Placement, type: :model do
  let(:placement) { build(:placement) }

  subject { placement }

  describe 'db' do
    context 'columns' do
      it { is_expected.to have_db_column(:order_id) }
      it { is_expected.to have_db_column(:product_id) }
      it { is_expected.to have_db_column(:quantity) }
    end
  end

  describe 'respond' do
    it { should respond_to :order_id }
    it { should respond_to :product_id }
    it { should respond_to :quantity }
  end

  describe 'relation' do
    it { should belong_to :order }
    it { should belong_to :product }
  end

  describe '#decrement_product_quantity!' do
    it 'decreases the product quantity by the placement quantity' do
      product = placement.product
      expect { placement.decrement_product_quantity! }.to change { product.quantity }.by(-placement.quantity)
    end
  end
end
