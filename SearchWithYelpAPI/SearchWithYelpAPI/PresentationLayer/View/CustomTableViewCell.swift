//
//  CustomTableViewCell.swift
//  SearchWithYelpAPI
//
//  Created by Krishna  on 8/13/19.
//  Copyright © 2019 Krishna . All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var totalReviewsCount: UILabel!
    @IBOutlet weak var avgReviewsLbl: UILabel!
    
    @IBOutlet weak var ratingView: CircularRating!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with business: Business?) {
        
        if let business = business {
             self.titleLbl.text = business.name
             let location = business.location
            if let address = location.displayAddress{
                self.addressLbl.text = address.joined(separator: ", ")
            }
            self.totalReviewsCount.text = "\(business.reviewCount ?? 0) Reviews"
            self.ratingView.value = business.rating ?? 0
            self.avgReviewsLbl.text = "\(business.rating ?? 0 )"
        }
       
        
    }
    
    
}
