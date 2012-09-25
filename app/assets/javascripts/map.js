
window.onload = function(){
  
  if(document.getElementById('event_map')){
      showEventOnMap();
  }
  
};

function showEventOnMap(){

  var mapOptions = {
                    center: new google.maps.LatLng(-34.397, 150.644),
                    zoom: 8,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                  };
                  
  var map = new google.maps.Map(document.getElementById("event_map"), mapOptions);
  
  var geocoder = geocoder = new google.maps.Geocoder();
  
  geocoder.geocode( { 'address': document.getElementById('address').innerHTML }, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      
      if( results.length > 1){
        document.getElementById('map_notifier').style.display = 'inline';
        document.getElementById('map_notifier').innerHTML = 'Es gibt mehrere Treffer auf der Karte!';
        $('#map_notifier').fadeOut(8000);
      }
        
      for(var result=0; result < results.length; result++){
        map.setCenter(results[result].geometry.location);
        var marker = new google.maps.Marker({
            map: map,
            position: results[result].geometry.location
        });
      }
    } 
    else{
      console.log("Geocode was not successful for the following reason: " + status);
    }
  });
  
}