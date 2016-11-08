//
//  VenueDetailViewController.swift
//  UOSquare
//
//  Created by Owner on 11/6/16.
//  Copyright © 2016 Owner. All rights reserved.
//

import UIKit

class VenueDetailViewController: UIViewController {

    convenience init(venue:Venue){
        self.init()
        if let v = self.view as? VenueDetailView{
            v.venue = venue
        }
    }

    @IBAction func buttonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
