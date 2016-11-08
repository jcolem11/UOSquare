//
//  APIManager.swift
//  UOSquare
//
//  Created by Owner on 11/6/16.
//  Copyright © 2016 Owner. All rights reserved.
//

import UIKit
import CoreLocation

protocol APIManagerDelegate {
    func managerDidFetchVenueData(venues data:[Venue])
}

class APIManager: NSObject,CLLocationManagerDelegate {
    
    let baseURL : String = "https://api.foursquare.com/v2/"
    let clientID : String = "S1GZEFEHMYEJTVRFMVBWDCVITEH12S0DIHK1FRDEZMQKVW20"
    let clientSecret : String = "5T42UAKEL1BOIV3EH2OUNNOTCYWYASYKAM33DDXIFLDF1THA"
    var delegate : APIManagerDelegate?
    var locationManager = CLLocationManager()
    static let sharedInstance = APIManager()
    
    //MARK:CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // temp workaround for ignoring crashes
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // temp workaround for ignoring crashes
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            getVenuesNearLocation()
        }
    }
    
    //MARK:Class methods
    func requestUserLocationIfNeeded(){
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func getVenuesNearLocation(location:String?=nil){
        self.locationManager.delegate = self
        self.locationManager.requestLocation()
        var url:URL?
        if let l = location{
            let commaDelimtedString = l.replacingOccurrences(of: " ", with: ",")
            url = URL(string:"\(self.baseURL)venues/search?near=\(commaDelimtedString)&limit=10&client_id=\(clientID)&client_secret=\(clientSecret)&v=20161103&m=foursquare")
        }else if let l = self.locationManager.location{
            let latitude = String(format:"%.2f",l.coordinate.latitude)
            let longitude =  String(format:"%.2f",l.coordinate.longitude)
            url = URL(string:"\(self.baseURL)venues/search?ll=\(latitude),\(longitude)&client_id=\(clientID)&client_secret=\(clientSecret)&v=20161103&m=foursquare")
        }
        
        
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with:u, completionHandler:{ (data, response, error) -> Void in
            if error == nil{
                guard let d = data else{
                    return
                }
                let json = JSON(data: d)
                DispatchQueue.main.async {
                    let venues = self.getVenueObjectsFromJSON(json)
                    self.delegate?.managerDidFetchVenueData(venues: venues)
                }
            }else{
                //handle
            }
        }).resume()
    }
    
    func getPhotoForVenue(_ venue: Venue){
        guard let url = URL(string:"\(self.baseURL)/venues/\(venue.id)/photos?&limit=1&client_id=\(clientID)&client_secret=\(clientSecret)&v=20161103&m=foursquare") else{
            return
        }
        URLSession.shared.dataTask(with:url, completionHandler:{ (data, response, error) -> Void in
            if error != nil{
                //handle
            }else{
                if let d = data, let json =  JSON(data: d)["response"].dictionaryValue["photos"]?.dictionaryValue["items"]?.arrayValue.first
                {
                    let prefix = json["prefix"].stringValue
                    let suffix = json["suffix"].stringValue
                    let photoURL = "\(prefix)150x150\(suffix)"
                    self.photo(photoURL, forVenue: venue)
                }
            }
        }).resume()
    }
    
    func photo(_ url:String, forVenue venue:Venue){
        guard let u = URL(string: url) else{
            return
        }
        URLSession.shared.dataTask(with:u, completionHandler:{ (data, response, error) -> Void in
            if error != nil{
                //handle
            }else{
                if let d = data, let i = UIImage(data:d){
                    DispatchQueue.main.async {
                        venue.photo = i
                    }
                }
            }
        }).resume()
    }
    
    
    func getVenueObjectsFromJSON(_ json:JSON) -> [Venue]{
        let venues = json["response"]["venues"].arrayValue.map{
            Venue($0)
        }
        return venues
    }
}

