require "rails_helper"

describe "The Received section" do
  it "displays each package delivery in an `<li>` element", points: 1 do
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
      find("button", :text => /Mark as received/ ).click
    end

    expect(page).to have_tag("div.received") do     
      with_tag("ul") do
        with_tag("li", text: /New phone/)
      end
    end
  end
end

describe "The Received section" do
  it "displays the formatted updated at time for each package", points: 1 do
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

    updated_at = nil
    travel_to 2.days.from_now do
      updated_at = Time.current
      within(:css, "div.waiting_on") do
        find("button", :text => /Mark as received/ ).click
      end
    end

    visit("/")

    formatted_updated_at_time = time_ago_in_words(updated_at)
    expect(page).to have_tag("div.received") do     
      with_tag("ul") do
        with_tag("li", text: /Updated \s*#{formatted_updated_at_time} ago/)
      end
    end
  end
end


describe "The Received section" do
  it "has a link to delete deliveries with the text \"Delete\"", points: 2, hint: h("copy_must_match") do
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
      find("button", :text => /Mark as received/ ).click
    end

    within(:css, "div.received li") do      
      find("a", :text => /Delete/i ).click
    end
    
    expect(page).to_not have_content(/New phone/)
  end
end
