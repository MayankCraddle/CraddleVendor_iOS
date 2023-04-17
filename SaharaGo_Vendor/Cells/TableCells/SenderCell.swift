//
//  SenderCell.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 18/10/22.
//

import UIKit

class SenderCell: UITableViewCell {
    
    var message: Message?{
        didSet{
            
            guard let message = self.message else { return }
            if message.timestamp != nil {
            let timeStamp = Date(timeIntervalSince1970: TimeInterval(message.timestamp!)! / 1000)
            self.lblTime.text = timeStamp.convertTimeInterval()
            self.lblDate.text = timeStamp.convertTimeInterval(format: "MMM d, yyyy")
            }
            self.lblMessage.text = message.content
            
        }
    }

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        messageView.roundRadius(options: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], cornerRadius: 30)
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        messageView.roundCorners(corners: [.topLeft, .topRight, .bottomRight], cornerRadius: 30)
    }

}
