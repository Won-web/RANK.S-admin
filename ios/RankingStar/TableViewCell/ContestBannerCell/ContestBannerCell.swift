//
//  SettingsListCell.swift
//  Plink
//
//  Created by eTech on 11/10/18.
//  Copyright © 2018 eTech. All rights reserved.
//

import UIKit

class ContestBannerCell: UITableViewCell {

    @IBOutlet weak var viewContDetails: UIView!
   
    @IBOutlet var viewContBannerDetails: UIView!
   
    @IBOutlet var imgBannerBG: UIImageView!
    @IBOutlet var lblBannerYear: UILabel!
    @IBOutlet var lblBannerSecondTitle: UILabel!
    @IBOutlet var lblBannerThirdTitle: UILabel!
    @IBOutlet var lblBannerFullDate: UILabel!
    

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
