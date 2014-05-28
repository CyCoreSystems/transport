@Stations = new Meteor.Collection 'stations'

refreshFromMARTA = ->
  res = HTTP.get "http://developer.itsmarta.com/RealtimeTrain/RestServiceNextTrain/GetRealtimeArrivals?apikey=#{share.api_key_MARTA}"
  if res.statusCode isnt 200
    return console.log "Failed to get realtime train information",res
  if not _.isArray res.data
    return console.log "Failed to get meaningful realtime train information",res	
  stations= []
  stations = _.uniq(_.pluck(res.data,'STATION'))
  stations.push("WESTLAKE STATION")
  stations.push("HIGHTOWER STATION")
  stations.sort()
  _.each stations,(i)->
    Stations.update {
      name: i
    },{ $set: { name: i, url: stationMap[i].url, displayName: stationMap[i].displayName }},{ upsert: true }

if Meteor.isServer
  # Periodically update the station list
  stationInterval = null
  Meteor.startup ->
    refreshFromMARTA()
    stationInterval = Meteor.setInterval refreshFromMARTA,60000

stationMap=
	"AIRPORT STATION":
		displayName: "Airport"
		url: "http://itsmarta.com/ns-air-overview.aspx"
	"ARTS CENTER STATION":
		displayName: "Arts Center"
		url: "http://itsmarta.com/ne-art-overview.aspx"
	"ASHBY STATION":
		displayName: "Ashby"
		url: "http://itsmarta.com/ew-ash-overview.aspx"
	"AVONDALE STATION":
		displayName: "Avondale"
		url: "http://itsmarta.com/ew-avo-overview.aspx"
	"BANKHEAD STATION":
		displayName: "Bankhead"
		url: "http://itsmarta.com/pc-ban-overview.aspx"
	"BROOKHAVEN STATION":
		displayName: "Brookhaven"
		url: "http://itsmarta.com/ne-bro-overview.aspx"
	"BUCKHEAD STATION":
		displayName: "Buckhead"
		url: "http://itsmarta.com/ns-buc-overview.aspx"
	"CHAMBLEE STATION":
		displayName: "Chamblee"
		url: "http://itsmarta.com/ne-cha-overview.aspx"
	"CIVIC CENTER STATION":
		displayName: "Civic Center"
		url: "http://itsmarta.com/ns-civ-overview.aspx"
	"COLLEGE PARK STATION":
		displayName: "College Park"
		url: "http://itsmarta.com/ns-col-overview.aspx"
	"DECATUR STATION":
		displayName: "Decatur"
		url: "http://itsmarta.com/ew-dec-overview.aspx"
	"DORAVILLE STATION":
		displayName: "Doraville"
		url: "http://itsmarta.com/ne-dor-overview.aspx"
	"DUNWOODY STATION":
		displayName: "Dunwoody"
		url: "http://itsmarta.com/ns-dun-overview.aspx"
	"EAST LAKE STATION":
		displayName: "East Lake"
		url: "http://itsmarta.com/ew-eas-overview.aspx"
	"EAST POINT STATION":
		displayName: "East Point"
		url: "http://itsmarta.com/ns-eas-overview.aspx"
	"EDGEWOOD CANDLER PARK STATION":
		displayName: "Edgewood/Candler Park"
		url: "http://itsmarta.com/ew-edg-overview.aspx"
	"FIVE POINTS STATION":
		displayName: "Five Points"
		url: "http://itsmarta.com/ns-fiv-overview.aspx"
	"GARNETT STATION":
		displayName: "Garnett"
		url: "http://itsmarta.com/ns-gar-overview.aspx"
	"GEORGIA STATE STATION":
		displayName: "Georgia State"
		url: "http://itsmarta.com/ew-geo-overview.aspx"
	"HIGHTOWER STATION":
		displayName: "H. E. Holmes"
		url: "http://itsmarta.com/ew-ham-overview.aspx"
	"INDIAN CREEK STATION":
		displayName: "Indian Creek"
		url: "http://itsmarta.com/ew-ind-overview.aspx"
	"INMAN PARK STATION":
		displayName: "Inman Park"
		url: "http://itsmarta.com/ew-inm-overview.aspx"
	"KENSINGTON STATION":
		displayName: "Kensington"
		url: "http://itsmarta.com/ew-ken-overview.aspx"
	"KING MEMORIAL STATION":
		displayName: "King Memorial"
		url: "http://itsmarta.com/ew-kin-overview.aspx"
	"LAKEWOOD STATION":
		displayName: "Lakewood"
		url: "http://itsmarta.com/ns-lak-overview.aspx"
	"LENOX STATION":
		displayName: "Lenox"
		url: "http://itsmarta.com/ne-len-overview.aspx"
	"LINDBERGH STATION":
		displayName: "Lindbergh"
		url: "http://itsmarta.com/ns-lin-overview.aspx"
	"MEDICAL CENTER STATION":
		displayName: "Medical Center"
		url: "http://itsmarta.com/ns-med-overview.aspx"
	"MIDTOWN STATION":
		displayName: "Midtown"
		url: "http://itsmarta.com/ns-mid-overview.aspx"
	"NORTH AVE STATION":
		displayName: "North Avenue"
		url: "http://itsmarta.com/ns-nor-overview.aspx"
	"NORTH SPRINGS STATION":
		displayName: "North Springs"
		url: "http://itsmarta.com/ns-nort-overview.aspx"
	"OAKLAND CITY STATION":
		displayName: "Oakland City"
		url: "http://itsmarta.com/ns-oak-overview.aspx"
	"OMNI DOME STATION":
		displayName: "Dome/GWCC/Phillips/CNN Center"
		url: "http://itsmarta.com/ew-omn-overview.aspx"
	"PEACHTREE CENTER STATION":
		displayName: "Peachtree Center"
		url: "http://itsmarta.com/ns-pea-overview.aspx"
	"SANDY SPRINGS STATION":
		displayName: "Sandy Springs"
		url: "http://itsmarta.com/ns-san-overview.aspx"
	"VINE CITY STATION":
		displayName: "Vine City"
		url: "http://itsmarta.com/ew-vin-overview.aspx"
	"WEST END STATION":
		displayName: "West End"
		url: "http://itsmarta.com/ns-wes-overview.aspx"
	"WESTLAKE STATION":
		displayName: "West Lake"
		url: "http://itsmarta.com/ew-wes-overview.aspx"
