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

class TearmAndConditionVC: BaseVC {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var objWKWebView: WKWebView!
    var strWebURL:String! = "\(Constant.API.BASEURL)\(Constant.API.TERMS_OF_USE_AND_PRIVACY_POLICY_WEBVIEW)"
    var strNavBarTitle:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
//        objWKWebView.navigationDelegate = self
//        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
//        objWKWebView.scrollView.addSubview(refreshControl)
        objWKWebView.scrollView.bounces = true
        setNavigationAndUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Util.statusBarColor(color: UIColor.white,statusLight: false,isGradient: false)
        setWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.hideProgress()
        Util.statusBarColor(color: UIColor.clear)
        dismissAlertInfoPresenter()
    }
    
    // MARK: - set Navigation UI
    func setNavigationAndUI() {
        navBar.setNavWhiteUI(navBarText: strNavBarTitle)
        self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc override func rightBtnClickedWithImg() {
        // push charging station
    }
    
    @objc func refreshWebView(_ sender: UIRefreshControl) {
//        objWKWebView.load(webURL)
//        sender.endRefreshing()
    }
    
}

extension TearmAndConditionVC: WKNavigationDelegate {

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

extension TearmAndConditionVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        // printDebug("SlideMenuControllerDelegate: leftWillOpen")
    }
}
