//
//  Details.swift
//  MeridianLokacije
//
//  Created by Nikola Sabelnik on 11/15/17.
//  Copyright © 2017 SabelnikN. All rights reserved.
//

import Foundation
import MapKit


class Details: NSObject, MKAnnotation {
    
    
    let phone: String
    let workHours: Bool?
    let address: String?
    let coordinate: CLLocationCoordinate2D

    
    init(phone: String, workHours: Bool, address: String, coordinate: CLLocationCoordinate2D) {
        
        self.phone = phone
        self.workHours = workHours
        self.address = address
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return phone
    }
    
    var title: String? {
        return address
    }

    
    
}
