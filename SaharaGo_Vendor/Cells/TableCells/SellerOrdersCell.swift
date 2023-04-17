//
//  SellerOrdersCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 13/10/22.
//

import UIKit

class SellerOrdersCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemCurrencyPriceQquantityLbl: UILabel!
//    @IBOutlet weak var itemTotalPriceLbl: UILabel!
//    @IBOutlet weak var itemQquantitLbl: UILabel!
    @IBOutlet weak var itemCreatedOnDateLbl: UILabel!
    
    @IBOutlet weak var orderStatusLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    
    @IBOutlet weak var itemOrderByNameLbl: UILabel!
    @IBOutlet weak var itemOrderByProfileImg: UIImageView!
    
    @IBOutlet weak var detailButton: UIButton!
    
    @IBOutlet weak var threeDotsButton: UIButton!

    @IBOutlet weak var orderByImgNameBackView: UIView!
    
    @IBOutlet weak var mainBackView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
