//
//  ViewController.swift
//  UOSquare
//
//  Created by Owner on 11/6/16.
//  Copyright © 2016 Owner. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, APIManagerDelegate,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBAR: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var venues : [Venue] = [Venue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIManager.sharedInstance.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBAR.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||  CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            APIManager.sharedInstance.getVenuesNearLocation()
        }else{
            APIManager.sharedInstance.requestUserLocationIfNeeded()
        }
        // look and feel
        self.searchBAR.barTintColor = UIColor.AttractiveLightGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.FourSquareBlue
        self.navigationController?.navigationBar.isTranslucent = false
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.black]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
    }
    

    //MARK:UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venues.count
    }
    
    //MARK:UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? VenueTableViewCell else{
            return UITableViewCell()
        }
        let venue = self.venues[indexPath.row]
        cell.iconView.image = venue.iconImage
        cell.venue = venue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let venue = self.venues[indexPath.row]
        let detailViewController = VenueDetailViewController(venue: venue)
        detailViewController.modalPresentationStyle = .overFullScreen
        present(detailViewController, animated: true, completion:nil)
    }
    
    //MARK:APIMangerDelegate
    func managerDidFetchVenueData(venues data: [Venue]) {
        self.venues = data
        self.tableView.reloadData()
    }
    
    //MARK:UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else{
            return
        }
        APIManager.sharedInstance.getVenuesNearLocation(location: text)
        searchBar.placeholder = text
        searchBar.resignFirstResponder()
    }
    
}

