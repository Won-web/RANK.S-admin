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
import WebKit

class NoticeDetailsVC: BaseVC {
    
    @IBOutlet var navBar: UINavigationBar!
    
    @IBOutlet weak var lblNoticeTitle: UILabel!
    @IBOutlet weak var lblNoticeDate: UILabel!
    
    @IBOutlet weak var lblNoticeDetails: UILabel!
    @IBOutlet weak var viewSepretor: UIView!
    
    @IBOutlet  var txtSearch: UITextField!
    @IBOutlet var viewContSearch: UIView!
    @IBOutlet var btnSearchClose: UIButton!
    
    @IBOutlet weak var objWebview: WKWebView!
    
    var searchedText : String = ""
    var strTitle:String = ""
    var strDate:String = ""
    var strDetails:String = ""
    
    var objNotice : Notice!
    
    @IBOutlet weak var viewMain: UIView!
    var objWKWebView1:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.view.setRightToLeftPinkGradientViewUI()
        txtSearch.delegate = self
        setUIColor()
        
        objWebview.scrollView.bounces = true
        setWebView()
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
//      Util.statusBarColor(color: Constant.Color.NAVIGATION_BAR_BG_COLOR)
        navBar.setUI(navBarText: "NAVIGATION_BAR_NOTICE")
        self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station_black)
       
        txtSearch.setSearchUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_SEARCH_TITLE")
        btnSearchClose.setBackgroundImage(UIImage(named: Constant.Image.close), for: .normal)
        viewContSearch.rectViewWithBorderColor()
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        viewContSearch.isHidden = true
        
        viewSepretor.backgroundColor = Constant.Color.VIEW_SEPRETOR_COLOR
        
        
//        lblNoticeTitle.setBoldEditProfileSecondTitleBalck(value: strTitle)
//
//        lblNoticeDate.setNormalDateThirdTitlePlaceHolder(value: strDate)
//        lblNoticeDetails.setNormalDateThirdTitlePlaceHolder(value: strDetails)
        
//        lblNoticeTitle.setBoldEditProfileSecondTitleBalck(value: "Title message")
//        lblNoticeDate.setNormalDateThirdTitlePlaceHolder(value: "2019.12.14")
        
        lblNoticeTitle.setBoldEditProfileSecondTitleBalck(value: objNotice.notice_title)
        let date = Util.convertDateFormat(date: objNotice.notice_date, dateFormat: Constant.DateFormat.DateFormatYYYY_MM_DD_HH_MM_SS, newDateFormat: Constant.DateFormat.Simple_Date_Format)
        lblNoticeDate.setNormalDateThirdTitlePlaceHolder(value: date!)
        
//        lblNoticeDetails.setNormalDateThirdTitlePlaceHolder(value: objNotice.notice_description)
        lblNoticeDetails.setNormalDateThirdTitlePlaceHolder(value: "")
    }
    
//    func setWebView() {
//        isNetworkAvailable { (isSuccess) in
//            if(Util.isNetworkReachable()) {
//
//                let strWebURL = "\(self.objNotice.web_view_url!)"
//
//                let strTrimmedUrl = strWebURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                let url = URL(string: strTrimmedUrl!)
////                let webURL:URLRequest! = URLRequest(url: url!)
//                let webURL:URLRequest! = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
//                self.showProgress()
//                self.objWebview.navigationDelegate = self
//                self.objWebview.configuration.preferences.javaScriptEnabled = true
//                self.objWebview.load(webURL)
//            }else {
//                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
//
//            }
//        }
//    }
    
    func setWebView() {
        isNetworkAvailable { (isSuccess) in
            if(Util.isNetworkReachable()) {

                let strWebURL = "\(self.objNotice.web_view_url!)"

                let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
                let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
                let wkUController = WKUserContentController()
                wkUController.addUserScript(wkUScript)
                let wkWebConfig = WKWebViewConfiguration()
                wkWebConfig.userContentController = wkUController
                self.objWKWebView1 = WKWebView(frame: self.viewMain.frame, configuration: wkWebConfig)

                self.objWKWebView1.navigationDelegate = self
                self.objWKWebView1.scrollView.bounces = true

                self.viewMain.addSubview(self.objWKWebView1)

                let strTrimmedUrl = strWebURL.trimmingCharacters(in: .whitespaces)
                let url = URL(string: strTrimmedUrl)
                let webURL:URLRequest! = URLRequest(url: url!)
                self.showProgress()
                self.objWKWebView1.frame = self.viewMain.bounds
                self.objWKWebView1.autoresizingMask = [.flexibleWidth , .flexibleHeight]
                self.objWKWebView1.configuration.preferences.javaScriptEnabled = true
                self.objWKWebView1.load(webURL)
            }
        }
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
    @objc func textFieldDidChange(_ textField: UITextField) {
        printDebug(textField.text)
    }
    
    @objc override func leftBarButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @objc override func leftBarButtonClick2() {
//        let mainVC = MainVC()
//        let navMainVC  : UINavigationController = UINavigationController(rootViewController: mainVC)
//        navMainVC.navigationController?.isNavigationBarHidden = true
//        navMainVC.isNavigationBarHidden = true
//
//        self.slideMenuController()?.changeMainViewController(navMainVC, close: true)
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
    
    @objc override func rightBtnClickedWithImg2() {
        viewContSearch.isHidden = false
    }
    
  
}

extension NoticeDetailsVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField == txtSearch) {
            self.searchedText = txtSearch.text!
            
            if searchedText.isEmpty {
              //  objChargingStarHistoryModel.arrChargingHistoryModel = []
               // self.tblView.reloadData()
                
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

extension NoticeDetailsVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        // printDebug("SlideMenuControllerDelegate: leftWillOpen")
    }
}

extension NoticeDetailsVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideProgress()
       // refreshControl.endRefreshing()
        
        let contentSize = objWebview.scrollView.contentSize
        let viewSize = objWebview.bounds.size

        let rw = Float(viewSize.width / contentSize.width)

        objWebview.scrollView.minimumZoomScale = CGFloat(rw)
        objWebview.scrollView.maximumZoomScale = CGFloat(rw)
        objWebview.scrollView.zoomScale = CGFloat(rw)
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.hideProgress()
        //refreshControl.endRefreshing()
    }
}
