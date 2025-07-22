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

class PushNotificationListVC: BaseVC {
    
    var objPushNotificationListViewModel : PushNotificationListViewModel!
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var tblView: UITableView!
    
    var searchedText : String = ""
    @IBOutlet  var txtSearch: UITextField!
    @IBOutlet var viewContSearch: UIView!
    @IBOutlet var btnSearchClose: UIButton!
    var isBackButtonShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objPushNotificationListViewModel = PushNotificationListViewModel(vc: self)
        
//        self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.view.setRightToLeftPinkGradientViewUI()
        txtSearch.delegate = self
        tblView.delegate = self
        tblView.dataSource = self
        
        tblView.register(UINib(nibName: Constant.CellIdentifier.PUSH_NOTIFICATION_CELL, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier.PUSH_NOTIFICATION_CELL)
        
        tblView.tableFooterView = UIView()
        addRefreashControl(tblView: tblView)
        
        setUIColor()
    }

    override func viewWillAppear(_ animated: Bool) {
        Util.appDelegate.isPushViewOn = true
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Util.statusBarColor(color: UIColor.clear)
        Util.appDelegate.isPushViewOn = false
        dismissAlertInfoPresenter()
    }
    
     //MARK: custom method
    func setUIColor()
    {
        getPushNotificationListAPI()
//        Util.statusBarColor(color: Constant.Color.NAVIGATION_BAR_BG_COLOR)
        
        navBar.setUI(navBarText: "NAVIGATION_BAR_NOTIFICATION")
        if(isBackButtonShow)
        {
            self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        }else
        {
            self.leftBarButton(navBar: navBar, imgName: Constant.Image.menu_black)
        }
       // self.leftBarButton(navBar: navBar, imgName: Constant.Image.back)
        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station_black)
        
        txtSearch.setSearchUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_SEARCH_TITLE")
        btnSearchClose.setBackgroundImage(UIImage(named: Constant.Image.close), for: .normal)
        viewContSearch.rectViewWithBorderColor()
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        viewContSearch.isHidden = true
        
    }
    
    func getPushNotificationListAPI() {
        isNetworkAvailable { (isSuccess) in
            if Util.isNetworkReachable() {
                self.showProgress()
                
                let dictData1:[String: Any]? = Util.getUserProfileDict()
                
                if(dictData1 != nil) {
                    let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
                    let userID : String = objUserProfile.strUserId
                    self.objPushNotificationListViewModel.getPushNotificationListAPI(userID: userID)
                }
            }else {
                self.refreshControl.endRefreshing()
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
    }
    
    func updateAPIFromSideMenu() {
        getPushNotificationListAPI()
    }
    
    override func refresh(sender: AnyObject) {
        getPushNotificationListAPI()
    }
    
    //MARK:- Button clicked
    @IBAction func btnSearchClicked(_ sender: UIButton) {
        viewContSearch.isHidden = true
    }
    
    @IBAction func switchPushAlarmClicked(_ sender: UISwitch) {
    }
    
   
    @IBAction func switchSountNotificationClicked(_ sender: UISwitch) {
    }
    @IBAction func switchVibrationClicked(_ sender: UISwitch) {
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
        //        self.navigationController?.popViewController(animated: true)
    }
    
    //    @objc override func leftBarButtonClick2() {
    ////        self.navigationController?.popViewController(animated: true)
    //    }
    
    
    @objc override func rightBtnClickedWithImg() {
        
        if(Util.getIsUserLogin() == "0") {
            AlertPresenter.alertInformation(fromVC: Util.currentNavigationController.topViewController!, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
        }else {
            let objWebViewWithTabVC = WebViewWithTabVC()
            objWebViewWithTabVC.isBackButtonShow = true
            self.navigationController?.pushViewController(objWebViewWithTabVC, animated: true)
        }
        
        
    }
    
//    @objc override func rightBtnClickedWithImg2() {
//        viewContSearch.isHidden = false
//    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        printDebug(textField.text)
    }
    
    //MARK:- View Model Methods
    
    func onApiSuccessHideProgress() {
        self.hideProgress()
        refreshControl.endRefreshing()
    }
    
    func onSuccessApiResponce() {
        if objPushNotificationListViewModel.arrPushNotificationList.count == 0 {
            self.showNoDataFoundDialog(uiView: self.tblView)
        }else {
            self.hideNoDataFoundDialog()
            tblView.reloadData()
        }
    }
    
    func onFailApiResponce(message : String) {
        if objPushNotificationListViewModel.arrPushNotificationList.count == 0 {
            self.showNoDataFoundDialog(uiView: self.tblView)
        }
//        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
}

extension PushNotificationListVC : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objPushNotificationListViewModel.getNumberOfRecords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.PUSH_NOTIFICATION_CELL) as! PushNotificationCell
        
        cell.selectionStyle = .none
        cell.imgNext.setImageFit(imageName: Constant.Image.next)
        
//        cell.lblMsgTitle.setBoldPushNotificationSecondTitlePink(value: "Title message \(indexPath.row)")
//        cell.lblMsgDate.setNormalDateThirdTitlePlaceHolder(value: "12.28 (Wed) 11:39 am")
////        cell.lblMsgTitle.setBoldEditProfileUIStylePink(value: "Title message \(indexPath.row)")
//        cell.lblMsgDetails.setNormalEditProfileSecondTitleBalck(value: "This is message details \(indexPath.row)")
        
        // Api Data
        let objNotification = objPushNotificationListViewModel.arrPushNotificationList[indexPath.row]
        cell.lblMsgTitle.setBoldPushNotificationSecondTitlePink(value: objNotification.message_title)
        
        let date = Util.convertDateFormat(date: objNotification.created_date, dateFormat: Constant.DateFormat.DateFormatYYYY_MM_DD_HH_MM_SS, newDateFormat: Constant.DateFormat.DateTimeFormat)
        cell.lblMsgDate.setNormalDateThirdTitlePlaceHolder(value: date!)
        cell.lblMsgDetails.setNormalEditProfileSecondTitleBalck(value: objNotification.message)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let objContestantProfileVC = ContestantProfileVC()
//        self.navigationController?.pushViewController(objContestantProfileVC, animated: true)
    }
}

extension PushNotificationListVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField == txtSearch) {
            self.searchedText = txtSearch.text!
            
            if searchedText.isEmpty {
              //  objChargingStarHistoryModel.arrChargingHistoryModel = []
                self.tblView.reloadData()
                
            }else {
//                getChargingHistoryAPI()
               // printDebug(txtSearch.text)
                // nothing
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtSearch) {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension PushNotificationListVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        // printDebug("SlideMenuControllerDelegate: leftWillOpen")
    }
}
