//
//  DistanceViewModel.swift
//  KoleoTask
//
//  Created by rurza on 09/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import UIKit
import Cache
import MapKit

enum StationPoint {
    case from
    case to
}

class DistanceViewModel: NSObject {
    
    var filteredStations: [Station]?
    let stations = DataController.shared.stations
    var chosenStations:(fromStation: Station?, toStation: Station?) = (nil, nil)
    
    func filterStations(phrase: String, handler: (Int) -> Void) {
        if phrase.characters.count > 0 {
            filteredStations = stations?.filter({ (station) -> Bool in
                let range = station.name.range(of: phrase, options: [.caseInsensitive, .diacriticInsensitive], range: station.name.startIndex..<station.name.endIndex, locale: Locale.current)
                if range != nil {
                    return true
                }
                return false

            })
            handler(filteredStations?.count ?? 0)
        } else {
            handler(0)
        }
    }
    
    func numberOfFilteredStations() -> Int {
        return filteredStations?.count ?? 0
    }
    
    func stationName(forIndexPath indexPath: IndexPath) -> String {
        return filteredStations![indexPath.row].name
    }
    
    func addStation(atIndexPath indexPath: IndexPath, withPoint point: StationPoint) -> (toDelete: MKPointAnnotation?, toAdd: MKPointAnnotation) {
        var stationToDelete: Station? = nil
        let stationToAdd: Station = filteredStations![indexPath.row]
        switch point {
        case .from:
            if let existingStation = chosenStations.fromStation {
                stationToDelete = existingStation
            }
            chosenStations.fromStation = stationToAdd
        case .to:
            if let existingStation = chosenStations.toStation {
                stationToDelete = existingStation
            }
            chosenStations.toStation = stationToAdd
        }
        return (stationToDelete?.annotation, stationToAdd.annotation)
    }

    func distanceString() -> String? {
        if bothStations() {
            let distance = chosenStations.fromStation!.distanceBetween(chosenStations.toStation!)
            return distance
        } else {
            return nil
        }
    }
    
    func bothStations() -> Bool {
        if chosenStations.fromStation != nil && chosenStations.toStation != nil {
            return true
        }
        return false
    }
    
}
