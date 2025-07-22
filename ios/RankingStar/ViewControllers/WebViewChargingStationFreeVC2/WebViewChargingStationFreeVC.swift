//
//  WebViewChargingStationFreeVC.swift
//  RankingStar
//
//  Created by Hitarthi on 04/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit
import WebKit

class WebViewChargingStationFreeVC: BaseVC {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var objWKWebView: WKWebView!
    
    var strWebURL : String! = ""
    
    var strNavBarTitle:String! = "NAV_TITLE_STAR_CHARING_STATION"
    var isContestWebview = false
    var isNoticeDetailWebview = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setRightToLeftPinkGradientViewUI()
        navBar.setUI(navBarText: strNavBarTitle)
        self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)

       // refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
        //objWKWebView.scrollView.addSubview(refreshControl)
        objWKWebView.scrollView.bounces = true
        
        setWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.hideProgress()
        dismissAlertInfoPresenter()
    }

//    @objc func refreshWebView(_ sender: UIRefreshControl) {
//        setWebView()
//    }
    
    func setWebView() {
        isNetworkAvailable { (isSuccess) in
            if(Util.isNetworkReachable()) {
                
                var strWebURL1 = "\(Constant.API.WEB_VIEW_BASEURL)\(self.strWebURL!)"
                
                if self.isContestWebview {
                    strWebURL1 = self.strWebURL
                }
                if self.isNoticeDetailWebview {
                    strWebURL1 = self.strWebURL
                }
                
                let strTrimmedUrl = strWebURL1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: strTrimmedUrl!)
//                let webURL:URLRequest! = URLRequest(url: url!)
                let webURL:URLRequest! = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
                self.showProgress()
                self.objWKWebView.uiDelegate = self
                self.objWKWebView.navigationDelegate = self
                self.objWKWebView.configuration.preferences.javaScriptEnabled = true
                self.objWKWebView.load(webURL)
            }else {
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
    }
    
    @objc override func leftBarButtonClick() {
        if Util.isBackButtonDisable == true {
            print("Please Wait")
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension WebViewChargingStationFreeVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideProgress()
       // refreshControl.endRefreshing()
        
        let contentSize = objWKWebView.scrollView.contentSize
        let viewSize = objWKWebView.bounds.size

        let rw = Float(viewSize.width / contentSize.width)

        objWKWebView.scrollView.minimumZoomScale = CGFloat(rw)
        objWKWebView.scrollView.maximumZoomScale = CGFloat(rw)
        objWKWebView.scrollView.zoomScale = CGFloat(rw)
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.hideProgress()
        //refreshControl.endRefreshing()
    }
}

extension WebViewChargingStationFreeVC : WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {

        AlertPresenter.alertInformation(fromVC: self, message: message)
        completionHandler()

    }
}
