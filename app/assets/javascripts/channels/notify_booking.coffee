App.notify_booking = App.cable.subscriptions.create "NotifyBookingChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    if((parseInt($('#pid').val()) == parseInt(data.parking_id)) and ((parseInt(data.status))==0))
      if(data.vehicle_type == 'car')
        car_spots = parseInt($('#car-spots').text())
        $('#car-spots').text(car_spots-1)
        booking_info = "Vehicle type: " + data.vehicle_type
        nb = new Notification('BOOKING INFO',{body:booking_info})
      else
        bike_spots = parseInt($('#bike-spots').text())
        $('#bike-spots').text(bike_spots-1)
        booking_info = "Vehicle type: " + data.vehicle_type
        nb = new Notification('BOOKING INFO',{body:booking_info})
    else

      if(($('#ticket-table-rows tr').size() < 8) and(parseInt(data.status)==1))
          $('#ticket-table-rows').append("<tr><td>" + data.license + "</td>
            <td>" + data.vehicle_type + "</td>
            <td>" + data.booked_hours + "</td>
            <td> <a class='btn btn-primary' href='" + "/admin_panel/checkin?token=" + data.token + "'>Check in</a></td></tr>")


    # Called when there's incoming data on the websocket for this channel
