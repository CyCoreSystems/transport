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
    },{ $set: { name: i, url: stationURLmap[i], displayName: stationNameMap[i], position: stationPosMap[i] }},{ upsert: true }

if Meteor.isServer
  # Periodically update the station list
  stationInterval = null
  Meteor.startup ->
    refreshFromMARTA()
    stationInterval = Meteor.setInterval refreshFromMARTA,60000

stationPosMap =
	"AIRPORT STATION": 23
	"ARTS CENTER STATION": 11
	"ASHBY STATION": 27
	"AVONDALE STATION": 36
	"BANKHEAD STATION": 25
	"BROOKHAVEN STATION": 6
	"BUCKHEAD STATION": 9
	"CHAMBLEE STATION": 4
	"CIVIC CENTER STATION": 14
	"COLLEGE PARK STATION": 22
	"DECATUR STATION": 35
	"DORAVILLE STATION": 2
	"DUNWOODY STATION": 5
	"EAST LAKE STATION": 34
	"EAST POINT STATION": 21
	"EDGEWOOD CANDLER PARK STATION": 33
	"FIVE POINTS STATION": 16
	"GARNETT STATION": 17
	"GEORGIA STATE STATION": 30
	"HIGHTOWER STATION": 24
	"INDIAN CREEK STATION": 38
	"INMAN PARK STATION": 32
	"KENSINGTON STATION": 37
	"KING MEMORIAL STATION": 31
	"LAKEWOOD STATION": 20
	"LENOX STATION": 8
	"LINDBERGH STATION": 10
	"MEDICAL CENTER STATION": 7
	"MIDTOWN STATION": 12
	"NORTH AVE STATION": 13
	"NORTH SPRINGS STATION": 1
	"OAKLAND CITY STATION": 19
	"OMNI DOME STATION": 29
	"PEACHTREE CENTER STATION": 15
	"SANDY SPRINGS STATION": 3
	"VINE CITY STATION": 28
	"WEST END STATION": 18
	"WESTLAKE STATION": 26

stationNameMap =
	"AIRPORT STATION": "Airport"
	"ARTS CENTER STATION": "Arts Center"
	"ASHBY STATION": "Ashby"
	"AVONDALE STATION": "Avondale"
	"BANKHEAD STATION": "Bankhead"
	"BROOKHAVEN STATION": "Brookhaven"
	"BUCKHEAD STATION": "Buckhead"
	"CHAMBLEE STATION": "Chamblee"
	"CIVIC CENTER STATION": "Civic Center"
	"COLLEGE PARK STATION": "College Park"
	"DECATUR STATION": "Decatur"
	"DORAVILLE STATION": "Doraville"
	"DUNWOODY STATION": "Dunwoody"
	"EAST LAKE STATION": "East Lake"
	"EAST POINT STATION": "East Point"
	"EDGEWOOD CANDLER PARK STATION": "Edgewood/Candler Park"
	"FIVE POINTS STATION": "Five Points"
	"GARNETT STATION": "Garnett"
	"GEORGIA STATE STATION": "Georgia State University"
	"HIGHTOWER STATION": "Hamilton Holmes"
	"INDIAN CREEK STATION": "Indian Creek"
	"INMAN PARK STATION": "Inman Park"
	"KENSINGTON STATION": "Kensington"
	"KING MEMORIAL STATION": "King Memorial"
	"LAKEWOOD STATION": "Lakewood"
	"LENOX STATION": "Lenox"
	"LINDBERGH STATION": "Lindbergh"
	"MEDICAL CENTER STATION": "Medical Center"
	"MIDTOWN STATION": "Midtown"
	"NORTH AVE STATION": "North Avenue"
	"NORTH SPRINGS STATION": "North Springs"
	"OAKLAND CITY STATION": "Oakland City"
	"OMNI DOME STATION": "Dome/GWCC/Phillips/CNN"
	"PEACHTREE CENTER STATION": "Peachtree Center"
	"SANDY SPRINGS STATION": "Sandy Springs"
	"VINE CITY STATION": "Vine City"
	"WEST END STATION": "West End"
	"WESTLAKE STATION": "West Lake"

