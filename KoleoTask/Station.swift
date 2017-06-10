//
//  Station.swift
//  KoleoTask
//
//  Created by rurza on 09/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import MapKit

class Station: NSObject, NSCoding {
    
    let longitude: CLLocationDegrees
    let latitude: CLLocationDegrees
    let name: String
    let id: Int
    
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
        id = jsonDict["id"] as! Int
        super.init()
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
        super.init()
    }
    
    func distanceBetween(_ station: Station) -> String {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let otherLocation = CLLocation(latitude: station.latitude, longitude: station.longitude)
        let distance = location.distance(from: otherLocation)
        let formatter = MKDistanceFormatter()
        return formatter.string(fromDistance: distance)
    }
    
    override var description: String {
        get {
            return "\(name), \(latitude):\(longitude)"
        }
    }

}
