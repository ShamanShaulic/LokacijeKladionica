//
//  Place.swift
//  MeridianLokacije
//
//  Created by Nikola Sabelnik on 11/8/17.
//  Copyright © 2017 SabelnikN. All rights reserved.
//

import Foundation
import Alamofire
import MapKit


class Place {
    
   
    var placeId: String?
    var vicinity: String?

    
    init(placeId: String, vicinity: String) {
        
        self.placeId = placeId
        self.vicinity = vicinity
        
    }
}

