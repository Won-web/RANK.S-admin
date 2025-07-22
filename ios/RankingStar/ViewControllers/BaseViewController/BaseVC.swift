//
//  BaseVC.swift
//  HafoosCRM
//
//  Created by etech-9 on 22/11/19.
//  Copyright © 2019 Tushar S. All rights reserved.
//

import UIKit
import CCBottomRefreshControl
import Material
import Alamofire
import MessageUI
import IQKeyboardManagerSwift

class BaseVC: UIViewController ,MFMessageComposeViewControllerDelegate{
    
    typealias CompletionBlockForNetwork = (_ message : Bool) ->Void
    var completionBlockForNetwork:CompletionBlockForNetwork = { message in }
    
    var rechability = Reachability()
    var lblErrorMsgTitle: UILabel!
    var lblNoDataFoundTitle: UILabel!
    var lblErrorMsg: UILabel!
    var lblNoDataFoundMsg: UILabel!
    var btnRetry: RaisedButton!
    var btnNoDataFoundRetry: RaisedButton!
    var imgNoConnection : UIImageView!
    var imgNoDataFound : UIImageView!
    var viewNetworkErrorHolder: UIView!
    var viewAlertNoDataFound: UIView!
    var viewAlertNoDataFound2: UIView!
    var viewAlertNoDataFound3: UIView!
    
    var viewProgress: UIView!
    var viewProgressHolder: UIView!
    
    var isAutoNetworkCheckEnable : Bool = true //override method one of this autoNetworkChecked ELSE btnRetryTapped
    
    var alamofireNetowrk : NetworkReachabilityManager!
    
    var refreshControl = UIRefreshControl()
    var bottomRefreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alamofireNetowrk = NetworkReachabilityManager.init(host: Constant.NETWORK_HOST_NAME)
        
        if (viewProgress != nil) {
            viewProgress.removeFromSuperview()
        }
        
        if (viewNetworkErrorHolder != nil) {
            viewNetworkErrorHolder.removeFromSuperview()
        }
        
        if (viewAlertNoDataFound != nil) {
            viewAlertNoDataFound?.removeFromSuperview()
        }
        
        if (viewAlertNoDataFound2 != nil) {
            viewAlertNoDataFound2?.removeFromSuperview()
        }
        
        if (viewAlertNoDataFound3 != nil) {
            viewAlertNoDataFound3?.removeFromSuperview()
        }
        
        prepareNetworkErrorViewDialog()
        prepareProgressViewDialog()
        prepareNoDataFoundViewDialog()
        prepareNoDataFoundViewDialog2()
        prepareNoDataFoundViewDialog3()
        