stationURLmap =
	"AIRPORT STATION": "http://itsmarta.com/ns-air-overview.aspx"
	"ARTS CENTER STATION": "http://itsmarta.com/ne-art-overview.aspx"
	"ASHBY STATION": "http://itsmarta.com/ew-ash-overview.aspx"
	"AVONDALE STATION": "http://itsmarta.com/ew-avo-overview.aspx"
	"BANKHEAD STATION": "http://itsmarta.com/pc-ban-overview.aspx"
	"BROOKHAVEN STATION": "http://itsmarta.com/ne-bro-overview.aspx"
	"BUCKHEAD STATION": "http://itsmarta.com/ns-buc-overview.aspx"
	"CHAMBLEE STATION": "http://itsmarta.com/ne-cha-overview.aspx"
	"CIVIC CENTER STATION": "http://itsmarta.com/ns-civ-overview.aspx"
	"COLLEGE PARK STATION": "http://itsmarta.com/ns-col-overview.aspx"
	"DECATUR STATION": "http://itsmarta.com/ew-dec-overview.aspx"
	"DORAVILLE STATION": "http://itsmarta.com/ne-dor-overview.aspx"
	"DUNWOODY STATION": "http://itsmarta.com/ns-dun-overview.aspx"
	"EAST LAKE STATION": "http://itsmarta.com/ew-eas-overview.aspx"
	"EAST POINT STATION": "http://itsmarta.com/ns-eas-overview.aspx"
	"EDGEWOOD CANDLER PARK STATION": "http://itsmarta.com/ew-edg-overview.aspx"
	"FIVE POINTS STATION": "http://itsmarta.com/ns-fiv-overview.aspx"
	"GARNETT STATION": "http://itsmarta.com/ns-gar-overview.aspx"
	"GEORGIA STATE STATION": "http://itsmarta.com/ew-geo-overview.aspx"
	"HIGHTOWER STATION": "http://itsmarta.com/ew-ham-overview.aspx"
	"INDIAN CREEK STATION": "http://itsmarta.com/ew-ind-overview.aspx"
	"INMAN PARK STATION": "http://itsmarta.com/ew-inm-overview.aspx"
	"KENSINGTON STATION": "http://itsmarta.com/ew-ken-overview.aspx"
	"KING MEMORIAL STATION": "http://itsmarta.com/ew-kin-overview.aspx"
	"LAKEWOOD STATION": "http://itsmarta.com/ns-lak-overview.aspx"
	"LENOX STATION": "http://itsmarta.com/ne-len-overview.aspx"
	"LINDBERGH STATION": "http://itsmarta.com/ns-lin-overview.aspx"
	"MEDICAL CENTER STATION": "http://itsmarta.com/ns-med-overview.aspx"
	"MIDTOWN STATION": "http://itsmarta.com/ns-mid-overview.aspx"
	"NORTH AVE STATION": "http://itsmarta.com/ns-nor-overview.aspx"
	"NORTH SPRINGS STATION": "http://itsmarta.com/ns-nort-overview.aspx"
	"OAKLAND CITY STATION": "http://itsmarta.com/ns-oak-overview.aspx"
	"OMNI DOME STATION": "http://itsmarta.com/ew-omn-overview.aspx"
	"PEACHTREE CENTER STATION": "http://itsmarta.com/ns-pea-overview.aspx"
	"SANDY SPRINGS STATION": "http://itsmarta.com/ns-san-overview.aspx"
	"VINE CITY STATION": "http://itsmarta.com/ew-vin-overview.aspx"
	"WEST END STATION": "http://itsmarta.com/ns-wes-overview.aspx"
	"WESTLAKE STATION": "http://itsmarta.com/ew-wes-overview.aspx"
