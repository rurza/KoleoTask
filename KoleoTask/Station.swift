//
//  Station.swift
//  KoleoTask
//
//  Created by rurza on 09/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import MapKit

class Station: NSCoding, Equatable {
    
    @objc let longitude: CLLocationDegrees
    @objc let latitude: CLLocationDegrees
    @objc let name: String
    @objc let id: Int
    
    lazy var annotation: MKPointAnnotation = {
        let point = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude:self.longitude)
        point.coordinate = centerCoordinate
        point.title = self.name
        return point
    }()
    
    init?(jsonDict: [String:Any]) {
        guard let id = jsonDict["id"] as? Int,
            let longitude = jsonDict["longitude"] as? CLLocationDegrees,
            let latitude = jsonDict["latitude"] as? CLLocationDegrees,
            let name = jsonDict["name"] as? String else {
                return nil
        }
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.id = id
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(latitude, forKey: #keyPath(Station.latitude))
        aCoder.encode(longitude, forKey: #keyPath(Station.longitude))
        aCoder.encode(id, forKey: #keyPath(Station.id))
        aCoder.encode(name, forKey: #keyPath(Station.name))
    }
    
    public required init?(coder aDecoder: NSCoder){
        name = aDecoder.decodeObject(forKey: #keyPath(Station.name)) as! String
        latitude = aDecoder.decodeDouble(forKey: #keyPath(Station.latitude))
        longitude = aDecoder.decodeDouble(forKey: #keyPath(Station.longitude))
        id = aDecoder.decodeInteger(forKey: #keyPath(Station.id))
    }
    
    func distanceBetween(_ station: Station) -> String {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let otherLocation = CLLocation(latitude: station.latitude, longitude: station.longitude)
        let distance = location.distance(from: otherLocation)
        let formatter = MKDistanceFormatter()
        return formatter.string(fromDistance: distance)
    }
    
    
    var description: String {
        get {
            return "\(name), \(latitude):\(longitude)"
        }
    }
    
    public static func ==(lhs: Station, rhs: Station) -> Bool {
        return lhs.id == rhs.id
    }

}

