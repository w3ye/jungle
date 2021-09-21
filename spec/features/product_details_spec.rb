require 'rails_helper'

RSpec.feature "ProductDetails", type: :feature, js: true do

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

  scenario "They want to see a single product" do
    visit root_path

    expect(page).to have_link href: '/products/1'
    visit '/products/1'

    # the main container for content exists
    expect(page.find(".row").visible?).to be true

    expect(page).to have_content("$64.99")
  end

end
