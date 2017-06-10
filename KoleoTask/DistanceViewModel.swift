//
//  DistanceViewModel.swift
//  KoleoTask
//
//  Created by rurza on 09/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import UIKit
import Cache

class DistanceViewModel: NSObject {
    
    var filteredStations: [Station]?
    let stations = (UIApplication.shared.delegate as! AppDelegate).dataController?.stations
    
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
    
    func numberOfFilteredStations() -> Int {
        return filteredStations?.count ?? 0
    }
    
    func station(forIndexPath indexPath: IndexPath) -> Station {
        return filteredStations![indexPath.row]
    }
    

}
