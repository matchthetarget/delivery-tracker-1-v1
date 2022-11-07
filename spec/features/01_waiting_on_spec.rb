require "rails_helper"

describe "The Waiting on section" do
  it "displays each package delivery description", points: 1 do
    visit("/user_sign_in")
    user_jacob = User.new
    user_jacob.email = "jacob_#{rand(100)}@example.com"
    user_jacob.password = "password"
    user_jacob.save

    visit "/user_sign_in"

    within(:css, "form") do
      fill_in "Email", with: user_jacob.email
      fill_in "Password", with: user_jacob.password
      find("button", :text => /Sign in/i ).click
    end

    visit("/")

    date = 3.days.from_now.to_date
    formatted_date = date.strftime("%m/%d/%Y")

    within(:css, "form") do
      fill_in "Description", with: "New phone"
      fill_in "Supposed to arrive on", with: formatted_date
      fill_in "Details", with: "This package is important!"
      find("button", :text => /Log delivery/ ).click
    end
  
    within(:css, "div.waiting_on") do
      expect(page).to have_text(/New phone/)
    end
  end
end

describe "The Waiting on section" do
  it "displays the expected arrival date for each package", points: 1 do
    visit("/user_sign_in")
    user_jacob = User.new
    user_jacob.email = "jacob_#{rand(100)}@example.com"
    user_jacob.password = "password"
    user_jacob.save

    visit "/user_sign_in"

    within(:css, "form") do
      fill_in "Email", with: user_jacob.email
      fill_in "Password", with: user_jacob.password
      find("button", :text => /Sign in/i ).click
    end

    visit("/")

    date = 3.days.from_now.to_date

    within(:css, "form") do
      fill_in "Description", with: "New phone"
      fill_in "Supposed to arrive on", with: date.to_s
      fill_in "Details", with: "This package is important!"
      find("button", :text => /Log delivery/ ).click
    end

    within(:css, "div.waiting_on") do
      expect(page).to have_text(/Supposed to arrive on\s*#{date.to_s}/)
    end
  end
end

describe "The Waiting on section" do
  it "has a button to mark a delivery as received with the text 'Mark as received'", points: 1, hints: h("copy_must_match") do
    visit("/user_sign_in")
    user_jacob = User.new
    user_jacob.email = "jacob_#{rand(100)}@example.com"
    user_jacob.password = "password"
    user_jacob.save

    visit "/user_sign_in"

    within(:css, "form") do
      fill_in "Email", with: user_jacob.email
      fill_in "Password", with: user_jacob.password
      find("button", :text => /Sign in/i ).click
    end

    visit("/")

    date = 3.days.from_now.to_date
    formatted_date = date.strftime("%m/%d/%Y")

    within(:css, "form") do
      fill_in "Description", with: "New phone"
      fill_in "Supposed to arrive on", with: formatted_date
      fill_in "Details", with: "This package is important!"
      find("button", :text => /Log delivery/ ).click
    end

    expect(page).to have_tag("button", :text => /Mark as received/)
  end
end

describe "The Waiting on section" do
  it "has buttons to move each delivery packages to the \"Received\" section", points: 2 do
    visit("/user_sign_in")
    user_jacob = User.new
    user_jacob.email = "jacob_#{rand(100)}@example.com"
    user_jacob.password = "password"
    user_jacob.save

    visit "/user_sign_in"

    within(:css, "form") do
      fill_in "Email", with: user_jacob.email
      fill_in "Password", with: user_jacob.password
      find("button", :text => /Sign in/i ).click
    end

    visit("/")
    date = 3.days.from_now.to_date
    formatted_date = date.strftime("%m/%d/%Y")

    within(:css, "form") do
      fill_in "Description", with: "New phone"
      fill_in "Supposed to arrive on", with: date.to_s
      fill_in "Details", with: "This package is important!"
      find("button", :text => /Log delivery/ ).click
    end

    within(:css, "div.waiting_on") do
      find("button", :text => /Mark as received/ ).click
    end

    waiting_on_div = find("div.waiting_on")
    expect(waiting_on_div).to_not have_content(/New phone/)

    received_section_div = find("div.received")
    expect(received_section_div).to have_text(/New phone/)
  end
end
