//
//  DataController.swift
//  KoleoTask
//
//  Created by rurza on 10/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import Foundation
import Cache

class DataController: NSObject, KoleoCacheDelegate {
    
    static let shared = DataController()
    var stations: [Station]?
    let koleoClient = KoleoClient.shared
    let cache = HybridCache(name: "KoleoClientCache", config: Config(
        expiry: .date(Date().addingTimeInterval(60*60*24)),
        memoryCountLimit: 0,
        memoryTotalCostLimit: 0,
        maxDiskSize: 5242880,
        cacheDirectory: NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                            FileManager.SearchPathDomainMask.userDomainMask,
                                                            true).first! + "/KoleoClient"))
    
    

    
    override init() {
        super.init()
        koleoClient.cacheDelegate = self
    }
    
    func downloadStations(handler: @escaping (Error?) -> Void) {
        koleoClient.getStations { (error, stations) in
            guard error == nil else {
                handler(error!)
                return
            }
            if stations != nil {
                self.stations = stations!
            }
            handler(nil)
        }
    }
    
    //MARK: KoleoCache
    func setObject(_ object: [Any], forKey key: String) {
        do {
            try cache.addObject(JSON.array(object), forKey: key)
        } catch {
            print("Can't save cache \(error)")
        }
    }
    
    func object(forKey key: String) -> JSON? {
        let object:JSON? = cache.object(forKey: key)
        return object
    }

    
}
