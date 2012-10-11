﻿
window.onload = function(){

  if(document.getElementById('event_map') || document.getElementById('search_map')){ /* if true map is available */
      
      var mapOptions = {
                    center: new google.maps.LatLng(48.20833, 16.373064),
                    zoom: 16,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                  };
       
      var infoWindowText = document.createElement("div");
      infoWindowText.className = 'infobox';
      infoWindowText.style.cssText = "width:310px; height:75px; border:1px solid grey; border-radius:23px; margin-top: 8px; background: white; padding: 10px; text-align:center";

      var infoWindowOptions = {
        content: infoWindowText
        ,disableAutoPan: false
        ,maxWidth: 0
        ,pixelOffset: new google.maps.Size(-140, 25)
        ,zIndex: null
        ,boxStyle: { 
         background: "url('http://google-maps-utility-library-v3.googlecode.com/svn/tags/infobox/1.1.5/examples/tipbox.gif') no-repeat"
         ,opacity: 0.9
         ,width: "280px"
        }
        ,closeBoxMargin: "20px -6px 2px 2px"
        ,closeBoxURL: "http://www.google.com/intl/en_us/mapfiles/close.gif"
        ,infoBoxClearance: new google.maps.Size(1, 1)
        ,isHidden: false
        ,pane: "floatPane"
        ,enableEventPropagation: false
      };

      var infoWindow = new InfoBox(infoWindowOptions);
      var geocoder = geocoder = new google.maps.Geocoder();
      
      if(document.getElementById('event_map')){
        var map = new google.maps.Map(document.getElementById("event_map"), mapOptions);
        showEventOnMap(map, infoWindow, infoWindowText);
      }
      else if(document.getElementById('search_map')){
        var map = new google.maps.Map(document.getElementById("search_map"), mapOptions);
        prepareSearchMap(map);
      }
        
  }

  function showEventOnMap(map){

    var address = document.getElementById('address').innerHTML;
    
    geocoder.geocode( { 'address': address }, function(results, status) {
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
              position: results[result].geometry.location,
              title: results[result].formatted_address,
              icon: new google.maps.MarkerImage(
                          '/assets/event_star.png', // my 16x48 sprite with 3 circular icons
                          new google.maps.Size(25, 25), // desired size
                          new google.maps.Point(0, 0), // offset within the scaled sprite
                          new google.maps.Point(12.5,0), // anchor point is half of the desired size
                          new google.maps.Size(25, 25) // scaled size of the entire sprite
                           )
          });
          
          google.maps.event.addListener(marker, 'click', function(event){
            //marker.setAnimation(google.maps.Animation.BOUNCE);
            infoWindowText.innerHTML = marker.title;
            infoWindow.setPosition( event.latLng );
            infoWindow.open( map );
          });
        }
      } 
      else{
        console.log("Geocode was not successful for the following reason: " + status);
      }
    });
    
  }


  function prepareSearchMap(map){
    
    var marker;
    var start_address = new google.maps.LatLng(48.20833, 16.373064);
    
    if(document.getElementById('currentLocation').value.length){
      
      geocoder.geocode( { 'address': document.getElementById('currentLocation').value }, function(results, status) {
        
        if (status == google.maps.GeocoderStatus.OK){
          start_address = results[0].geometry.location;
          start_address = new google.maps.LatLng(start_address.Xa, start_address.Ya)
          
          
          if(marker)
           marker.setMap(null);
           
          marker = new google.maps.Marker({
              map: map,
              position: start_address,
              title: 'drag Marker to search for Events',
              icon: new google.maps.MarkerImage(
                          '/assets/event_star.png', // my 16x48 sprite with 3 circular icons
                          new google.maps.Size(25, 25), // desired size
                          new google.maps.Point(0, 0), // offset within the scaled sprite
                          new google.maps.Point(12.5,0), // anchor point is half of the desired size
                          new google.maps.Size(25, 25) // scaled size of the entire sprite
                           ),
              draggable: true
          });
          map.setCenter(start_address);
          
          google.maps.event.addListener(marker, 'dragend', function(event){
            marker.setAnimation(google.maps.Animation.BOUNCE);
            infoWindowText.innerHTML = 'Suche wird gestartet, bitte warten...';
            infoWindow.setPosition( event.latLng );
            infoWindow.open( map )
            window.location = "http://" + window.location.host + "/locationSearch?latlng=" + event.latLng;
          });
        }
        
      });
      
    }
    
    marker = new google.maps.Marker({
        map: map,
        position: start_address,
        title: 'drag Marker to search for Events',
        icon: new google.maps.MarkerImage(
                    '/assets/event_star.png', // my 16x48 sprite with 3 circular icons
                    new google.maps.Size(25, 25), // desired size
                    new google.maps.Point(0, 0), // offset within the scaled sprite
                    new google.maps.Point(12.5,0), // anchor point is half of the desired size
                    new google.maps.Size(25, 25) // scaled size of the entire sprite
                     ),
        draggable: true
    });
    
    map.setCenter(start_address);
    
    google.maps.event.addListener(marker, 'dragend', function(event){
      marker.setAnimation(google.maps.Animation.BOUNCE);
      infoWindowText.innerHTML = 'Suche wird gestartet, bitte warten...';
      infoWindow.setPosition( event.latLng );
      infoWindow.open( map )
      window.location = "http://" + window.location.host + "/locationSearch?latlng=" + event.latLng;
    });
  }

  
};
