
window.onload = function(){

  if(document.getElementById('address_map') || document.getElementById('event_map') || document.getElementById('search_map')){ /* if true map is available */
      
      var mapOptions = {
                    center: new google.maps.LatLng(48.20833, 16.373064),
                    zoom: 16,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                  };
       
      var infoWindowText = document.createElement("div");
      infoWindowText.className = 'infobox';
      infoWindowText.style.cssText = "width:215px; height:45px; border:1px solid grey; border-radius:23px; margin-top: 8px; background: white; padding: 10px; text-align:center";

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
        ,closeBoxMargin: "20px 52px 2px 2px"
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
        showEventOnMap(map);
      }
      else if(document.getElementById('search_map')){
        var map = new google.maps.Map(document.getElementById("search_map"), mapOptions);
        prepareSearchMap(map);
      }
      else if(document.getElementById('address_map')){
        var map = new google.maps.Map(document.getElementById("address_map"), mapOptions);
        prepareAddressMap(map);
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
    
    if(document.getElementById('currentLocation').value.length)
      autoLocation(map,marker,document.getElementById('currentLocation').value,'searchMap');
    else{
    
      var start_address = new google.maps.LatLng(48.20833, 16.373064);
      
      marker = new google.maps.Marker({
          map: map,
          position: start_address,
          title: 'Ziehe Marker an die gewünschte Stelle und lass ihn los, um die Suche zu starten',
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
        
        infoWindow.open( null );
        
        var infoWindowText = document.createElement("div");
        infoWindowText.className = 'infobox';
        infoWindowText.style.cssText = "width:215px; height:45px; border:1px solid grey; border-radius:23px; margin-top: 8px; background: white; padding: 10px; text-align:center";
        infoWindowOptions.content = infoWindowText;
        
        infoWindowOptions.pixelOffset =  new google.maps.Size(-140, 25);
        infoWindowOptions.closeBoxMargin = "20px 52px 2px 2px";
        
        var newinfoWindow = new InfoBox(infoWindowOptions);
        
        marker.setAnimation(google.maps.Animation.BOUNCE);
        infoWindowText.innerHTML = 'Suche wird gestartet, bitte warten...';
        newinfoWindow.setPosition( event.latLng );
        newinfoWindow.open( map )
        window.location = "http://" + window.location.host + "/locationSearch?latlng=" + event.latLng;
      });
      
    }
    
    showSponsoredEventsOnMap(map);
  }
  
  
  function prepareAddressMap(map){
    
    var marker;
    
    if(document.getElementById('currentLocation').value.length || document.getElementById('event_address').value.length){
      if(document.getElementById('currentLocation').value.length)
        autoLocation(map,marker,document.getElementById('currentLocation').value,'addressMap');
      else
        autoLocation(map,marker,document.getElementById('event_address').value,'addressMap');
    }
    else{
    
      var start_address = new google.maps.LatLng(48.20833, 16.373064);
      
      var marker = new google.maps.Marker({
          map: map,
          position: start_address,
          title: 'Ziehe Marker an die gewünschte Stelle, um nach Veranstaltungen zu suchen',
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
        geocoder.geocode( { 'latLng': event.latLng }, function(results, status) {
          if (status == google.maps.GeocoderStatus.OK) {
            document.getElementById('event_address').value = results[0].formatted_address;
          }
        });
      });
    }
  
  }
  
  
  /* common methods */
  function autoLocation(map,marker,address,maptype){
      
    geocoder.geocode( { 'address': address }, function(results, status) {
      
      if (status == google.maps.GeocoderStatus.OK){
        var start_address = results[0].geometry.location;
        //start_address = new google.maps.LatLng(start_address);
        
        
        if(marker)
         marker.setMap(null);
         
        marker = new google.maps.Marker({
            map: map,
            position: start_address,
            title: 'Ziehe Marker an die gewünschte Stelle',
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
        
        if(maptype == 'searchMap'){
          google.maps.event.addListener(marker, 'dragend', function(event){
            infoWindow.open( null );
        
            var infoWindowText = document.createElement("div");
            infoWindowText.className = 'infobox';
            infoWindowText.style.cssText = "width:215px; height:45px; border:1px solid grey; border-radius:23px; margin-top: 8px; background: white; padding: 10px; text-align:center";
            infoWindowOptions.content = infoWindowText;
            
            infoWindowOptions.pixelOffset =  new google.maps.Size(-140, 25);
            infoWindowOptions.closeBoxMargin = "20px 52px 2px 2px";
            
            var newinfoWindow = new InfoBox(infoWindowOptions);
            
            marker.setAnimation(google.maps.Animation.BOUNCE);
            infoWindowText.innerHTML = 'Suche wird gestartet, bitte warten...';
            newinfoWindow.setPosition( event.latLng );
            newinfoWindow.open( map )
            window.location = "http://" + window.location.host + "/locationSearch?latlng=" + event.latLng;
            
          });
        }
        else if(maptype == 'addressMap'){
          google.maps.event.addListener(marker, 'dragend', function(event){
            geocoder.geocode( { 'latLng': event.latLng }, function(results, status) {
              document.getElementById('event_address').value = results[0].formatted_address;
            });
          });
        }
        
      }
      
    });
    
  }
  
  
  function showSponsoredEventsOnMap(map){
    if( document.getElementById('sponsoredEvents') ){
      var sponsoredEvents = document.getElementById('sponsoredEvents').children[0].children;
      
      for(var e=0; e < sponsoredEvents.length; e++){
        var marker = new google.maps.Marker({
            map: map,
            position: new google.maps.LatLng(sponsoredEvents[e].children[1].innerHTML, sponsoredEvents[e].children[2].innerHTML),
            title: sponsoredEvents[e].children[0].innerHTML
            //icon: new google.maps.MarkerImage(
            //            '/assets/event_star.png', // my 16x48 sprite with 3 circular icons
            //            new google.maps.Size(25, 25), // desired size
            //            new google.maps.Point(0, 0), // offset within the scaled sprite
            //            new google.maps.Point(12.5,0), // anchor point is half of the desired size
            //            new google.maps.Size(25, 25) // scaled size of the entire sprite
            //             )
        });
        marker.image_url = sponsoredEvents[e].children[4].innerHTML;
        marker.e_address = sponsoredEvents[e].children[3].innerHTML;
        marker.e_id = sponsoredEvents[e].children[5].innerHTML;
        
        google.maps.event.addListener(marker, 'click', function(event){
          //marker.setAnimation(google.maps.Animation.BOUNCE);
          infoWindow.open( null );
          
          var infoWindowText = document.createElement("div");
          infoWindowText.className = 'infobox';
          infoWindowText.style.cssText = "width:350px; height:125px; border:1px solid grey; border-radius:23px; margin-top: 8px; background: white; padding: 10px";
          infoWindowOptions.content = infoWindowText;
          
          infoWindowOptions.pixelOffset =  new google.maps.Size(-140, 5);
          infoWindowOptions.closeBoxMargin = "20px -79px 2px 2px";
          
          infoWindow = new InfoBox(infoWindowOptions);
          
          infoWindowText.innerHTML = '<div onmouseover="document.getElementById(\'event_label_read\').style.display = document.getElementById(\'event_label_pdf\').style.display = \'inline\'" onmouseout="document.getElementById(\'event_label_read\').style.display = document.getElementById(\'event_label_pdf\').style.display = \'none\'">' + 
            '<h3>Empfohlene Versanstaltung: ' + this.title + '</h3><h4 id="event_label_read" style="display:none; cursor:pointer" onclick="window.location = \'http://\' + window.location.host + \'/events/\' + \'' + this.e_id + '\'">Weiterlesen?</h4>' + 
            '<h4 id="event_label_pdf" style="display:none; cursor:pointer" onclick="window.location = \'http://\' + window.location.host + \'/pdfEvent/\' + \'' + this.e_id + '\'"> | Als PDF anzeigen?</h4>';
            
          if(this.image_url.length)
            infoWindowText.innerHTML += '<img src="' + this.image_url + '" width="50" height="50" style="float:left; margin-top:8px" /><b>' + this.e_address + '</b></div>';
          else
            infoWindowText.innerHTML += '<b style="float:left; margin-top:8px">' + this.e_address + '</b></div>';
              
          infoWindow.setPosition( event.latLng );
          infoWindow.open( map );
        });
      }
      
    }
  }
  
};
