require "rails_helper"

describe "The Received section" do
  it "displays each package delivery description", points: 1, js: true do
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

    date = 3.days.from_now.to_date.strftime("%m/%d/%Y")

    within(:css, "form") do
      fill_in "Description", with: "New phone"
      fill_in "Supposed to arrive on", with: date
      fill_in "Details", with: "This package is important!"
      find("button", :text => /Log delivery/ ).click
    end

    within(:css, "div.waiting_on") do
      find("button", :text => /Mark as received/ ).click
    end

    within(:css, "div.received") do
      expect(page).to have_text(/New phone/)
    end
  end
end

describe "The Received section" do
  it "displays the formatted updated at time for each package", points: 1, js: true do
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

    date = 3.days.from_now.to_date.strftime("%m/%d/%Y")

    within(:css, "form") do
      fill_in "Description", with: "New phone"
      fill_in "Supposed to arrive on", with: date
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
    within(:css, "div.received") do
      expect(page).to have_text(/Updated\s*#{formatted_updated_at_time} ago/)
    end
  end
end

describe "The Received section" do
  it "has a link to delete deliveries with the text \"Delete\"", points: 2, hint: h("copy_must_match"), js: true do
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
    date = 3.days.from_now.to_date.strftime("%m/%d/%Y")

    within(:css, "form") do
      fill_in "Description", with: "New phone"
      fill_in "Supposed to arrive on", with: date
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

describe "The home page" do
  it "displays the message, \"Added to list\", after logging a delivery", points: 1, hint: h("flash_messages"), js: true do
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

    formatted_date = 2.days.from_now.strftime("%m/%d/%Y")
    within(:css, "form") do
      fill_in "Description", with: "New phone"
      fill_in "Supposed to arrive on", with: formatted_date
      fill_in "Details", with: "This package is important!"
      find("button", :text => /Log delivery/i ).click
    end
    
    expect(page).to have_text(/Added to list/)
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

    formatted_date.gsub!("/", "\/")
    date_pattern = "/Supposed to arrive on\\s*#{date}/"

    visit("/")
    element_with_late_date = find_parent_element_from_text(date_pattern)

    expect(element_with_late_date).to have_color("red")
  end
end

# Must send String containing Regex
# returns first matching element (Capybara Node)
def find_parent_element_from_text(text)
  # Can't have variables, or the return value gets messed up
  js_code = "
  Array.from(document.querySelectorAll(\".waiting_on *\")).map( node => node.childNodes).map( (nodeList, index) => nodeList[index] = Array.from(nodeList) ).flat().filter( node => node.textContent.match(#{text}) && (node.childNodes.length == 1))[0]
  "

  node = page.evaluate_script(js_code)
  raise StandardError, "Unable to find text that matches #{text} in div with class 'waiting_on'" if node.blank?
  node
end
