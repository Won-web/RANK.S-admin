//
//  ContestantProfileVideoCell.swift
//  RankingStar
//
//  Created by Hitarthi on 27/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class ContestantProfileVideoCell: UITableViewCell {
    
    @IBOutlet var imgVideoThumbnail: UIImageView!
    @IBOutlet var imgVideoPlayBtn: UIImageView!
    @IBOutlet weak var viewSeparator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
