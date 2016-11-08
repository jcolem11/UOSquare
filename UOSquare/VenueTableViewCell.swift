//
//  VenueTableViewCell.swift
//  UOSquare
//
//  Created by Owner on 11/6/16.
//  Copyright © 2016 Owner. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var venue : Venue?{
        didSet{
            self.titleLabel.text = venue!.name
            self.descriptionLabel.text = venue!.address
            self.distanceLabel.text = venue!.distance
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.textColor = UIColor.black
        self.descriptionLabel.textColor = UIColor.darkGray
        self.distanceLabel.textColor = UIColor.darkGray
        self.imageView?.tintColor = UIColor.FourSquareBlue
    }

}
