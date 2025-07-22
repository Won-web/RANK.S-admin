//
//  SettingsListCell.swift
//  Plink
//
//  Created by eTech on 11/10/18.
//  Copyright © 2018 eTech. All rights reserved.
//

import UIKit

class ContestListCell: UITableViewCell {

    @IBOutlet weak var viewContDetails: UIView!
    @IBOutlet var lblContestName: UILabel!
    @IBOutlet weak var btnVote: UIButton!
    
    @IBOutlet var imgBackGround: UIImageView!
    @IBOutlet weak var viewShade: UIView!
    

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
