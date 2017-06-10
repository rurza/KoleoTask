//
//  DistanceViewModel.swift
//  KoleoTask
//
//  Created by rurza on 09/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import UIKit

class DistanceViewModel: NSObject, KoleoCache {
    
    var filteredStations: [Station]?
    let stations: [Station]?
    let koleoClient = KoleoClient.shared
    
    init(handler: (Error?)) {
        stations = nil
        super.init()
        koleoClient.cacheDelegate = self
    }
    
    func filterStations(phrase: String, handler: os_block_t) {
        if phrase.characters.count > 0 {
            filteredStations = stations?.filter({ (station) -> Bool in
                if station.name.localizedCaseInsensitiveContains(phrase) {
                    return true
                }
                return false
            })
            handler()
        }
    }
    
    func downloadResults(handler: (Error?)) {
        
    }
    
    //MARK: KoleoCache
    func setObject(_ object: Any, forKey key: String) {

    }
    
    func object(forKey key: String) -> Any? {
        
    }

}
