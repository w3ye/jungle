require 'rails_helper'

RSpec.feature "AddToCarts", type: :feature, js: true do

  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name: Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "The My Cart will increase by 1 if I add something to cart" do
    visit root_path

    within(".navbar") { expect(page).to have_link 'My Cart (0)', href: '/cart' }

    click_button 'Add'

    within(".navbar") { expect(page).to have_link 'My Cart (1)', href: '/cart' }

  end

end
