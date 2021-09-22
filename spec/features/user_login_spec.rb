require 'rails_helper'

RSpec.feature "UserLogins", type: :feature, js: true do
  before do
    @user = User.create!(name: "Presly Dodson", email: "test@test.com", password: "123", password_confirmation: "123")

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

  scenario "Should redirect me to the home page once loged in" do
    visit '/login'
    fill_in 'email', with: 'test@test.com'
    fill_in 'password', with: '123'
    click_button 'Submit'
    expect(current_path).to eq root_path
    expect(page).to have_content('Presly Dodson')
    within('.navbar') { expect(page).to have_link('Logout') }
  end
end
