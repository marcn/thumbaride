Markers = new Mongo.Collection('markers');

var contentString = '<div id="content">'+
      '<div id="siteNotice">'+
      '</div>'+
      '<h1 id="firstHeading" class="firstHeading">Uluru</h1>'+
      '<div id="bodyContent">'+
      '<p><b>Uluru</b>, also referred to as <b>Ayers Rock</b>, is a large ' +
      'sandstone rock formation in the southern part of the '+
      'Northern Territory, central Australia. It lies 335&#160;km (208&#160;mi) '+
      'south west of the nearest large town, Alice Springs; 450&#160;km '+
      '(280&#160;mi) by road. Kata Tjuta and Uluru are the two major '+
      'features of the Uluru - Kata Tjuta National Park. Uluru is '+
      'sacred to the Pitjantjatjara and Yankunytjatjara, the '+
      'Aboriginal people of the area. It has many springs, waterholes, '+
      'rock caves and ancient paintings. Uluru is listed as a World '+
      'Heritage Site.</p>'+
      '<p>Attribution: Uluru, <a href="https://en.wikipedia.org/w/index.php?title=Uluru&oldid=297882194">'+
      'https://en.wikipedia.org/w/index.php?title=Uluru</a> '+
      '(last visited June 22, 2009).</p>'+
      '</div>'+
      '</div>';


if (Meteor.isClient) {
  Template.map.onCreated(function() {
    GoogleMaps.ready('map', function(map) { 
      var markers = {};

      Markers.find().observe({
        added: function (document) {
          var marker = new google.maps.Marker({
            animation: google.maps.Animation.DROP,
            position: new google.maps.LatLng(document.lat, document.lng),
            map: map.instance,
            id: document._id, 
            title:'yo'
            //icon: iconBase + 'schools_maps.png'
          });


          var infowindow = new google.maps.InfoWindow({
            content: contentString,
            maxWidth: 200
          });

          marker.addListener('click', function() {
            infowindow.open(map.instance, marker);
          });

          markers[document._id] = marker;
        },
        changed: function (newDocument, oldDocument) {
          markers[newDocument._id].setPosition({ lat: newDocument.lat, lng: newDocument.lng });
        },
        removed: function (oldDocument) {
          markers[oldDocument._id].setMap(null);
          google.maps.event.clearInstanceListeners(markers[oldDocument._id]);
          delete markers[oldDocument._id];
        }
      });
    });
  });

  Meteor.startup(function() {
    GoogleMaps.load();
  });

  Template.map.helpers({
    mapOptions: function() {
      if (GoogleMaps.loaded()) {
        return {
          center: new google.maps.LatLng(37.8103920,-122.2659000),
          zoom: 8
        };
      }
    }
  });

  Template.hello.helpers({
       counter: function () {
         return Session.get('counter');
       },
       profile_pic: function() {
               if (Meteor.user() != null) {
                       return "http://graph.facebook.com/v2.2/" + Meteor.user().services.facebook.id + "/picture";
               } else {
                       return "http://www.pandora.com/img/no_photo_180.png";
               }
       }
     });

}


if (Meteor.isServer) {
  Meteor.methods({
  "mobileLogin" : function(args) {
    var new_user = args[0];

    var user = db.users.find({ 
    "services" : {
      "facebook" : {
      "id" : new_user["id"]
      }
    }
    });

    if ( user == null) {
    var user_id = Users.insert({
      "profile" : {
      "name" : new_user["name"]
      }, "services" : {
      "facebook" : {
        "accessToken" : new_user[""],
        "email" : new_user["email"],
        "first_name" : new_user["first_name"],
        "last_name" : new_user["last_name"],
        "id" : new_user["id"],
        "name" : new_user["name"],
      }
      }
    }); 
    }

    return {"method" : "login", "data" : {"userId" : user_id}};
  }
  });
}
