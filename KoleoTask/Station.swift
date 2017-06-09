//
//  Station.swift
//  KoleoTask
//
//  Created by rurza on 09/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import MapKit

class Station: NSObject {
    
    let longitude: CLLocationDegrees
    let latitude: CLLocationDegrees
    let name: String
    
    lazy var annotation: MKPointAnnotation = {
        let point = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude:self.longitude)
        point.coordinate = centerCoordinate
        point.title = self.name
        return point
    }()
    
    init(jsonDict: [String:Any]) {
        longitude = jsonDict["longitudea"] as! CLLocationDegrees
        latitude = jsonDict["latitude"] as! CLLocationDegrees
        name = jsonDict["name"] as! String
        super.init()
    }

}
