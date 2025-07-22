//
//  PopupUtill.swift
//  Plink
//
//  Created by kETAN on 09/10/18.
//  Copyright © 2018 eTech. All rights reserved.
//

import Foundation
import UIKit

class PopupUtill: NSObject {
    
    static let VIEW_ALERT_TITLE_BG_COLOR           = Constant.Color.NAVIGATION_BAR_BG_COLOR //UIColor(red:106/255, green:101/255, blue:240/255, alpha:1.0)  // Purple Text
    static let LBL_ALERT_POPUP_TXT_BLACK           = UIColor(red:69/255, green:69/255, blue:69/255, alpha:1.0)  // Text color Black(Dark grey) shade
    static let BTN_ALERT_POPUP_BLACK               = UIColor(red:69/255, green:69/255, blue:69/255, alpha:1.0)  // Text color Black(Dark grey) shade
    
    static let BTN_WRITE_COMMENT                   = Constant.Color.NAVIGATION_BAR_BG_COLOR //UIColor(red:106/255, green:101/255, blue:240/255, alpha:1.0)  // Purple Text
    static let WHITE_VIEW_BG_COLOR                 = UIColor.white //White
    static let VIEW_WRITE_COMMENT_BORDER           = UIColor(red:220/255, green:220/255, blue:220/255, alpha:1.0)  // LIght Gray Text
    
    static let FONT_ALERT_POPUP_LBL_TITLE_REGULAR  = UIFont(name: Constant.Font.FONT_REGULAR, size: 16)
    static let FONT_ALERT_POPUP_LBL_MSG_REGULAR    = UIFont(name: Constant.Font.FONT_REGULAR, size: 15)
    static let FONT_ALERT_POPUP_BTN_REGULAR        = UIFont(name: Constant.Font.FONT_REGULAR, size: 15)
    
    static let FONT_WRITE_POPUP_LBL_TITLE_BOLD     = UIFont(name: Constant.Font.FONT_BOLD, size: 18)
    static let FONT_WRITE_POPUP_TEXTVIEW_REGULAR   = UIFont(name: Constant.Font.FONT_REGULAR, size: 18)
    static let FONT_WRITE_POPUP_BTN_BOLD           = UIFont(name: Constant.Font.FONT_BOLD, size: 16)
}

//MARK:- UILabel
extension UILabel {
    
    func labelHeightAccordingText(label: UILabel) {
        
        if label.text != nil {
            let constraint = CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
            var size: CGSize
            let context = NSStringDrawingContext()
            
            let boundingBox: CGSize? = label.text?.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: context).size
            size = CGSize(width: ceil((boundingBox?.width)!), height: ceil((boundingBox?.height)!))
            
            var newFrame = label.frame
            newFrame.size.height = size.height
            label.frame = newFrame
        }
        
    }
    
    func labelHeightAfterSetText(label: UILabel) -> CGSize {
        
        let constraint = CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        var size: CGSize
        let context = NSStringDrawingContext()
        
        let boundingBox: CGSize? = label.text?.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: context).size
        size = CGSize(width: ceil((boundingBox?.width)!), height: ceil((boundingBox?.height)!))
        
        return size
    }
}

//MARK:- NSLayoutConstraint
extension NSLayoutConstraint {
    
    func changeConstraintMultiplierAndConstant(constraintToChange: NSLayoutConstraint, newMultiplier:CGFloat, newConstant: CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([constraintToChange])
        
        let newConstraint = NSLayoutConstraint(
            item: constraintToChange.firstItem,
            attribute: constraintToChange.firstAttribute,
            relatedBy: constraintToChange.relation,
            toItem: constraintToChange.secondItem,
            attribute: constraintToChange.secondAttribute,
            multiplier: newMultiplier,
            constant: newConstant)
        
        newConstraint.priority = constraintToChange.priority
        newConstraint.shouldBeArchived = constraintToChange.shouldBeArchived
        newConstraint.identifier = constraintToChange.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
