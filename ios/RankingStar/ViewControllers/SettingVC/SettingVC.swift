//
//  LoginVC.swift
//  RankingStar
//
//  Created by Jinesh on 13/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit
import Material
import SlideMenuControllerSwift

class SettingVC: BaseVC {
    
    var objAppSettingsViewModel : AppSettingsViewModel!
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var btnSignUp: UIButton!
    
    @IBOutlet var lblPushAlarm: UILabel!
    
    @IBOutlet var lblSountNotification: UILabel!
    @IBOutlet var lblVibration: UILabel!
    @IBOutlet var lblAppVersion: UILabel!
    
    @IBOutlet weak var switchPushAlarm: UISwitch!
    @IBOutlet weak var switchSountNotification: UISwitch!
    @IBOutlet weak var switchVibration: UISwitch!
    var isBackButtonShow = false
    var isSwitchPushAlarmFail = false
    var isSwitchSountNotificationFail = false
    var isSwitchVibrationFail = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        objAppSettingsViewModel = AppSettingsViewModel(vc: self)
        
//        self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.view.setRightToLeftPinkGradientViewUI()
        setUIColor()
    }

    override func viewWillAppear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Util.statusBarColor(color: UIColor.clear)
        dismissAlertInfoPresenter()
    }
    
     //MARK: custom method
    func setUIColor()
    {
//        Util.statusBarColor(color: Constant.Color.NAVIGATION_BAR_BG_COLOR)
        navBar.setUI(navBarText: "NAVIGATION_BAR_APP_SETTINGS")
        getSettingsApi()
        if(isBackButtonShow)
        {
            self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        }else
        {
            self.leftBarButton(navBar: navBar, imgName: Constant.Image.menu_black)
        }
        // self.leftBarButton(navBar: navBar, imgName: Constant.Image.back)
        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station_black)
        
        switchPushAlarm.onTintColor = Constant.Color.SWITCH_BG_COLOR
        switchSountNotification.onTintColor = Constant.Color.SWITCH_BG_COLOR
        switchVibration.onTintColor = Constant.Color.SWITCH_BG_COLOR
        
        lblPushAlarm.setNormalEditProfileSecondTitleBalck(value: "LBL_PUSH_ALARM")
        lblSountNotification.setNormalEditProfileSecondTitleBalck(value: "LBL_SOUND_NOTIFICATION")
        lblVibration.setNormalEditProfileSecondTitleBalck(value: "LBL_VIBRATION_ALERT")
        
        lblAppVersion.setNormalEditProfileSecondTitleGray(value: "")
        lblAppVersion.text = "LBL_APP_VERSION".localizedLanguage() + " v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
        btnSignUp.setTitle(txtValue: "BTN_COMPLETE")
        btnSignUp.setBtnSignUpUI()
    }
    
    func getSettingsApi() {
        isNetworkAvailable { (isSuccess) in
            if Util.isNetworkReachable() {
                self.showFullscreenProgressDialog()

                let objSettings = Settings()
                
                let dictData1:[String: Any]? = Util.getUserProfileDict()
                if(dictData1 != nil) {
                    let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
                    objSettings.userId = objUserProfile.strUserId
                }
                self.objAppSettingsViewModel.getSettingsAPI(objSettings: objSettings)
            }else {
                self.hideFullscreenDialog()
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
    }
    
    func setSettingsApi() {
        if Util.isNetworkReachable() {
            self.showFullscreenProgressDialog()
            let objSettings = Settings()
            
            let dictData1:[String: Any]? = Util.getUserProfileDict()
            if(dictData1 != nil) {
                let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
                objSettings.userId = objUserProfile.strUserId
            }else {
                objSettings.userId = "1"
            }
            
            if switchPushAlarm.isOn {
                objSettings.pushalert = "enabled"
            }else {
                objSettings.pushalert = "disabled"
            }
            
            if switchSountNotification.isOn {
                objSettings.pushsound = "enabled"
            }else {
                objSettings.pushsound = "disabled"
            }
            
            if switchVibration.isOn {
                objSettings.pushvibrate = "enabled"
            }else {
                objSettings.pushvibrate = "disabled"
            }
            
            objAppSettingsViewModel.setSettingsAPI(objSettings: objSettings)
        }else {
            responsFailChangeSwitch()
            self.hideFullscreenDialog()
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func updateAPIFromSideMenu() {
        getSettingsApi()
    }
    
    //MARK: Button clicked
    
    @IBAction func switchPushAlarmClicked(_ sender: UISwitch) {
        isSwitchPushAlarmFail = true
        
        if !switchPushAlarm.isOn {
            switchVibration.isEnabled = false
            switchSountNotification.isEnabled = false
        }else {
            switchVibration.isEnabled = true
            switchSountNotification.isEnabled = true
        }
        
        setSettingsApi()
    }
    @IBAction func switchSountNotificationClicked(_ sender: UISwitch) {
        isSwitchSountNotificationFail = true
        setSettingsApi()
    }
    @IBAction func switchVibrationClicked(_ sender: UISwitch) {
        isSwitchVibrationFail = true
        setSettingsApi()
    }
    
    //MARK: Button click events
    @IBAction func btnSignUpClicked(_ sender: UIButton) {
//        print("Alert : \(switchPushAlarm.isOn), Sound : \(switchSountNotification.isOn), Vibrate : \(switchVibration.isOn)")
//        setSettingsApi()
    }
    
    //MARK: Button Tabbed
    @objc override func leftBarButtonClick() {
        if(isBackButtonShow)
        {
            self.navigationController?.popViewController(animated: true)
        }else
        {
            dismissAlertInfoPresenter()
            self.toggleLeft()
        }
    }
    
    @objc override func rightBtnClickedWithImg() {
        
        if(Util.getIsUserLogin() == "0") {
            AlertPresenter.alertInformation(fromVC: Util.currentNavigationController.topViewController!, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
        }else {
            let objWebViewWithTabVC = WebViewWithTabVC()
            objWebViewWithTabVC.isBackButtonShow = true
            self.navigationController?.pushViewController(objWebViewWithTabVC, animated: true)
        }
    }
    
    //MARK:- View Model Methods
    
    func onApiSuccessHideProgress() {
        self.hideFullscreenDialog()
    }
    
    func onSuccessApiGetSettingsResponce() {
        let objSettings = objAppSettingsViewModel.objSettings
        
        if objSettings.pushalert == "enabled" {
            switchPushAlarm.setOn(true, animated: false)
        }else {
            switchPushAlarm.setOn(false, animated: false)
        }
        
        if objSettings.pushsound == "enabled" {
            switchSountNotification.setOn(true, animated: false)
        }else {
            switchSountNotification.setOn(false, animated: false)
        }
        
        if objSettings.pushvibrate == "enabled" {
            switchVibration.setOn(true, animated: false)
        }else {
            switchVibration.setOn(false, animated: false)
        }
    }
    
    func onSuccessApiResponce(message : String) {
//        if model.arrPushNotificationList.count == 0 {
//            self.showNoDataFoundDialog(uiView: self.view)
//        }else {
//            self.hideNoDataFoundDialog()
//            tblView.reloadData()
//        }
//        AlertPresenter.alertInformation(fromVC: self, message: message)
        
        if(isSwitchPushAlarmFail == true)
        {
            isSwitchPushAlarmFail = false
        }else if(isSwitchSountNotificationFail == true)
        {
            isSwitchSountNotificationFail = false
        }else if(isSwitchVibrationFail == true)
        {
            isSwitchVibrationFail = false
        }
        
    }
    
    func onFailApiResponce(message : String) {
        
        responsFailChangeSwitch()
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    func responsFailChangeSwitch()
    {
        if(isSwitchPushAlarmFail == true)
        {
            isSwitchPushAlarmFail = false
            switchPushAlarm.isOn =  !switchPushAlarm.isOn
        }else if(isSwitchSountNotificationFail == true)
        {
            isSwitchSountNotificationFail = false
            switchSountNotification.isOn = !switchSountNotification.isOn
        }else if(isSwitchVibrationFail == true)
        {
            isSwitchVibrationFail = false
            switchVibration.isOn = !switchVibration.isOn
        }
    }
}

extension SettingVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        // printDebug("SlideMenuControllerDelegate: leftWillOpen")
    }
}
