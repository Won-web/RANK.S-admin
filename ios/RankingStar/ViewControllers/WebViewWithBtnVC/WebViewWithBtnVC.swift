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


class WebViewWithBtnVC: BaseVC {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var objWKWebView: WKWebView!
    
    @IBOutlet var btnContentList: UIButton!
    @IBOutlet weak var btnContestHomePage: UIButton!
    @IBOutlet weak var cnsBtnContentListWidth: NSLayoutConstraint!
    
    @IBOutlet weak var viewMain: UIView!
    

    var strWebURL:String! = "http://etechservices.biz/ranking_app/under_construction.php"
    var isFromAboutUs = false
    var strNavBarTitle:String! = "" //2020 Analyst Korea"
    //    var uiRefreshControl:UIRefreshControl = UIRefreshControl()
    var webURL:URLRequest!
    //var isBackButtonShow = false
    var strHomeUrl = ""
    
    var objWKWebView1:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.view.setRightToLeftPinkGradientViewUI()
        
//        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
//        objWKWebView.scrollView.addSubview(refreshControl)
        objWKWebView.scrollView.bounces = true
        setWebView()
        
        setNavigationAndUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
//        self.showProgress()
//        setWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        self.hideProgress()
        dismissAlertInfoPresenter()
    }
    
    // MARK: - set Navigation UI
    func setNavigationAndUI() {
        navBar.setUI(navBarText: strNavBarTitle)
        self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station_black)
        
        btnContentList.setTitle(txtValue: "BTN_GO_CONTESTANT_LIST")
        btnContentList.setBtnSignUpUI()
        
        btnContestHomePage.setTitle(txtValue: "BTN_GO_CONTESTANT_HOMEPAGE")
        btnContestHomePage.setBtnContestantHomeUI()
        
        let strTrimmedUrl = self.strHomeUrl.trimmingCharacters(in: .whitespaces)
        if strTrimmedUrl == "" {
            cnsBtnContentListWidth.constant = self.view.frame.width
        }else {
            cnsBtnContentListWidth.constant = self.view.frame.width / 2
        }
        
    }
    
//    func setWebView() {
//        isNetworkAvailable { (isSuccess) in
//            if(Util.isNetworkReachable()) {
//
////                let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport');  meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
////                let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
////                let wkUController = WKUserContentController()
////                wkUController.addUserScript(wkUScript)
////                let wkWebConfig = WKWebViewConfiguration()
////                wkWebConfig.userContentController = wkUController
////                self.objWKWebView = WKWebView(frame: self.viewMain.frame, configuration: wkWebConfig)
//
//
//                let strTrimmedUrl = self.strWebURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                let url = URL(string: strTrimmedUrl!)
////                let webURL:URLRequest! = URLRequest(url: url!)
//                let webURL:URLRequest! = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
//                self.showProgress()
//
//
//                self.objWKWebView.navigationDelegate = self
//                self.objWKWebView.configuration.preferences.javaScriptEnabled = true
//
////                self.objWKWebView.scrollView.delegate = self
////                self.objWKWebView.contentMode = .scaleToFill
////                self.objWKWebView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
////                self.objWKWebView.translatesAutoresizingMaskIntoConstraints = false
//                self.objWKWebView.load(webURL)
//            }else {
//                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
//
//            }
//        }
//    }
    
    func setWebView() {
        isNetworkAvailable { (isSuccess) in
            if(Util.isNetworkReachable()) {

                let jScript = """
                    var meta = document.createElement('meta');
                    meta.setAttribute('name', 'viewport');
                    meta.setAttribute('content', 'width=device-width');
                    meta.setAttribute('content', 'max-width=90%');
                    document.getElementsByTagName('head')[0].appendChild(meta);
                """
                
//                meta.setAttribute('shrink-to-fit', 'YES');
//                meta.setAttribute('maximum-scale', '1.0');
//                meta.setAttribute('minimum-scale', '1.0');
//                meta.setAttribute('user-scalable', 'no');
//                meta.setAttribute('content', 'max-width=60%');
//                meta.setAttribute('initial-scale', '1.0');
//                meta.setAttribute('user-scalable', 'yes');
//                meta.setAttribute('maximum-scale', '1');
//                meta.setAttribute('content', 'minWidth=device-width');
                
                let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
                let wkUController = WKUserContentController()
                wkUController.addUserScript(wkUScript)
                let wkWebConfig = WKWebViewConfiguration()
                wkWebConfig.userContentController = wkUController
                self.objWKWebView1 = WKWebView(frame: .zero, configuration: wkWebConfig)

                self.objWKWebView1.navigationDelegate = self
                self.objWKWebView1.scrollView.bounces = true
                
//                self.objWKWebView1.translatesAutoresizingMaskIntoConstraints = false
                
                self.viewMain.addSubview(self.objWKWebView1)

                let strTrimmedUrl = self.strWebURL.trimmingCharacters(in: .whitespaces)
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
    
    @IBAction func btnContentListClicked(_ sender: UIButton) {
//        let objContestantListVC = ContestantListVC()
//        self.navigationController?.pushViewController(objContestantListVC, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContestHomePageClicked(_ sender: Any) {
//        let objWebViewChargingStationFreeVC = WebViewChargingStationFreeVC()
//        objWebViewChargingStationFreeVC.strWebURL = self.strHomeUrl
//        objWebViewChargingStationFreeVC.isContestWebview = true
//        self.navigationController?.pushViewController(objWebViewChargingStationFreeVC, animated: true)
        strWebURL = self.strHomeUrl
        setWebView()
    }
    
    //MARK: Button Tabbed
    
    @objc override func leftBarButtonClick() {
        //self.toggleLeft()
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
    
//    @objc func refreshWebView(_ sender: UIRefreshControl) {
//        objWKWebView.load(webURL)
//        sender.endRefreshing()
//    }
    
}

extension WebViewWithBtnVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideProgress()
        
//        objWKWebView.frame.size = objWKWebView.scrollView.contentSize
//        let contentSize = objWKWebView1.scrollView.contentSize
//        let viewSize = objWKWebView1.bounds.size
//
//        let rw = Float(viewSize.width / contentSize.width)
//
//        objWKWebView1.scrollView.minimumZoomScale = CGFloat(rw)
//        objWKWebView1.scrollView.maximumZoomScale = CGFloat(rw)
//        objWKWebView1.scrollView.zoomScale = CGFloat(rw)
        
//        self.objWKWebView1?.frame.size.width = UIScreen.main.bounds.size.width
        
//        webView.evaluateJavaScript("document.documentElement.scrollWidth", completionHandler: { (width, error) in
//            self.objWKWebView1?.frame.size.width = width as! CGFloat
//        })
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.hideProgress()
    }

}


extension WebViewWithBtnVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        // print("SlideMenuControllerDelegate: leftWillOpen")
    }
}

//extension WebViewWithBtnVC : UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return nil
//    }
//}
