//
//  PopupOverDropDown.swift
//  CommonXibDemo
//
//  Created by kETAN on 11/10/18.
//  Copyright © 2018 kETAN. All rights reserved.
//

import Foundation
import ContextMenu

@objc protocol PopupOverDropDownDelegate: NSObjectProtocol {
    @objc func selectedDropDownListItem(strItem : String, itemIndex:Int)
}

class PopupOverDropDown: NSObject {
    
    static let LBL_DROP_DOWN_TITLE_COLOR   = UIColor(red:69/255, green:69/255, blue:69/255, alpha:1.0)  // Text color Black(Dark grey) shade
    static let FONT_LBL_DROP_DOWN_TITLE    = UIFont(name: Constant.Font.FONT_REGULAR, size: 16)
    
    
    static let shared = PopupOverDropDown()
    
    var popupDelegate : PopupOverDropDownDelegate? = nil
    var isSetFullSizePopup = false
    var objCelebrity : NSObject!
    var maxSizeOfContent:CGFloat = 50
    var fontSize:CGFloat = 20
    var viewLeftSideSpace:CGFloat = 0
    var lblTextAlignment:NSTextAlignment = .center
    
    func presentPopupMenu(fromVC: UIViewController, arrMenuData:[String], fromSourceView: UIView?) {
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            let objMenuSelection  = DropDownMenuListingTBL()
            objMenuSelection.menuDropdownDeletege = self
            
            if(self.isSetFullSizePopup == false)
            {
                for iTblData in arrMenuData {
                    let lblObj = UILabel()
                    lblObj.text = iTblData
                    lblObj.font = UIFont.boldSystemFont(ofSize: self.fontSize)
                    lblObj.sizeToFit()
                    if self.maxSizeOfContent < lblObj.bounds.width
                    {
                        self.maxSizeOfContent = lblObj.bounds.width
                    }
                }
                objMenuSelection.cGFloatWidthOfCell = self.maxSizeOfContent
            }else
            {
                objMenuSelection.cGFloatWidthOfCell =   UIScreen.main.bounds.width
            }
            
            for iTblData in arrMenuData {
                objMenuSelection.arrTblData.append(DropDownItems(strItemName: iTblData, strImageName: nil))
            }
            objMenuSelection.textAlignment = self.lblTextAlignment
            ContextMenu.shared.show( sourceViewController: fromVC, viewController: objMenuSelection,
                                     options: ContextMenu.Options(containerStyle:
                                        ContextMenu.ContainerStyle(xPadding : 0 , yPadding : 0, edgePadding: self.viewLeftSideSpace, backgroundColor: UIColor.white),
                                     menuStyle: .minimal,
                                     hapticsStyle: .medium),
                                     sourceView: fromSourceView,
                                     delegate: self)
        }
    }
}

//MARK:- ContextMenuDelegate
extension PopupOverDropDown : ContextMenuDelegate {
    func contextMenuWillDismiss(viewController: UIViewController, animated: Bool) {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        //printDebug("contextMenuWillDismiss called")
    }
    
    func contextMenuDidDismiss(viewController: UIViewController, animated: Bool) {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        //printDebug("contextMenuDidDismiss called")
    }
}

//MARK:- DropDownMenuListingTBLDelegate
extension PopupOverDropDown : DropDownMenuListingTBLDelegate {
    func selectedDropDownListItem(strItem: String, itemIndex: Int) {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        if popupDelegate != nil {
            popupDelegate?.selectedDropDownListItem(strItem: strItem, itemIndex:itemIndex)
        } else {
            printDebug("Please set Delegate for PopupOverDropDown")            
        }
        ContextMenu.shared.hidePopupMenu()
    }
}
