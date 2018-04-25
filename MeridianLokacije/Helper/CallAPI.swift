//
//  CallAPI.swift
//  MeridianLokacije
//
//  Created by Nikola Sabelnik on 11/15/17.
//  Copyright © 2017 SabelnikN. All rights reserved.
//

import Foundation
import Alamofire
import MapKit


class CallAPI {
    
    static func downloadPlaceID (completed: @escaping DownloadComplete) {
        
        let placeURL = URL(string: nearbyURL)
        
        Alamofire.request(placeURL!).responseJSON { (response) in
            let result = response.result
            
            if let dictionary = result.value as? [String:Any] {
                if let results = dictionary["results"] as? [[String:Any]] {
                    
                    if let status = dictionary["status"] as? String  {
                        if status == "OK" {
                            
                            for i in 0...results.count - 1 {
                            
                        let placeId = results[i]["place_id"] as? String
                            
                        let vicinity = results[i]["vicinity"] as? String
                            
                        place = Place(placeId: placeId!, vicinity: vicinity!)
                        places.append(place)
                        }
                        } else {
                            print("jede govna")
                        }
                    }
                }
            }
           completed()
        }
    }

    
    static func downloadDetails(input: String, completed: @escaping DownloadComplete) {
        
        let detailsURL = "\(detailsBaseURL)\(detailsPlaceId)\(input)\(detailsKey)\(detailsSearchAPIKey)"
        
        Alamofire.request(detailsURL).responseJSON { response in
            let result = response.result
            
            
            if let dictionary = result.value as? [String:Any] {
                
                if let result = dictionary["result"] as? [String:Any] {
                    
                    var phone = ""
                    
                    if let phoneNumber = result["formatted_phone_number"] as? String {
                        phone = phoneNumber
                    }
                    
                    var lat = 0.0
                    var lng = 0.0
                    var coordinate = CLLocationCoordinate2DMake(0.0, 0.0)
                    
                    if let  geometry = result["geometry"] as? [String:Any] {
                        if let location = geometry["location"] as? [String:Any] {
                            
                            
                            if let latitude = location["lat"] as? Double {
                                lat = latitude
                            }
                            if let longitude = location["lng"] as? Double {
                                lng = longitude
                            }
                            
                          coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            
                        }
                    }
                    
                    var workHours = false
                    
                    if let openingHours = result["opening_hours"] as? [String:Any] {
                        if let openNow = openingHours["open_now"] as? Bool {
                            workHours = openNow
                        }
                    }
                    
                    var address = ""
                    
                    if let addressComponents = result["address_components"] as? [[String:Any]] {
                        let longName = addressComponents[1]["long_name"] as? String
                        let shortName = addressComponents[0]["long_name"] as? String
                        
                        address = "\(longName!),\(shortName!)"
                    }
                    
                    detail = Details(phone: phone, workHours: workHours, address: address, coordinate: coordinate)
                    
                    details.append(detail)
                    
                }
            }
          completed()
        }
    }
}
