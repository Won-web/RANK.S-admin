//
//  SettingsListCell.swift
//  Plink
//
//  Created by eTech on 11/10/18.
//  Copyright © 2018 eTech. All rights reserved.
//

import UIKit

class VotingHistoryCell: UITableViewCell {

    @IBOutlet weak var viewSeprator: UIView!
    @IBOutlet var lblIndex: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblCounter: UILabel!
   // @IBOutlet var imgUser: UIImageView!
    @IBOutlet var imgStar: UIImageView!
    
    
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
