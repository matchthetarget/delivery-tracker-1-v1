class DeliveriesController < ApplicationController
  def index
    @arrived = @current_user.deliveries.
      where(arrived: true).
      order(updated_at: :desc)
    
    @not_arrived = @current_user.deliveries.
      where.not(arrived: true).
      order(supposed_to_arrive_on: :asc)

    render({ :template => "deliveries/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_deliveries = Delivery.where({ :id => the_id })

    @the_delivery = matching_deliveries.at(0)

    render({ :template => "deliveries/show.html.erb" })
  end

  def create
    the_delivery = Delivery.new
    the_delivery.user_id = @current_user.id
    the_delivery.supposed_to_arrive_on = params.fetch("query_supposed_to_arrive_on")
    the_delivery.description = params.fetch("query_description")
    the_delivery.details = params.fetch("query_details")
    the_delivery.arrived = false

    if the_delivery.valid?
      the_delivery.save
      redirect_to("/", { :notice => "Added to list." })
    else
      redirect_to("/", { :alert => the_delivery.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_delivery = Delivery.where({ :id => the_id }).at(0)

    the_delivery.arrived = params.fetch("arrived")

    if the_delivery.valid?
      the_delivery.save
      redirect_to("/", { :notice => "Marked as received."} )
    else
      redirect_to("/", { :alert => the_delivery.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_delivery = Delivery.where({ :id => the_id }).at(0)

    the_delivery.destroy

    redirect_to("/", { :notice => "Deleted."} )
  end
end
