require 'rails_helper'

RSpec.describe Product, type: :model do

  before(:all) do
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end

  describe 'Validations' do
    before(:all) do
      @category = Category.new(name: "food")
      @category.save
      @product = Product.new(name: "pizza", description: "cheese", price_cents: 2000, quantity: 20, category_id: @category.id)
      @product.save
    end

    it 'should have a name' do
      expect(@product.name).to be_present
    end

    it 'should have a price' do
      expect(@product.price_cents).to be_present
    end

    it 'should have a quantity' do
      expect(@product.quantity).to be_present
    end

    it 'should have a category' do
      expect(@product.category_id).to be_present
    end
  end

  describe 'Error Validations' do

    before(:all) do
      @category = Category.new(name: "fashion")
      @category.save
    end

    it 'should return error if there is no name' do
      @product = Product.new(name: nil, description: "black", price_cents: 2000, quantity: 10, category_id: @category.id)
      expect { @product.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should return error if there is no price' do
      @product = Product.new(name: 'shoes', description: "black", price_cents: nil, quantity: 10, category_id: @category.id)
      expect { @product.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should return error if there is no quantity' do
      @product = Product.new(name: 'shoes', description: "black", price_cents: 2000, quantity: nil, category_id: @category.id)
      expect { @product.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should return error if there is no category' do
      @product = Product.new(name: 'shoes', description: "black", price_cents: 2000, quantity: nil, category_id: nil)
      expect { @product.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
