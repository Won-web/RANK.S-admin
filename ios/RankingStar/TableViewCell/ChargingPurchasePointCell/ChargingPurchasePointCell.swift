//
//  ChargingPurchasePointCell.swift
//  RankingStar
//
//  Created by Hitarthi on 06/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class ChargingPurchasePointCell: UITableViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewSeperator: UIView!
    @IBOutlet weak var lblStaticText: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnPrice: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
