//
//  LoginVC.swift
//  RankingStar
//
//  Created by Jinesh on 13/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit
import Material
import AnyFormatKit

class AttendanceCheckConfirmVC: BaseVC {
    
    @IBOutlet var viewContMainPopup: UIView!
    @IBOutlet var viewContHeader: UIView!
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAtendanceCheck: UILabel!
    @IBOutlet var imgBtnClose: UIImageView!
    
//    @IBOutlet var imgSideMenuStar: UIImageView!
//    @IBOutlet var lblMyStar: UILabel!
//    @IBOutlet var lblTotalCoin: UILabel!
//    @IBOutlet var lblTitlePiece: UILabel!
    
   // @IBOutlet var btnUserAllStar: UIButton!
    
    @IBOutlet var lblInfoMaxStarUse: UILabel!
    
    @IBOutlet var btnSend: UIButton!
    var totalUserStar:Int!
    var myNavigationController:UINavigationController? = nil
    
    var objContestant = ContestantDetailModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissAlertInfoPresenter()
    }
    
    //MARK: custom method
    func setUIColor()
    {
        self.view.backgroundColor = Constant.Color.VIEW_TRANSPERENT_BG_POPUP_COLOR
        
        viewContMainPopup.layer.cornerRadius = 20
        viewContMainPopup.clipsToBounds = true
        viewContHeader.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        imgBtnClose.setImageFit(imageName: Constant.Image.close_white)
        
        lblTitle.setHeaderUIStyleWhite(value: "LBL_TITLE_ATTRENDANCE_CHECK")
        lblAtendanceCheck.setLoginHeaderVeryBigUIStylePink(value: "LBL_ATTRENDANCE_CHECK_COMP_ON_DAY")

        lblInfoMaxStarUse.setSmallTitleSemiBlack(value : "LBL_ATTENDANCE_ONLY_ONEY_ONCE_A_DAY")

        btnSend.setTitle(txtValue: "LBL_ATTENDENCE_CHECK")
        btnSend.setBtnSendVoteUI()
        
    }
    
    //MARK:- Button clicked
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSendClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}




