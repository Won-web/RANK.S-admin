//
//  SettingsListCell.swift
//  Plink
//
//  Created by eTech on 11/10/18.
//  Copyright © 2018 eTech. All rights reserved.
//

import UIKit

class EditProfileSubMsgCell: UITableViewCell {

    @IBOutlet weak var viewContDetails: UIView!
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var imgLikeDislike: UIImageView!
    
    @IBOutlet var lblLikeCount: UILabel!
    
    @IBOutlet var lblMsg: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblReplay: UILabel!
    @IBOutlet var lblViewAll: UILabel!
    @IBOutlet var viewContLikeDislike: UIView!
    
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
