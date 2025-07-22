//
//  SettingsListCell.swift
//  Plink
//
//  Created by eTech on 11/10/18.
//  Copyright © 2018 eTech. All rights reserved.
//

import UIKit

class ContestantListCell2: UITableViewCell {

    @IBOutlet weak var viewContDetails: UIView!
    @IBOutlet var imgUserProfile: UIImageView!
    @IBOutlet var lblRenk: UILabel!
    @IBOutlet var viewContRenk: UIView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var imgStar: UIImageView!
    @IBOutlet var lblUserVotes: UILabel!
    @IBOutlet var btnVote: UIButton!
    

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
