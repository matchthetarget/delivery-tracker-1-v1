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

    expect(page).to have_tag("div.waiting_on") do     
      with_tag("ul") do
        with_tag("li", text: /Supposed to arrive on\s*#{date.to_s}/)
      end
    end
  end
end

describe "The text of the expected arrival date" do
  it "is darkred when the date is more than 3 days ago", points: 1, js: true do
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

    date = 1.week.ago.to_date
    formatted_date = date.strftime("%m/%d/%Y")

    within(:css, "form") do
      fill_in "Description", with: "New phone"
      fill_in "Supposed to arrive on", with: formatted_date
      fill_in "Details", with: "This package is important!"
      find("button", :text => /Log delivery/ ).click
    end

    formatted_date.gsub("/", "\/")
    date_pattern = "/Supposed to arrive on\\s*#{date}/"
    visit "/"
    element_with_late_date = find_parent_element_from_text(date_pattern)
   
    expect(element_with_late_date).to have_color("red")
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

    within(:css, "div.waiting_on li") do      
      find("button", :text => /Mark as received/ ).click
    end
  
    waiting_on_div = find("div.waiting_on")
    expect(waiting_on_div).to_not have_content(/New phone/)
  end
end

describe "The Waiting on section" do
  it "has buttons to move delivery packages to the \"Received\" section", points: 2 do
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

    received_section_div = find("div.received")
    expect(received_section_div).to have_text(/New phone/i)
  end
end

# Must send String containing Regex
# returns first matching element (Capybara Node)
def find_parent_element_from_text(text)
  node = page.evaluate_script("Array.prototype.slice.call(document.querySelector(\"div.waiting_on li\").childNodes).filter( node => node.textContent.match(#{text}))[0]")
  raise StandardError, "Unable to find text that matches #{text}" if node.blank?
  node
end
