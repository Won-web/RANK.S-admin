//
//  WritingCommentVC.swift
//  Plink
//
//  Created by kETAN on 09/10/18.
//  Copyright © 2018 eTech. All rights reserved.
//

import UIKit
import Material
import IQKeyboardManagerSwift

class WritingCommentVC: UIViewController, TextViewDelegate {

    @IBOutlet fileprivate var mainViewHolder: UIView!
    @IBOutlet fileprivate var mainViewCenterVerticleConst: NSLayoutConstraint!
    @IBOutlet fileprivate var lblWriteCommentTitle: UILabel!
    @IBOutlet fileprivate var viewWriteTitle: UIView!
    @IBOutlet fileprivate var viewButtonHolder: UIView!
    @IBOutlet fileprivate var txtViewComment: TextView!
    @IBOutlet fileprivate var btnPost: UIButton!
    @IBOutlet fileprivate var btnCancel: UIButton!
    @IBOutlet fileprivate var viewBtnTopBar: UIView!
    @IBOutlet fileprivate var viewBtnVerticleMiddleBar: UIView!
    
    public typealias ReqCompletionPositiveBlock = (_ bButtonTapped : Bool, _ strComment: String) ->Void
    public typealias ReqCompletionNegativeBlock = (_ bButtonTapped : Bool) ->Void
    
    var positiveBlock:ReqCompletionPositiveBlock = { bButtonTapped, strComment in }
    var negativeBlock:ReqCompletionNegativeBlock = { bButtonTapped in }
    
    var strPlaceholer : String!
    var strTitle : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        self.view.bounds.size.height = UIScreen.main.bounds.size.height * 0.35
        self.view.bounds.size.width = UIScreen.main.bounds.size.width * 0.9
        
        btnPost.addTarget(self, action: #selector(btnPositiveClicked(_ :)), for: .touchUpInside)
        btnCancel.addTarget(self, action: #selector(btnNegativeClicked(_ :)), for: .touchUpInside)
        
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.setTitle("Cancel", for: .selected)
        
        btnPost.setTitle("Post", for: .normal)
        btnPost.setTitle("Post", for: .selected)
        
        self.view.backgroundColor = UIColor.clear
        mainViewHolder.cornerRadiusPreset = .cornerRadius3
        
//        viewWriteTitle.cornerRadiusPreset = .cornerRadius2
//        viewButtonHolder.cornerRadiusPreset = .cornerRadius2
        
        lblWriteCommentTitle.text = strTitle
        
        txtViewComment.delegate = self
        txtViewComment.placeholderLabel.text = strPlaceholer
        
        txtViewComment.borderWidthPreset = .border3
        txtViewComment.cornerRadiusPreset = .cornerRadius1
        txtViewComment.borderColor = PopupUtill.VIEW_WRITE_COMMENT_BORDER
        
        txtViewComment.showsVerticalScrollIndicator = false
        txtViewComment.isUserInteractionEnabled = true
        txtViewComment.autocorrectionType = .no
        txtViewComment.textContainerInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        viewBtnVerticleMiddleBar.backgroundColor = PopupUtill.VIEW_WRITE_COMMENT_BORDER
        viewBtnTopBar.backgroundColor = PopupUtill.VIEW_WRITE_COMMENT_BORDER
        
        mainViewHolder.clipsToBounds = true
        mainViewHolder.backgroundColor = PopupUtill.WHITE_VIEW_BG_COLOR
        viewWriteTitle.backgroundColor = PopupUtill.WHITE_VIEW_BG_COLOR
        
        lblWriteCommentTitle.textColor = PopupUtill.LBL_ALERT_POPUP_TXT_BLACK
        lblWriteCommentTitle.adjustsFontSizeToFitWidth = true
        lblWriteCommentTitle.adjustsFontForContentSizeCategory = true
        
        txtViewComment.textColor = PopupUtill.LBL_ALERT_POPUP_TXT_BLACK
        
        btnCancel.titleLabel?.font = PopupUtill.FONT_WRITE_POPUP_BTN_BOLD
        btnPost.titleLabel?.font = PopupUtill.FONT_WRITE_POPUP_BTN_BOLD

        if #available(iOS 10.0, *) {
            btnCancel.titleLabel?.adjustsFontForContentSizeCategory = true
            btnPost.titleLabel?.adjustsFontForContentSizeCategory = true
        } else {
            
        }
        
        txtViewComment.font = PopupUtill.FONT_WRITE_POPUP_TEXTVIEW_REGULAR
        lblWriteCommentTitle.font = PopupUtill.FONT_WRITE_POPUP_LBL_TITLE_BOLD
        
        validateTextview(textView: txtViewComment, isDisable: true)
        btnCancel.setTitleColor(PopupUtill.BTN_WRITE_COMMENT, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().enable = true
    }
    
    
    @objc func btnPositiveClicked(_ sender:UIButton) {
        
        if txtViewComment.text.count == 0 || (txtViewComment.text?.isEmpty)! {
            positiveBlock(false, "")
        }
        else {
            // removed white space from begin and at end
            positiveBlock(true, txtViewComment.text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
    }
    
    @objc func btnNegativeClicked(_ sender:UIButton) {
        negativeBlock(true)
    }

    //MARK:- Textview Delegate
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        slideUpDownPopupView(isSlideUp: true)
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        slideUpDownPopupView(isSlideUp: false)
//    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0 || textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            validateTextview(textView: textView, isDisable: true)
        }
        else {
            validateTextview(textView: textView, isDisable: false)
        }
    }
    
    func validateTextview(textView: UITextView, isDisable:Bool) {
        
        if isDisable {
            btnPost.setTitleColor(UIColor.lightGray, for: .normal)
            btnPost.setTitleColor(UIColor.lightGray, for: .selected)
            btnPost.isUserInteractionEnabled = false
        } else {
            btnPost.setTitleColor(PopupUtill.BTN_WRITE_COMMENT, for: .normal)
            btnPost.setTitleColor(PopupUtill.BTN_WRITE_COMMENT, for: .selected)
            btnPost.isUserInteractionEnabled = true
        }
    }
    
    func textView(textView: TextView, didShowKeyboard value: NSValue) {
        slideUpDownPopupView(isSlideUp: true)
    }
    
    func textView(textView: TextView, willHideKeyboard value: NSValue) {
        slideUpDownPopupView(isSlideUp: false)
    }

    func slideUpDownPopupView(isSlideUp: Bool) {
        
        UIView.transition(with: mainViewHolder, duration: 0.1, options: .showHideTransitionViews, animations: {
            
        }) { (bAnimated) in
            UIView.animate(withDuration: 0.1) {
                if isSlideUp {
                    self.mainViewCenterVerticleConst.constant = -65
                } else {
                    self.mainViewCenterVerticleConst.constant = 0
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

