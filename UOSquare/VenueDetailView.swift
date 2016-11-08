 //
//  VenueDetailView.swift
//  UOSquare
//
//  Created by Owner on 11/6/16.
//  Copyright © 2016 Owner. All rights reserved.
//

import UIKit

class VenueDetailView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    var venue : Venue?{
        didSet{
            self.headerLabel.text = venue!.name
            self.imageView.image = venue!.photo
            self.addressLabel.text = venue!.address
            self.cityLabel.text = venue!.city
            self.contactLabel.text = venue!.contact
            self.likesLabel.text = String(venue!.likes)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 5.0
        self.likesLabel.backgroundColor = UIColor.BetterRed
        self.likesLabel.textColor = UIColor.white
        self.headerLabel.backgroundColor = UIColor.FourSquareBlue
    }
}
