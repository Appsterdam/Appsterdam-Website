class EventsController < ApplicationController
  allow_access :all
  
  def index
    from_date = params[:from_date] ? Date.parse(params[:from_date]) : Date.today
    to_date = params[:to_date] ? Date.parse(params[:to_date]) : from_date.end_of_week
    
    @events = Event.find :all,
      :conditions => ["starts_at >= ? AND starts_at <= ?", from_date.beginning_of_day, to_date.end_of_day],
      :order      => "starts_at"
    
    @events_per_day = @events.inject({}) do |idx, event|
      day = event.starts_at.to_date
      idx[day] ||= []
      idx[day] << event
      event.get_geo_coordinates unless event.lat
      idx
    end

    @next_monday = from_date.beginning_of_week + 7

    render :index
  end
    
  def show
    @event = Event.find(params[:id])
  end
end
