require 'rails_helper'

describe "City search" do
  it "should show list of parking" do
    parking = create(:parking)
    visit '/'
    fill_in "search-bar", with: parking.city.name
    click_on 'Search'
    expect(page).to have_content 'BOOK NOW'
  end

  it "should diplay error if city not found" do
    create(:parking)
    visit "/"
    fill_in 'search-bar', with: 'xyz'
    click_on 'Search'
    expect(page).to have_content 'Sorry city is not available'
  end

  end
