//
//  NotificationsCell.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 24/02/23.
//

import UIKit

class NotificationsCell: UITableViewCell {

    @IBOutlet weak var cellDateLbl: UILabel!
    @IBOutlet weak var cellSubLbl: UILabel!
    @IBOutlet weak var cellMainLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
