//
//  CreateNewPwdVC.swift
//  RankingStar
//
//  Created by Hitarthi on 01/03/22.
//  Copyright © 2022 Etech. All rights reserved.
//

import UIKit

class CreateNewPwdVC: BaseVC {
    
    var objCreateNewPwdViewModel : CreateNewPwdViewModel!
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var lblCreateNewPwd: UILabel!
    @IBOutlet var viewNewPwd: UIView!
    @IBOutlet var viewConfirmPwd: UIView!
    @IBOutlet var txtFNewPwd: UITextField!
    @IBOutlet var txtFConfirmPwd: UITextField!
    @IBOutlet var btnSubmit: UIButton!
    
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        txtFNewPwd.text = "12345678"
        txtFConfirmPwd.text = "12345678"
        #endif

        objCreateNewPwdViewModel = CreateNewPwdViewModel(vc: self)
        
        navBar.setUI(navBarText: "NAVIGATION_BAR_CREATE_NEW_PWD")
        self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        setUI()
    }

    //MARK: Clicked Events
    @IBAction func submitClicked(_ sender: Any) {
        
        if validationTxtField() {
            getCreateNewPasswordAPI()
        }
    }
    
    //MARK: Custom Methods
    func setUI() {
        
        lblCreateNewPwd.setFgtPwdHeaderVeryBigUIStylePink(value: "NAVIGATION_BAR_CREATE_NEW_PWD")
        
        viewNewPwd.rundViewWithBorderColor()
        viewConfirmPwd.rundViewWithBorderColor()
        
        txtFNewPwd.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_ENTER_NEW_PASSWORD")
        txtFNewPwd.textContentType = .password
        txtFNewPwd.isSecureTextEntry = true
        
        txtFConfirmPwd.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_CONF_PASSWORD")
        txtFConfirmPwd.textContentType = .password
        txtFConfirmPwd.isSecureTextEntry = true
        
        btnSubmit.setTitle(txtValue: "BTN_CHANGE_PWD")
        btnSubmit.setBtnLoginWithEmailUI()
    }
    
    func validationTxtField() -> Bool {
        if (txtFNewPwd.text?.isEmpty)! {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_PASSWORD")
            return false
            
        }else if (txtFNewPwd.text!.count < 8) {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_PASSWORD_8_DIGIT")
            return false
            
        }else if (txtFConfirmPwd.text?.isEmpty)! {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_CONF_PASSWORD")
            return false
            
        }else if (txtFNewPwd.text != txtFConfirmPwd.text) {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_PASSWORD_NOT_MATCH")
            return false
        }
        return true
    }
    
    func getCreateNewPasswordAPI() {
        
        if Util.isNetworkReachable() {
            self.showProgress()
            
            let objOTP = OTP()
            objOTP.userID = userID
            objOTP.password = txtFNewPwd.text
            
            self.objCreateNewPwdViewModel.getCreateNewPwdAPI(objOTP: objOTP)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    //MARK: Button Tabbed
    
    @objc override func leftBarButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: View model methods
    
    func onCreatePwdApiComplete() {
        self.hideProgress()
    }
    
    func onCreatePwdApiSuccess(message : String) {
        
        AlertPresenter.alertInformation(fromVC: self, message: message) {
            let objLoginVC = LoginVC()
//            self.navigationController?.popToRootViewController(animated: false)
////            Util.currentNavigationController.pushViewController(objLoginVC, animated: true)
//            Util.currentNavigationController.popToViewController(objLoginVC, animated: true)
            
            let objMainVc = MainVC()
            Util.objMainVC = objMainVc
            let navMainVC  : UINavigationController = UINavigationController(rootViewController: objMainVc)
            navMainVC.navigationController?.isNavigationBarHidden = true
            navMainVC.isNavigationBarHidden = true
            Util.currentNavigationController = navMainVC
            Util.slideMenuController.changeMainViewController(navMainVC, close: true)

            Util.currentNavigationController.pushViewController(objLoginVC, animated: true)
            
        }

    }
    
    func showMessage(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
}
