//
//  SettingsListCell.swift
//  Plink
//
//  Created by eTech on 11/10/18.
//  Copyright © 2018 eTech. All rights reserved.
//

import UIKit

class EditProfileMsgCell: UITableViewCell {

    @IBOutlet weak var viewContDetails: UIView!
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var imgLikeDislike: UIImageView!
    
    @IBOutlet var lblLikeCount: UILabel!
    
    @IBOutlet var lblMsg: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblReplay: UILabel!
    @IBOutlet var lblViewAll: UILabel!
    @IBOutlet var viewContLikeDislike: UIView!
    
    var cellCount = 0
//    EDIT_PROFILE_SUB_MSG_CELL
    
    @IBOutlet var tblViewSumMsg: UITableView!
    @IBOutlet var tblViewHeightSubMsg: NSLayoutConstraint!
    
    //MARK: table view cell method
    override func awakeFromNib() {
        super.awakeFromNib()
        tblViewSumMsg.register(UINib(nibName: Constant.CellIdentifier.EDIT_PROFILE_SUB_MSG_CELL, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier.EDIT_PROFILE_SUB_MSG_CELL)
        tblViewSumMsg.delegate = self
        tblViewSumMsg.dataSource = self
        tblViewSumMsg.isScrollEnabled = false
        tblViewSumMsg.separatorStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func viewContLikeDislikeTabbed(_ sender: CustomTabGestur){
        printDebug("viewContLikeDislikeTabbed sub : \(sender.intIndex)")
       
    }
    
//    @objc func lblViewAllTabbed(_ sender: CustomTabGestur){
//        printDebug("lblViewAllTabbed : \(sender.intIndex)")
//
//    }
    
}

extension EditProfileMsgCell : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.EDIT_PROFILE_SUB_MSG_CELL) as! EditProfileSubMsgCell
        
        cell.selectionStyle = .none
        cell.imgUser.setImageFit(imageName: Constant.Image.user_send_msg)
        cell.imgLikeDislike.setImageFit(imageName: Constant.Image.heart_like)
        cell.lblMsg.setNormalEditProfileThirdTitleBalck(value: "h22yeon I support you. Please win! cheer It is. Aza Aza Fighting ~~~ !!!")
        cell.lblMsg.setAttributedTextMsgCellLbl(text: cell.lblMsg.text!, subString: "h22yeon")
        cell.lblTime.setNormalEditProfileThirdTitleBalck(value: "2 hours")
        cell.lblReplay.setNormalEditProfileThirdTitleBalck(value: "LBL_REPLAY")
//        cell.lblViewAll.setNormalEditProfileThirdTitleBalck(value: "LBL_VIEW_ALL")
        cell.lblLikeCount.setSmallEditProfileThirdTitleBalckPinkCell(value: "\(indexPath.row)00")

       
        let viewContLikeDislikeTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContLikeDislikeTabbed))
        viewContLikeDislikeTabbed.intIndex = indexPath.row
        cell.viewContLikeDislike.isUserInteractionEnabled = true
        cell.viewContLikeDislike.addGestureRecognizer(viewContLikeDislikeTabbed)
        
//        let lblViewAllTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.lblViewAllTabbed))
//        lblViewAllTabbed.intIndex = indexPath.row
//        cell.lblViewAll.isUserInteractionEnabled = true
//        cell.lblViewAll.addGestureRecognizer(lblViewAllTabbed)
        
        return cell
    }
    
   
}

