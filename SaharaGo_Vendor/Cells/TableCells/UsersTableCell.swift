//
//  UsersTableCell.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 20/10/22.
//

import UIKit

class UsersTableCell: UITableViewCell {

    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var cellMsgLbl: UILabel!
    @IBOutlet weak var userProfilePicImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
