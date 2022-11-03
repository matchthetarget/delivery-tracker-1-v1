desc "Hydrate the database with some sample data to look at so that developing is easier"
task({ :sample_data => :environment}) do
  User.destroy_all
  Delivery.destroy_all

  usernames = ["alice", "bob", "carol", "doug", "ellen"]

  usernames.each do |username|
    user = User.new
    user.email = "#{username}@example.com"
    user.password = "password"
    user.save

    20.times do
      delivery = Delivery.new
      delivery.user_id = user.id
      delivery.description = Faker::Commerce.product_name
      delivery.details = "#{["FedEx", "UPS", "USPS"].sample} tracking ##{rand(1000000000000)}"
      delivery.supposed_to_arrive_on = Faker::Date.between(from: 1.month.ago, to: 2.weeks.from_now)

      if delivery.supposed_to_arrive_on < Time.now
        delivery.arrived = [true, false].sample
      else
        delivery.arrived = false
      end

      delivery.save
    end
  end
end
