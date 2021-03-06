//
//  KoleoClient.swift
//  KoleoTask
//
//  Created by rurza on 09/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import Foundation
import Cache

enum HTTPMethod: String {
    case GET
}

enum KoleoClientError: Error {
    case undefinedError
    case wrongJSONFormat
}

protocol KoleoCacheDelegate {
    func object(forKey key: String) -> JSON?
    func setObject(_ object: [Any], forKey key: String)
}

class KoleoClient {
    
    static let shared = KoleoClient()
    let session = URLSession(configuration: URLSessionConfiguration.default)
    var cacheDelegate: KoleoCacheDelegate? = nil
    
    let mainURLString = "https://koleo.pl/api/android/v1"
    let stationsEndpoint = "/stations.json"
    
    //MARK: PUBLIC
    func getStations(handler: @escaping (Error?, [Station]?) -> Void) {
        let url = URL(string: "\(mainURLString)\(stationsEndpoint)")
        assert(url != nil)
        performApiCall(httpMethod: .GET, url: url!, headers: nil, body: nil) { (error, json) in
            guard error == nil else {
                handler(error!, nil)
                return
            }
            if json! is Array<[String: Any]> {
                var stations = Array<Station>()
                for dict in json as! Array<[String: Any]> {
                    if let station = Station(jsonDict: dict) {
                        stations.append(station)
                    }
                }
                stations.sort { return $0.name < $1.name }
                handler(nil, stations)
            } else {
                handler(KoleoClientError.wrongJSONFormat, nil)
            }
        }
    }
    
    
    //MARK: PRIVATE
    fileprivate func performApiCall(httpMethod: HTTPMethod, url: URL, headers:[String:String]?, body:Data?, handler:@escaping (Error?, [Any]?) -> Void) {
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        request.httpMethod = httpMethod.rawValue
        
        session.dataTask(with: request) { (responseData, urlResponse, error) in
            guard error == nil else {
                if let cache = self.cacheDelegate {
                    if let cachedObject = cache.object(forKey: url.absoluteString) {
                        DispatchQueue.main.async { handler(nil, cachedObject.object as? [Any]) }
                        return
                    }
                }
                DispatchQueue.main.async { handler(error!, nil) }
                return
            }
            
            if let data = responseData {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if json is Array<Any> {
                        let jsonArray = json as! Array<Any>
                        if let cache = self.cacheDelegate {
                            cache.setObject(jsonArray, forKey: url.absoluteString)
                        }
                        DispatchQueue.main.async { handler(nil, jsonArray) }
                    } else {
                        DispatchQueue.main.async { handler(KoleoClientError.wrongJSONFormat, nil) }
                    }
                } catch {
                    DispatchQueue.main.async { handler(error, nil) }
                }
            } else {
                DispatchQueue.main.async { handler(KoleoClientError.undefinedError, nil) }
            }
        }.resume()
    }
    
    
}
