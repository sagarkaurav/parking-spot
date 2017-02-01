function CitySearchHeight()
{
  w_h = $(window).height();
  c_s_h = $('#city-search').height();
  $('#city-search').css('margin-top',((w_h-c_s_h)/3));
}
function feedPosition(position)
{
  $('#longitude').val(position.coords.longitude);
  $('#latitude').val(position.coords.latitude);
}

function GeoLocation()
{
  if(navigator.geolocation)
  {
    navigator.geolocation.getCurrentPosition(feedPosition)
  }
}

$(document).ready(function(){
  CitySearchHeight();
  GeoLocation();
  $('#search-bar').autocomplete({
    source: $('#tags').val().split(","),
    delay: 0
  });
});

$(window).resize(function(){
  CitySearchHeight();
});
