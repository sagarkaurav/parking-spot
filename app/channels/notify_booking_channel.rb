class NotifyBookingChannel < ApplicationCable::Channel
  def subscribed
     stream_from "notify_booking"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
