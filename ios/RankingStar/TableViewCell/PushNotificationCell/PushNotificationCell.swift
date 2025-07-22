//
//  SettingsListCell.swift
//  Plink
//
//  Created by eTech on 11/10/18.
//  Copyright © 2018 eTech. All rights reserved.
//

import UIKit

class PushNotificationCell: UITableViewCell {

    @IBOutlet weak var viewContDetails: UIView!
    
    @IBOutlet weak var lblMsgTitle: UILabel!
    @IBOutlet weak var lblMsgDate: UILabel!
    @IBOutlet weak var lblMsgDetails: UILabel!
   
    @IBOutlet weak var imgNext: UIImageView!
    

    //MARK: table view cell method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
