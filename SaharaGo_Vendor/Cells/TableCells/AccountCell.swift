//
//  AccountCell.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 02/01/23.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var cellMenuBtn: UIButton!
    @IBOutlet weak var cellDefaultImg: UIImageView!
    @IBOutlet weak var cellBankCodeLbl: UILabel!
    @IBOutlet weak var cellAccountNumberLbl: UILabel!
    @IBOutlet weak var cellAccountNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
