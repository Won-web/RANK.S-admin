//
//  AlertPresenter.swift
//  CommonXibDemo
//
//  Created by kETAN on 06/10/18.
//  Copyright © 2018 kETAN. All rights reserved.
//

import Foundation
import LSDialogViewController

class AlertPresenter {
    
    static var isAlertInfoPresent = false;
    
    typealias ReqCompletionPositiveBlock = () ->Void
    typealias ReqCompletionNegativeBlock = () ->Void
    
    //MARK: Alert Type Dialog
    static func alertInformation(fromVC: UIViewController, message: String) {
        alertInformation(fromVC: fromVC, message: message, positiveBlock: nil)
    }
    
    static func alertInformation(fromVC: UIViewController, message: String, positiveBlock:ReqCompletionPositiveBlock!) {
        //        alertConfirmation(fromVC: fromVC, message: message, positiveBlock: positiveBlock, negativeBlock: nil)
        alertConfirmation(fromVC: fromVC, message: message, btnPossitiveText: "ALERT_OK", btnNegativeText: "", positiveBlock: positiveBlock, negativeBlock: nil)
    }
    
    static func alertGotoSetting(fromVC: UIViewController, message: String,positiveBlock: ReqCompletionPositiveBlock!, negativeBlock: ReqCompletionNegativeBlock!)
    {
        alertConfirmation(fromVC: fromVC, message: message, btnPossitiveText: "ALERT_GO_TO_SETTINGS", btnNegativeText: "ALERT_CANCEL", positiveBlock: {
            //fromVC.dismissDialogViewController(.fadeInOut)
            // UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            let url = URL(string: UIApplication.openSettingsURLString)!
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }, negativeBlock: negativeBlock)
    }
    
    static func alertWithYesNo(fromVC: UIViewController, message: String, positiveBlock: ReqCompletionPositiveBlock!, negativeBlock: ReqCompletionNegativeBlock!)
    {
        alertConfirmation(fromVC: fromVC, message: message, btnPossitiveText: "ALERT_YES", btnNegativeText: "ALERT_NO", positiveBlock: positiveBlock, negativeBlock: negativeBlock)
    }
    
    static func alertWithYesNoLogOut(fromVC: UIViewController, message: String, positiveBlock: ReqCompletionPositiveBlock!, negativeBlock: ReqCompletionNegativeBlock!)
    {
        alertConfirmation(fromVC: fromVC, message: message, btnPossitiveText: "ALERT_YES", btnNegativeText: "BTN_LOGOUT_NO", positiveBlock: positiveBlock, negativeBlock: negativeBlock)
    }
    
    static func alertWithOkCancel(fromVC: UIViewController, message: String, positiveBlock: ReqCompletionPositiveBlock!, negativeBlock: ReqCompletionNegativeBlock!)
    {
        alertConfirmation(fromVC: fromVC, message: message, btnPossitiveText: "ALERT_OK", btnNegativeText: "ALERT_CANCEL", positiveBlock: positiveBlock, negativeBlock: negativeBlock)
    }
    
    //MARK: Alert Confirmation Dialog
    static func alertConfirmation(fromVC: UIViewController, message: String, btnPossitiveText : String, btnNegativeText : String, positiveBlock: ReqCompletionPositiveBlock!, negativeBlock: ReqCompletionNegativeBlock!) {
        
        let title = "APP_NAME".localizedLanguage()
        
        //if let pBlock = positiveBlock, let nBlock = negativeBlock {
        alertConfirmation(fromVC: fromVC, title: title, message: message, btnPossitiveText: btnPossitiveText, btnNegativeText: btnNegativeText, positiveBlock: positiveBlock, negativeBlock: negativeBlock)
        //}
    }
    
    static func alertConfirmation(fromVC: UIViewController, title: String, message: String, btnPossitiveText : String, btnNegativeText : String, positiveBlock: ReqCompletionPositiveBlock!, negativeBlock:ReqCompletionNegativeBlock!) {
        //fromVC.dismissAlertInfoPresenter()
        
        if let topVC = UIApplication.topViewController()
        {
            if(topVC != fromVC)
            {
                return
            }
        }
        
        fromVC.view.endEditing(true)
        
        if(isAlertInfoPresent == false)
        {
            let objAlertVC = CustomAlertVC()
            AlertPresenter.isAlertInfoPresent = true
            
            //        let objAlertVC = Bundle.main.loadNibNamed("AlertControllerVC", owner: nil, options: nil)?.first as! AlertControllerVC
            objAlertVC.alertTitle = title.localizedLanguage()
            objAlertVC.alertMessage = message.localizedLanguage()
            objAlertVC.btnPossitiveTitle = btnPossitiveText.localizedLanguage()
            objAlertVC.btnNegativeTitle = btnNegativeText.localizedLanguage()
            // objAlertVC.type = .alert
            if (positiveBlock != nil) && (negativeBlock != nil) {
                objAlertVC.isForSingleButton = false
            } else {
                objAlertVC.isForSingleButton = true
            }
            
            objAlertVC.positiveBlock = { (bButtonTapped) in
                AlertPresenter.isAlertInfoPresent = false
                if (positiveBlock != nil) {
                    positiveBlock()
                    
                    
                }
                if bButtonTapped {
                    fromVC.dismissDialogViewController(.fadeInOut)
                }
            }
            
            objAlertVC.negativeBlock = { (bButtonTapped) in
                AlertPresenter.isAlertInfoPresent = false
                if (negativeBlock != nil) {
                    negativeBlock()
                    
                }
                if bButtonTapped {
                    fromVC.dismissDialogViewController(.fadeInOut)
                }
            }
            //        objAlertVC.designAlertMenuPopup()
            //        fromVC.presentDialogViewController(objAlertVC)
            fromVC.presentDialogViewController(objAlertVC, animationPattern: .fadeInOut)
            //        objAlertVC.show()
            
            
        }
        
    }
}

extension UIViewController
{
    func dismissAlertInfoPresenter()
    {
        if(AlertPresenter.isAlertInfoPresent == true)
        {
            AlertPresenter.isAlertInfoPresent = false
            tapLSDialogBackgroundView(UIButton())
        }
    }
}


class WriteCommentViewPresenter {
    
    typealias ReqCompletionPositiveWithDataBlock = (_ bTapped : Bool, _ strMsg : String) ->Void
    typealias ReqCompletionNegativeBlock = () ->Void
    
    //MARK:- Write Comment
    static func writeCommentPopup(fromVC: UIViewController, title: String, placeHolder: String, positiveBlock: ReqCompletionPositiveWithDataBlock!, negativeBlock:ReqCompletionNegativeBlock!) {
        
        fromVC.view.endEditing(true)
        
        let objWritingComment = WritingCommentVC()
        
        objWritingComment.strTitle = title.localizedLanguage()
        objWritingComment.strPlaceholer = placeHolder.localizedLanguage()
        
        objWritingComment.positiveBlock = { (bButtonTapped, strComment) in
            positiveBlock(bButtonTapped, strComment)
            
            if bButtonTapped {
                fromVC.dismissDialogViewController(.fadeInOut)
            }
        }
        
        objWritingComment.negativeBlock = { (bButtonTapped) in
            negativeBlock()
            fromVC.dismissDialogViewController(.fadeInOut)
        }
        
        fromVC.presentDialogViewController(objWritingComment, animationPattern: .fadeInOut)
    }
}



