//
//  AlertControllerVC.swift
//  CommonXibDemo
//
//  Created by kETAN on 06/10/18.
//  Copyright © 2018 kETAN. All rights reserved.
//

import UIKit
import Material

class CustomAlertVC: UIViewController {
    
    public typealias ReqCompletionPositiveBlock = (_ bButtonTapped : Bool) ->Void
    public typealias ReqCompletionNegativeBlock = (_ bButtonTapped : Bool) ->Void
    
    private let POPUP_MAX_HEIGHT : CGFloat = 0.8
    private let POPUP_MIN_HEIGHT : CGFloat = 0.3
    private let POPUP_MIN_HEIGHT_V2 : CGFloat = 0.35

    @IBOutlet  var mainAlertViewHolder: UIView!
    @IBOutlet  var lblConfirmationTitle: UILabel!
    @IBOutlet  var viewAlertTitle: UIView!
    @IBOutlet  var scrollView: UIScrollView!
    @IBOutlet  var lblConfirmationMessage: UILabel!
    @IBOutlet  var viewButtonHolder: UIView!
    @IBOutlet  var btnPositive: UIButton!
    @IBOutlet  var btnPositiveWidthConst: NSLayoutConstraint!
    @IBOutlet  var btnPositiveLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var viewMainHeightConst: NSLayoutConstraint!
    
    @IBOutlet  var btnNegative: UIButton!
    @IBOutlet  var viewButtonDivider: UIView!
    
    var positiveBlock:ReqCompletionPositiveBlock = { bButtonTapped in }
    var negativeBlock:ReqCompletionNegativeBlock = { bButtonTapped in }
    
    var alertTitle = String()
    var alertMessage = String()
    var isForSingleButton : Bool = false
    var btnPossitiveTitle = String()
    var btnNegativeTitle = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        // adjust height and width of dialog
        
       
        
    }
    
    override func viewDidLoad() {
        //        animationDuration = 0.3
        // set TRUE if wants to close on out side of alert box, it will close all Alert dialogs if there are multiple dialog open.
        //               ETPopupWindow.sharedWindow().touchWildToHide = false
        
        //               self.cornerRadiusPreset = .cornerRadius2
        //               self.backgroundColor = PopupUtill.WHITE_VIEW_BG_COLOR
        //
        lblConfirmationTitle.textColor = PopupUtill.WHITE_VIEW_BG_COLOR
        lblConfirmationMessage.textColor = PopupUtill.LBL_ALERT_POPUP_TXT_BLACK
        btnNegative.titleLabel?.textColor = PopupUtill.BTN_ALERT_POPUP_BLACK
        btnPositive.titleLabel?.textColor = PopupUtill.BTN_ALERT_POPUP_BLACK
        
        mainAlertViewHolder.cornerRadiusPreset = .cornerRadius6
        mainAlertViewHolder.backgroundColor = PopupUtill.WHITE_VIEW_BG_COLOR
        viewAlertTitle.backgroundColor = PopupUtill.VIEW_ALERT_TITLE_BG_COLOR
        
        if #available(iOS 10.0, *) {
            btnPositive.titleLabel?.adjustsFontForContentSizeCategory = true
            btnNegative.titleLabel?.adjustsFontForContentSizeCategory = true
        } else {
            
        }
        
        lblConfirmationTitle.font = PopupUtill.FONT_ALERT_POPUP_LBL_TITLE_REGULAR
        lblConfirmationMessage.font = PopupUtill.FONT_ALERT_POPUP_LBL_MSG_REGULAR
        if #available(iOS 10.0, *) {
            lblConfirmationMessage.adjustsFontForContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
        lblConfirmationMessage.adjustsFontSizeToFitWidth = true
        btnNegative.titleLabel?.font = PopupUtill.FONT_ALERT_POPUP_BTN_REGULAR
        btnPositive.titleLabel?.font = PopupUtill.FONT_ALERT_POPUP_BTN_REGULAR
        
        designAlertMenuPopup()
    }

    func designAlertMenuPopup() {
        
        btnPositive.setTitle(btnPossitiveTitle, for: .normal)
        btnNegative.setTitle(btnNegativeTitle, for: .normal)
        
        lblConfirmationTitle.text = alertTitle
        lblConfirmationMessage.text = alertMessage
        lblConfirmationMessage.labelHeightAccordingText(label: lblConfirmationMessage)
        let heightLabelText = lblConfirmationMessage.labelHeightAfterSetText(label: lblConfirmationMessage)
        
        btnPositive.isHidden = true
        btnNegative.isHidden = true
        viewButtonDivider.isHidden = true
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        if isForSingleButton {
            //show only positive button
            btnPositive.isHidden = false
            btnPositiveLeadingConst.constant = 7
            btnPositiveWidthConst = btnPositiveWidthConst.changeConstraintMultiplierAndConstant(constraintToChange: btnPositiveWidthConst, newMultiplier: 0.95, newConstant: 0.0)
            
        } else {
            btnPositive.isHidden = false
            btnNegative.isHidden = false
            viewButtonDivider.isHidden = false
            btnPositiveLeadingConst.constant = 10
            btnPositiveWidthConst = btnPositiveWidthConst.changeConstraintMultiplierAndConstant(constraintToChange: btnPositiveWidthConst, newMultiplier: 0.45, newConstant: 0.0)
            
        }
        
        let numberOfLines = Int((heightLabelText.height)/(lblConfirmationMessage.font.lineHeight))
        var popupHeight = POPUP_MIN_HEIGHT_V2
        
        if numberOfLines >= 20 {
            scrollView.isScrollEnabled = true
            popupHeight = UIScreen.main.bounds.size.height * POPUP_MAX_HEIGHT
        }
        else if numberOfLines <= 3 {
            if UIScreen.main.bounds.size.height <= 568 {
                popupHeight = UIScreen.main.bounds.size.height * POPUP_MIN_HEIGHT_V2
            } else {
                popupHeight = UIScreen.main.bounds.size.height * POPUP_MIN_HEIGHT
            }
        }
        else {
            
            let screenHeight = UIScreen.main.bounds.size
            let rationMultipler = (heightLabelText.height+heightLabelText.width) / (screenHeight.height+screenHeight.width)
            if rationMultipler >= POPUP_MIN_HEIGHT && rationMultipler <= POPUP_MAX_HEIGHT {
                scrollView.isScrollEnabled = true
                popupHeight = (UIScreen.main.bounds.size.height * CGFloat(rationMultipler))
            } else {
                popupHeight = (UIScreen.main.bounds.size.height * POPUP_MIN_HEIGHT)
            }
        }
        
        if Util.isDeleteAccBtnTapped {
            viewMainHeightConst.constant = 250
        }
//        self.snp.makeConstraints { (make) in
//            make.width.equalTo(UIScreen.main.bounds.size.width * 0.9)
//            make.height.equalTo(popupHeight)
//        }
    }
    
    @IBAction func btnPositiveClicked(_ sender: UIButton) {
        positiveBlock(true)
//        hide()
    }
    
    @IBAction func btnNegativeClicked(_ sender: UIButton) {
        negativeBlock(true)
//        hide()
    }
    
    @IBAction func btnDismissPopupViewClicked(_ sender: UIButton) {
        //Simple Dismiss popup view
        negativeBlock(true)
    }
    
    
}












