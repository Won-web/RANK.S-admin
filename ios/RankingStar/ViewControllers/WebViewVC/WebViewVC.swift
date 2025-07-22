//
//  AboutUsVC.swift
//  Jibudo
//
//  Created by kETAN on 13/06/18.
//  Copyright © 2018 kETAN. All rights reserved.
//

import UIKit
import Material
import WebKit
import SlideMenuControllerSwift

class WebViewVC: BaseVC {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var objWKWebView: WKWebView!
//    var strWebURL:String! = "http://etechservices.biz/ranking_app/under_construction.php"
    var strWebURL:String! = "\(Constant.API.BASEURL)\(Constant.API.USER_GUIDE_WEBVIEW)"
    var isFromAboutUs = false
    var strNavBarTitle:String! = ""
    var selectedVCIndex:Int = 0;
    var isBackButtonShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.view.setRightToLeftPinkGradientViewUI()

//        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
//        objWKWebView.scrollView.addSubview(refreshControl)
        objWKWebView.scrollView.bounces = true
        setNavigationAndUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        setWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.hideProgress()
        dismissAlertInfoPresenter()
    }
    
    // MARK: - set Navigation UI
    func setNavigationAndUI() {
        
//        if(selectedVCIndex == 1)
//        {
//            strNavBarTitle = "NAV_FREE_CHARGEING"
//            // SELECTED TAB IS 3
//        }else if(selectedVCIndex == 2)
//        {
//            strNavBarTitle = "NAV_STAR_SHOP"
//            // SELECTED TAB IS 2
//        }else if(selectedVCIndex == 3)
//        {
//            strNavBarTitle = "NAV_PAID_CHARGING"
//            // SELECTED TEB IS ONE
//        }
        
        navBar.setUI(navBarText: strNavBarTitle)
        if(isBackButtonShow)
        {
            self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        }else
        {
            self.leftBarButton(navBar: navBar, imgName: Constant.Image.menu_black)
            //            self.leftBarButton(navBar: navBar, imgName: Constant.Image.menu)
        }
//        self.leftBarButton(navBar: navBar, imgName: Constant.Image.menu)

        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station_black)
       // self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.menu)
//         self.rightBarSingleBtnWithImage2(navBar: navBar, imgName1: Constant.Image.menu, imgName2: Constant.Image.search)
    }
    
    func updateAPIFromSideMenu() {
        setWebView()
    }
    
    func setWebView() {
        isNetworkAvailable { (isSuccess) in
            if(Util.isNetworkReachable()) {
                let strTrimmedUrl = self.strWebURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: strTrimmedUrl!)
//                let webURL:URLRequest! = URLRequest(url: url!)
                let webURL:URLRequest! = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
                self.showProgress()
                self.objWKWebView.navigationDelegate = self
                self.objWKWebView.configuration.preferences.javaScriptEnabled = true
                self.objWKWebView.load(webURL)
            }else {
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
    }
    
    //MARK: Button Tabbed
    @objc override func leftBarButtonClick() {
        if(isBackButtonShow) {
            self.navigationController?.popViewController(animated: true)
        }else {
            let objMainVC = MainVC()
            Util.objMainVC = objMainVC
            let navPushVC  : UINavigationController = UINavigationController(rootViewController: objMainVC)
            navPushVC.navigationController?.isNavigationBarHidden = true
            navPushVC.isNavigationBarHidden = true
            Util.currentNavigationController = navPushVC
            Util.slideMenuController.changeMainViewController(navPushVC, close: true)
            //            self.toggleLeft()
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
//    @objc func refreshWebView(_ sender: UIRefreshControl) {
//
//        objWKWebView.load(webURL)
//        sender.endRefreshing()
//    }
    
}

extension WebViewVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideProgress()
        
        let contentSize = objWKWebView.scrollView.contentSize
        let viewSize = objWKWebView.bounds.size

        let rw = Float(viewSize.width / contentSize.width)

        objWKWebView.scrollView.minimumZoomScale = CGFloat(rw)
        objWKWebView.scrollView.maximumZoomScale = CGFloat(rw)
        objWKWebView.scrollView.zoomScale = CGFloat(rw)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.hideProgress()
    }

}

extension WebViewVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        // print("SlideMenuControllerDelegate: leftWillOpen")
    }
}
