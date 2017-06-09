//
//  DistanceViewModel.swift
//  KoleoTask
//
//  Created by rurza on 09/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import UIKit

class DistanceViewModel: NSObject {
    
    var filteredStations: [Station]?
    let stations: [Station]?
    
    
    init(handler: (Error?)) {
        stations = nil
        super.init()
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

}