        hideKeyboardWhenTappedAround()
    }
    
    
    
    func isNetworkReachable() -> Bool {
        return  alamofireNetowrk.isReachable
        //        return (rechability?.isReachable)!
    }
    
    func showSimpleProgress() {
        if (alamofireNetowrk.isReachable) {
            //        if (rechability?.isReachable)! {
            //                SVProgressHUD.setContainerView(nil)
            //                SVProgressHUD.setDefaultMaskType(.black)
            //                SVProgressHUD.setForegroundColor(UIColor.lightGray)
            //                SVProgressHUD.show()
            Util.showLoading()
        } else {
            showNetworkDialog()
            startMonitoring()
            self.progressWithNetwokrkFoundCheck(false)
        }
    }
    
    func hideSimpleProgress() {
        //            SVProgressHUD.dismiss()
        Util.hideLoading()
    }
    
    
    //MARK:- Full Screen Progress Dialog
    func getProgressViewNibFile() -> UIView {
        return (Bundle.main.loadNibNamed("PorgressView", owner: self, options: nil)?.first as! UIView)
    }
    
    func prepareProgressViewDialog() {
        viewProgress = getProgressViewNibFile()
        viewProgressHolder = viewProgress.viewWithTag(301)
    }
    
    func showFullscreenProgressDialog() {
        
        if (alamofireNetowrk.isReachable) {
            //        if (rechability?.isReachable)! {
            self.viewProgress.frame = CGRect(x: self.viewProgress.frame.origin.x, y: self.viewProgress.frame.origin.y, width: self.viewProgress.frame.size.width, height: self.viewProgress.frame.size.height)
            self.viewProgress.backgroundColor = UIColor.clear
            self.viewProgress.frame = self.view.bounds
            self.view.autoresizingMask = [.flexibleWidth , .flexibleHeight]
            //                    SVProgressHUD.setContainerView(self.viewProgress)
            //                    //SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: 0))
            //                    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
            //                    SVProgressHUD.setBackgroundColor(.clear)
            //                    SVProgressHUD.show()
            Util.showLoading()
            self.view.addSubview(self.viewProgress)
            self.progressWithNetwokrkFoundCheck(true)
        } else {
            showNetworkDialog()
            startMonitoring()
            self.progressWithNetwokrkFoundCheck(false)
        }
    }
    
    func progressWithNetwokrkFoundCheck(_ isProgressAdded:Bool) { }
    func btnRetryTapped() { }
    func autoNetworkChecked() { }
    
    func hideFullscreenDialog() {
        self.viewProgress.removeFromSuperview()
        //                SVProgressHUD.dismiss()
        Util.hideLoading()
    }
    
    //MARK:- Network Eror Dialog
    func getNetworkViewNibFile() -> UIView {
        return (Bundle.main.loadNibNamed("NetworkError", owner: self, options: nil)?.first as! UIView)
    }
    
    func getNoDataFoundViewNibFile() -> UIView {
        return (Bundle.main.loadNibNamed("AlertNoDataFound", owner: self, options: nil)?.first as! UIView)
    }
    
    func prepareNetworkErrorViewDialog() {
        viewNetworkErrorHolder = getNetworkViewNibFile()
        imgNoConnection = viewNetworkErrorHolder.viewWithTag(101) as! UIImageView
        lblErrorMsgTitle = viewNetworkErrorHolder.viewWithTag(102) as! UILabel
        lblErrorMsg = viewNetworkErrorHolder.viewWithTag(103) as! UILabel
        btnRetry = viewNetworkErrorHolder.viewWithTag(104) as! RaisedButton
        btnRetry.addTarget(self, action: #selector(btnRetryClicked), for: .touchUpInside)
        
        lblErrorMsgTitle.text = "ALERT_NO_INTERNET_SOMETHING_WRONG".localizedLanguage()
        lblErrorMsg.text = "ALERT_YOUR_OFF_LINE".localizedLanguage()
        //        GeneralUtill.setLableHeightAcoordingToText(label: lblErrorMsg)
        //
        //        lblErrorMsgTitle.font = GeneralUtill.setAppBoldFontWithFontSize(iFontSize: 16)
        //        lblErrorMsg.font = GeneralUtill.setAppBoldFontWithFontSize(iFontSize: 14)
        //        lblErrorMsgTitle.textColor = Constant.COLOR_HEX_APP_LIGHT_SEMI_TRANSPARENT_COLOR
        //        lblErrorMsg.textColor = Constant.COLOR_HEX_APP_LIGHT_SEMI_TRANSPARENT_COLOR
        
        let imgNoInternetConnection = UIImage(named: "no_internet_connection")
        imgNoConnection.image = imgNoInternetConnection
        //        btnRetry.setRaisedButtonWithBorderUI(withLocaliseText: "BTN_RETRY")
        btnRetry.setBtnSignUpInfo(txtValue: "BTN_RETRY")
    }
    
    
    func prepareNoDataFoundViewDialog() {
        viewAlertNoDataFound = getNoDataFoundViewNibFile()
        imgNoDataFound = viewAlertNoDataFound?.viewWithTag(101) as! UIImageView
        lblNoDataFoundTitle = viewAlertNoDataFound?.viewWithTag(102) as! UILabel
        lblNoDataFoundMsg = viewAlertNoDataFound?.viewWithTag(103) as! UILabel
        btnNoDataFoundRetry = viewAlertNoDataFound?.viewWithTag(104) as! RaisedButton
        btnNoDataFoundRetry.addTarget(self, action: #selector(btnNoDataFoundRetryClicked), for: .touchUpInside)
        
        lblNoDataFoundTitle.setLblNoDataFoundUIInf(lblValue: "LBL_NO_PRODUCTFOUND")
        lblNoDataFoundMsg.text = ""
        
        //        imgNoDataFound.image = UIImage(named: "no_data_found")
        btnNoDataFoundRetry.isHidden = true
        //        btnNoDataFoundRetry.setRaisedButtonWithBorderUI(withLocaliseText: "BTN_RETRY")
    }
    
    func prepareNoDataFoundViewDialog2() {
        viewAlertNoDataFound2 = getNoDataFoundViewNibFile()
        imgNoDataFound = viewAlertNoDataFound2?.viewWithTag(101) as! UIImageView
        lblNoDataFoundTitle = viewAlertNoDataFound2?.viewWithTag(102) as! UILabel
        lblNoDataFoundMsg = viewAlertNoDataFound2?.viewWithTag(103) as! UILabel
        btnNoDataFoundRetry = viewAlertNoDataFound2?.viewWithTag(104) as! RaisedButton
       // btnNoDataFoundRetry.addTarget(self, action: #selector(btnNoDataFoundRetryClicked), for: .touchUpInside)
        
        lblNoDataFoundTitle.setLblNoDataFoundUIInf(lblValue: "LBL_NO_PRODUCTFOUND")
        lblNoDataFoundMsg.text = ""
        
        //        imgNoDataFound.image = UIImage(named: "no_data_found")
        btnNoDataFoundRetry.isHidden = true
        //        btnNoDataFoundRetry.setRaisedButtonWithBorderUI(withLocaliseText: "BTN_RETRY")
    }
    
    func prepareNoDataFoundViewDialog3() {
        viewAlertNoDataFound3 = getNoDataFoundViewNibFile()
        imgNoDataFound = viewAlertNoDataFound3?.viewWithTag(101) as! UIImageView
        lblNoDataFoundTitle = viewAlertNoDataFound3?.viewWithTag(102) as! UILabel
        lblNoDataFoundMsg = viewAlertNoDataFound3?.viewWithTag(103) as! UILabel
        btnNoDataFoundRetry = viewAlertNoDataFound3?.viewWithTag(104) as! RaisedButton
      //  btnNoDataFoundRetry.addTarget(self, action: #selector(btnNoDataFoundRetryClicked), for: .touchUpInside)
        
        lblNoDataFoundTitle.setLblNoDataFoundUIInf(lblValue: "LBL_NO_PRODUCTFOUND")
        lblNoDataFoundMsg.text = ""
        
        //        imgNoDataFound.image = UIImage(named: "no_data_found")
        btnNoDataFoundRetry.isHidden = true
        //        btnNoDataFoundRetry.setRaisedButtonWithBorderUI(withLocaliseText: "BTN_RETRY")
    }
    
    func showNetworkDialog() {
        let when = DispatchTime.now() + 0.001
        DispatchQueue.main.asyncAfter(deadline: when) {
            if self.isAutoNetworkCheckEnable {
                //                self.btnRetry.isHidden = true
                self.btnRetry.isHidden = false
            } else {
                self.btnRetry.isHidden = false
            }
            self.view.addSubview(self.viewNetworkErrorHolder)
            self.viewNetworkErrorHolder.frame = CGRect(x: self.viewNetworkErrorHolder.frame.origin.x, y: self.viewNetworkErrorHolder.frame.origin.y, width: self.viewNetworkErrorHolder.frame.size.width, height: self.viewNetworkErrorHolder.frame.size.height)
            self.viewNetworkErrorHolder.frame = self.view.bounds
            self.view.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        }
    }
    
    func hideNetworkDialog() {
        viewNetworkErrorHolder.removeFromSuperview()
    }
    
    func showNoDataFoundDialog(uiView:UIView) {
        let when = DispatchTime.now() + 0.002
        DispatchQueue.main.asyncAfter(deadline: when) {
            uiView.addSubview(self.viewAlertNoDataFound!)
            
            self.viewAlertNoDataFound!.frame = CGRect(x: (self.viewAlertNoDataFound?.frame.origin.x)!, y: (self.viewAlertNoDataFound?.frame.origin.y)!, width: (self.viewAlertNoDataFound?.frame.size.width)!, height: (self.viewAlertNoDataFound?.frame.size.height)!)
            
            //self.viewAlertNoDataFound!.frame = CGRect(x: (uiView.frame.origin.x), y: (uiView.frame.origin.y), width: (uiView.frame.size.width), height: (uiView.frame.size.height))
            
            self.viewAlertNoDataFound?.frame = self.view.bounds
            uiView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        }
    }
    
    func showNoDataFoundDialog2(uiView:UIView) {
        let when = DispatchTime.now() + 0.002
        DispatchQueue.main.asyncAfter(deadline: when) {
            uiView.addSubview(self.viewAlertNoDataFound2!)
            
            self.viewAlertNoDataFound2!.frame = CGRect(x: (self.viewAlertNoDataFound2?.frame.origin.x)!, y: (self.viewAlertNoDataFound2?.frame.origin.y)!, width: (self.viewAlertNoDataFound2?.frame.size.width)!, height: (self.viewAlertNoDataFound2?.frame.size.height)!)
            
            //self.viewAlertNoDataFound2!.frame = CGRect(x: (uiView.frame.origin.x), y: (uiView.frame.origin.y), width: (uiView.frame.size.width), height: (uiView.frame.size.height))
            
            self.viewAlertNoDataFound2?.frame = self.view.bounds
            uiView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        }
    }
    
    func showNoDataFoundDialog3(uiView:UIView) {
        let when = DispatchTime.now() + 0.002
        DispatchQueue.main.asyncAfter(deadline: when) {
            uiView.addSubview(self.viewAlertNoDataFound3!)
            
            self.viewAlertNoDataFound3!.frame = CGRect(x: (self.viewAlertNoDataFound3?.frame.origin.x)!, y: (self.viewAlertNoDataFound3?.frame.origin.y)!, width: (self.viewAlertNoDataFound3?.frame.size.width)!, height: (self.viewAlertNoDataFound3?.frame.size.height)!)
            
            //self.viewAlertNoDataFound2!.frame = CGRect(x: (uiView.frame.origin.x), y: (uiView.frame.origin.y), width: (uiView.frame.size.width), height: (uiView.frame.size.height))
            
            self.viewAlertNoDataFound3?.frame = self.view.bounds
            uiView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        }
    }
    
    func hideNoDataFoundDialog() {
        viewAlertNoDataFound?.removeFromSuperview()
    }
    func hideNoDataFoundDialog2() {
        viewAlertNoDataFound2?.removeFromSuperview()
    }
    func hideNoDataFoundDialog3() {
        viewAlertNoDataFound3?.removeFromSuperview()
    }
    
    // Perform Calling Action
    func performCallToComplaintUser( _ strNumber: String) {
        
        let when = DispatchTime.now() + 0.001
        DispatchQueue.main.asyncAfter(deadline: when) {
            #if !TARGET_IPHONE_SIMULATOR
            if UIApplication.shared.canOpenURL(URL(string: "tel://")!) {
                let strNewData : String = strNumber.replacingOccurrences(of: " ", with: " ")
                UIApplication.shared.openURL(URL(string: "tel:\(strNewData)")!)
    
                //UIApplication.shared.openURL(URL(string: "tel:+\(strNumber.replacingOccurrences(of: " ", with: ""))")!)
            } else {
                self.showAlert(msg: "LBL_CALL_PHONE_ERROR".localizedLanguage() )
            }
            #else
            self.showAlert(msg: "Can't perform this action.")
            #endif
        }
    }
    
    func isNetworkAvailable(_ completion: @escaping CompletionBlockForNetwork) {
        completionBlockForNetwork = completion
        
        if (alamofireNetowrk.isReachable) {
            networErrorMSGDialogView()
            hideFullscreenDialog()
        } else {
            showNetworkDialog()
            startMonitoring()
        }
    }
    
    func networErrorMSGDialogView() {
        if (alamofireNetowrk.isReachable) {
            //        if (rechability?.isReachable)! {
            stopMonitoring()
            hideNetworkDialog()
            hideFullscreenDialog()
            completionBlockForNetwork(true)
        }
    }
    
    func startMonitoring() {
        
        DispatchQueue.main.async {
            self.alamofireNetowrk.startListening()
            
            self.alamofireNetowrk.listener = { (objRefStatus) in
                var strConnectionType = ""
                switch (objRefStatus) {
                case .unknown:
                    printDebug("Netork status type: \(objRefStatus)")
                    strConnectionType = "Unknown"
                    self.showNetworkDialog()
                    break
                    
                //Mobile netwok
                case .reachable(.wwan):
                    printDebug("Netork status type: \(objRefStatus)")
                    strConnectionType = "WWan"
                    if self.isAutoNetworkCheckEnable {
                        self.autoNetworkChecked()
                        self.stopMonitoring()
                        self.networErrorMSGDialogView()
                    }
                    self.hideFullscreenDialog()
                    break
                    
                //Wifi or eathernet
                case .reachable(.ethernetOrWiFi):
                    printDebug("Netork status type: \(objRefStatus)")
                    strConnectionType = "Ethernet or Wifi"
                    if self.isAutoNetworkCheckEnable {
                        self.autoNetworkChecked()
                        self.stopMonitoring()
                        self.networErrorMSGDialogView()
                    }
                    self.hideFullscreenDialog()
                    
                //No Internet connection
                case .notReachable:
                    printDebug("Netork status type: \(objRefStatus)")
                    strConnectionType = "conneciton not reachable"
                    self.showNetworkDialog()
                    break
                }
                
                printDebug("Netork status type: \(strConnectionType)")
            }
        }
        
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        
        let reachability = notification.object as! Reachability
        switch reachability.currentReachabilityStatus {
            
        case .notReachable:
            showNetworkDialog()
        case .reachableViaWiFi:
            if isAutoNetworkCheckEnable {
                autoNetworkChecked()
                stopMonitoring()
                networErrorMSGDialogView()
            }
            hideFullscreenDialog()
            printDebug("Network reachable through WiFi")
        case .reachableViaWWAN:
            if isAutoNetworkCheckEnable {
                autoNetworkChecked()
                stopMonitoring()
                networErrorMSGDialogView()
            }
            hideFullscreenDialog()
            printDebug("Network reachable through Cellular Data")
        }
    }
    
    func stopMonitoring() {
        //        rechability?.stopNotifier()
        //        NotificationCenter.default.removeObserver(self,
        //                                                  name: ReachabilityChangedNotification,
        //                                                  object: rechability)
        alamofireNetowrk.stopListening()
    }
    
    func presentSendingSMSToUser(_ strMessageText: String, _ strNumber: String) {
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = strMessageText
            var strNumberToSendSMS = strNumber
            let strNewData : String = strNumber.replacingOccurrences(of: " ", with: " ")
            strNumberToSendSMS = "+\(strNewData)"
            
            controller.recipients = [strNumberToSendSMS]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    
    //MARK : Button clicked method
    @IBAction func btnRetryClicked(_ sender: Any) {
        let objReachability = Reachability()
        if (objReachability?.isReachable)! {
            stopMonitoring()
            hideNetworkDialog()
            hideFullscreenDialog()
            completionBlockForNetwork(true)
        }
        //        networErrorMSGDialogView()
    }
    
    @IBAction func btnNoDataFoundRetryClicked(_ sender: Any) {
    }
    
    
    
    
    
    //    func presentSendingSMSToUser(_ recipientsOfContacts: [String]) {
    //
    //        let urlString : String = "LBL_DOWNLOAD".localizedLanguage()
    //
    //        //let number = "sms:+7405453513";
    //
    //        //let smsSnipet = "sms:+917405453513&body=\(urlString)"
    //        //let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    ////        let activityViewController = UIActivityViewController(activityItems: [URL(string: smsSnipet)], applicationActivities: nil)
    ////        self.present(activityViewController, animated: true, completion: {})
    //
    //        /*
    //         var strNumberToSendSMS = strNumber
    //         if let strNewData : String = strNumber.replacingOccurrences(of: " ", with: "") {
    //            strNumberToSendSMS = "+\(strNewData)"
    //        }
    //        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    ////        let url  = URL(string: "whatsapp://send?abid=917405453513&text=\(urlStringEncoded!)")
    //        let url = URL(string: "whatsapp://send?text=\(urlStringEncoded!)")
    //
    //        if UIApplication.shared.canOpenURL(url!) {
    //            UIApplication.shared.openURL(url!)
    //         } else {
    //            printDebug("Can't WhatsApp to send MSG.")
    //        }
    //        */
    //
    //        if (MFMessageComposeViewController.canSendText()) {
    //            let controller = MFMessageComposeViewController()
    //            controller.body = urlString
    ////            var strNumberToSendSMS = strNumber
    ////            if let strNewData : String = strNumber.replacingOccurrences(of: " ", with: "") {
    ////                strNumberToSendSMS = "+\(strNewData)"
    ////            }
    //            controller.recipients = recipientsOfContacts
    //            controller.messageComposeDelegate = self
    //            self.present(controller, animated: true, completion: nil)
    //        }
    //    }
    
    //MARK: MFMessageComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    var lblNoData = UILabel()
    
    //    func showNoDataFound() {
    //        lblNoData.isHidden = false
    //        lblNoData.frame =  CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
    ////        lblNoData.setTitleUI(value: "NO_DATA_FOUND")
    //        lblNoData.numberOfLines = 0
    //        lblNoData.textAlignment = .center
    //        self.view.addSubview(lblNoData)
    //    }
    
    //    func hideNoDataFound() {
    //        lblNoData.isHidden = true
    //    }
    
    //MARK:- Custom methods
    func showProgress() {
        Util.showLoading()
    }
    
    func hideProgress() {
        Util.hideLoading()
    }
    
    @objc func leftBarButtonClick() {
    }
    
    @objc func leftBarButtonClick2() {
    }
    
    @objc func leftBarButtonWithTextClick() {
    }
    
    @objc func rightBtnClickedWithImg() {
    }
    
    @objc func rightBtnClickedWithImg2() {
    }
    
    func leftBarButton(navBar : UINavigationBar , imgName : String) {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
       // backButton.setBackgroundImage(UIImage(named: imgName), for: .normal)
        backButton.setImage(UIImage(named: imgName), for: .normal)
        backButton.setImage(UIImage(named: imgName), for: .highlighted)
        backButton.contentHorizontalAlignment = .left
        backButton.addTarget(self, action: #selector(self.leftBarButtonClick), for: .touchUpInside)
        let leftItem  = UIBarButtonItem(customView: backButton)
        navBar.topItem?.leftBarButtonItem = leftItem
    }
    
    func leftBarButton2(navBar : UINavigationBar , imgName1 : String, imgName2 : String) {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 40))
       // backButton.setBackgroundImage(UIImage(named: imgName1), for: .normal)
        backButton.setImage(UIImage(named: imgName1), for: .normal)
        backButton.setImage(UIImage(named: imgName1), for: .highlighted)
        backButton.contentHorizontalAlignment = .left
        backButton.addTarget(self, action: #selector(self.leftBarButtonClick), for: .touchUpInside)
        let leftItem  = UIBarButtonItem(customView: backButton)
        
        let backButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
       // backButton2.setBackgroundImage(UIImage(named: imgName2), for: .normal)
        backButton2.setImage(UIImage(named: imgName2), for: .normal)
        backButton2.setImage(UIImage(named: imgName2), for: .highlighted)
        backButton2.contentMode = .scaleAspectFit
        backButton2.contentHorizontalAlignment = .left
//        backButton2.imageView?.contentMode = .scaleAspectFit
        backButton2.addTarget(self, action: #selector(self.leftBarButtonClick2), for: .touchUpInside)
        let leftItem2  = UIBarButtonItem(customView: backButton2)
        navBar.topItem?.leftBarButtonItems = [leftItem,leftItem2]
    }
    
    
    func leftBarButtonWithText(navBar : UINavigationBar , imgName : String , lblText : String) {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
      //  backButton.setBackgroundImage(UIImage(named: imgName), for: .normal)
        backButton.setImage(UIImage(named: imgName), for: .normal)
        backButton.setImage(UIImage(named: imgName), for: .highlighted)
        backButton.contentHorizontalAlignment = .left
        backButton.addTarget(self, action: #selector(self.leftBarButtonWithTextClick), for: .touchUpInside)
        let leftItem  = UIBarButtonItem(customView: backButton)
        
        let lbl = UILabel()
        lbl.text = lblText.localizedLanguage()
        lbl.font = Constant.Font.NAVIGATIONBAR_TEXT
        lbl.textColor = Constant.Color.NAVIGATIONBAR_TEXT_COLOR
        lbl.textAlignment = .left
        let leftLabel = UIBarButtonItem(customView: lbl)
        navBar.topItem?.title = ""
        navBar.topItem?.leftBarButtonItems = [leftItem , leftLabel]
    }
    
    func rightBarSingleBtnWithImage(navBar : UINavigationBar , imgName : String) {
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
       // rightBarButton.setBackgroundImage(UIImage(named: imgName), for: .normal)
        rightBarButton.setImage(UIImage(named: imgName), for: .normal)
        rightBarButton.setImage(UIImage(named: imgName), for: .highlighted)
        
        rightBarButton.addTarget(self, action: #selector(self.rightBtnClickedWithImg), for: .touchUpInside)
        let rightItem  = UIBarButtonItem(customView: rightBarButton)
        navBar.topItem?.rightBarButtonItem = rightItem
    }
    
    func rightBarSingleBtnWithImage2(navBar : UINavigationBar , imgName1 : String, imgName2 : String) {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
       // backButton.setBackgroundImage(UIImage(named: imgName1), for: .normal)
        backButton.setImage(UIImage(named: imgName1), for: .normal)
        backButton.setImage(UIImage(named: imgName1), for: .highlighted)
        
        backButton.addTarget(self, action: #selector(self.rightBtnClickedWithImg), for: .touchUpInside)
        let rightItem  = UIBarButtonItem(customView: backButton)
        
        let backButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
//        backButton2.setBackgroundImage(UIImage(named: imgName2), for: .normal)
        backButton2.setImage(UIImage(named: imgName2), for: .normal)
        backButton2.setImage(UIImage(named: imgName2), for: .highlighted)
        backButton2.addTarget(self, action: #selector(self.rightBtnClickedWithImg2), for: .touchUpInside)
        let rightItem2  = UIBarButtonItem(customView: backButton2)
        navBar.topItem?.rightBarButtonItems = [rightItem,rightItem2]
    }
    
    @objc func refresh(sender:AnyObject) {
        
    }
    
    @objc func bottomRefresh(sender:AnyObject) {
        
    }
    
    
    func addRefreashControl(tblView : UITableView)
    {
        refreshControl.attributedTitle = NSAttributedString(string: "".localizedLanguage())
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tblView.addSubview(refreshControl)
    }
    
    func addBottomRefreshControl(tblview : UITableView) {
        bottomRefreshController.addTarget(self, action: #selector(bottomRefresh(sender:)), for: .valueChanged)
        tblview.bottomRefreshControl = bottomRefreshController
    }
}
