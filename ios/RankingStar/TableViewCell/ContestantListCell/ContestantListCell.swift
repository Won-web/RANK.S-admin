//
//  SettingsListCell.swift
//  Plink
//
//  Created by eTech on 11/10/18.
//  Copyright © 2018 eTech. All rights reserved.
//

import UIKit

class ContestantListCell: UITableViewCell {

    @IBOutlet weak var viewContDetails: UIView!
    @IBOutlet weak var viewContNameDetails: UIView!
    @IBOutlet weak var viewContVotesDetails: UIView!
    @IBOutlet weak var viewContVotesButton: UIView!
    
    @IBOutlet var lblRank: UILabel!
    @IBOutlet var lblRankBaseOnYesterDay: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblVoteCount: UILabel!
    @IBOutlet var imgVoteView: UIImageView!
    @IBOutlet var imgContestant: UIImageView!
    @IBOutlet var imgRankBaseOnYesterDay: UIImageView!
    @IBOutlet var lblVoteTitle: UILabel!

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
