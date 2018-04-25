//
//  Constants.swift
//  MeridianLokacije
//
//  Created by Nikola Sabelnik on 11/7/17.
//  Copyright © 2017 SabelnikN. All rights reserved.
//

import Foundation
import MapKit

var inSearch = false 

var latitudePosition: Double?
var longitudePosition: Double?

var place: Place!
var place2: Place!
var place3: Place!
var place4: Place!
var places = [Place]()
var setOfPlaces = Set<String>()
var uniquePlaces = [Place]()


var detail: Details!
var details = [Details]()
var filteredDetails = [Details]()




typealias DownloadComplete = () -> ()

//////////// TEXT SEARCH ///////////////


let textSearchBaseURL = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
let textSearchQuery = "query=meridianbet"
let textSearchLocation = "&location=\(longitudePosition!),\(latitudePosition!)"
let textSearchRadius = "&radius=5000"
let textSearchKey = "&key="
let textSearchAPIKey = "AIzaSyAN-mwwzUHlgVivBV0mCEhzBri6GbvCL3E"

let textSearchURL = "\(textSearchBaseURL)\(textSearchQuery)\(textSearchLocation)\(textSearchRadius)\(textSearchKey)\(textSearchAPIKey)"

//////////////// NEARBY SEARCH//////////////////
let nearbyBaseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
let nearbyLocation = "location=44.7866,20.4489"
let nearbyRadius = "&radius=10000"
let type = "&type="
let keyword = "&keyword="
let APIKey = "&key="
let nearbySearchAPIKey = "AIzaSyBxze40kuQ1mBdrgKBnOzrYpquXOj1yHzc"


let nearbyURL = "\(nearbyBaseURL)\(nearbyLocation)\(nearbyRadius)\(keyword)kladionica+meridian\(APIKey)\(nearbySearchAPIKey)"

let nearbyURL3 = "\(nearbyBaseURL)\(nearbyLocation)\(nearbyRadius)\(keyword)meridian\(APIKey)\(nearbySearchAPIKey)"

let nearbyURL4 = "\(nearbyBaseURL)\(nearbyLocation)\(nearbyRadius)\(keyword)meridianbet\(APIKey)\(nearbySearchAPIKey)"

let nearbyURL2 = "\(nearbyBaseURL)\(nearbyLocation)\(nearbyRadius)\(keyword)kladionica+meridianbet\(APIKey)\(nearbySearchAPIKey)"

//////////////// DETAILS SEARCH ////////////////

let detailsBaseURL = "https://maps.googleapis.com/maps/api/place/details/json?"
let detailsPlaceId = "placeid="
let placeID = place.placeId
let detailsKey = "&key="
let detailsSearchAPIKey = "AIzaSyDDsJbjFzlalnlF-3jo-v6lMgAY94pii54"

//let detailsURL = "\(detailsBaseURL)\(detailsPlaceId)\(String(describing: placeID))\(detailsKey)\(detailsSearchAPIKey)"




