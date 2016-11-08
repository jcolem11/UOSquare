//
//  VenueFactory.swift
//  UOSquare
//
//  Created by Owner on 11/7/16.
//  Copyright © 2016 Owner. All rights reserved.
//

import UIKit

class Venue : NSObject{
    var id : String = ""
    var name :String = "???"
    var address : String = "???"
    var city : String = "???"
    var distance : String = "???"
    var iconURL : String = "???"
    var contact : String = "No contact information"
    var likes : String = "No Likes"
    var iconImage : UIImage = UIImage(named: "placeholder") ?? UIImage()
    var photo : UIImage = UIImage(named: "detailPlaceholder") ?? UIImage()
    
    
    convenience init(_ json:JSON) {
        self.init()
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.likes = "\(json["likes"].intValue) Likes"
        if let a = json["location"].dictionaryValue["address"]?.stringValue{
            self.address = a
        }
        if let c = json["location"].dictionaryValue["city"]?.stringValue{
            self.city = c
        }
        if let d = json["location"].dictionaryValue["distance"]?.intValue{
            self.distance = String(format:"%.2f", Double(d)/1609.34).appending(" miles away")
        }
        
        if let v = json["categories"].arrayValue.first?.dictionaryValue["icon"]?.dictionaryValue["prefix"]?.stringValue{
            self.iconURL = v
            updateIcon()
        }
        getPhoto()
    }
    
    func getPhoto(){
        APIManager.sharedInstance.getPhotoForVenue(self)
    }
    
    func updateIcon(){
        guard let url = URL(string:"\(self.iconURL)32.png") else {
            return
        }
        URLSession.shared.dataTask(with:url, completionHandler:{ (data, response, error) -> Void in
            if error != nil{
                print("ERROR Fetching icon:\(error) \n \(url)")
            }else{
                guard let d = data, let i = UIImage(data: d) else{
                    return
                }
                DispatchQueue.main.async {
                    self.iconImage = i.withRenderingMode(.alwaysTemplate)
                }
            }
        }).resume()
    }
}
