//
//  ChargingStationNewFreeVC.swift
//  RankingStar
//
//  Created by Hitarthi on 15/04/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit
import WebKit

class ChargingStationNewFreeVC: BaseVC {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cnsNavBarHeight: NSLayoutConstraint!
    
    var strWebURL : String! = ""
    var objWKWebView1:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.setRightToLeftPinkGradientViewUI()
        loadWebview()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissAlertInfoPresenter()
    }
    
    func loadWebview() {
        let contentController = WKUserContentController();
        contentController.add(self, name: "callbackHandler")
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        objWKWebView1 = WKWebView(frame: mainView.frame, configuration: config)
        //        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
        objWKWebView1.navigationDelegate = self
        self.objWKWebView1.uiDelegate = self
        self.objWKWebView1.frame = self.mainView.bounds
        self.objWKWebView1.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        
        //        objWKWebView1.scrollView.addSubview(refreshControl)
        objWKWebView1.scrollView.bounces = true
        
        mainView.addSubview(objWKWebView1)
        
        cnsNavBarHeight.constant = 0
        
        loadUrlWithClickHandler()
    }
    
    func loadUrlWithClickHandler() {
        
        isNetworkAvailable { (isSuccess) in
            let strWebURL1:String! = "\(Constant.API.WEB_VIEW_BASEURL)\(self.strWebURL!)"
            let strTrimmedUrl = strWebURL1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: strTrimmedUrl!)
//            let webURL : URLRequest = URLRequest(url: url!)
            let webURL:URLRequest! = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
            self.objWKWebView1.configuration.preferences.javaScriptEnabled = true
            self.objWKWebView1.load(webURL)
        }
    }
}

extension ChargingStationNewFreeVC : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideProgress()
        //        refreshControl.endRefreshing()
        
        let contentSize = objWKWebView1.scrollView.contentSize
        let viewSize = objWKWebView1.bounds.size
        
        let rw = Float(viewSize.width / contentSize.width)
        
        objWKWebView1.scrollView.minimumZoomScale = CGFloat(rw)
        objWKWebView1.scrollView.maximumZoomScale = CGFloat(rw)
        objWKWebView1.scrollView.zoomScale = CGFloat(rw)
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.hideProgress()
        //        refreshControl.endRefreshing()
    }
}

extension ChargingStationNewFreeVC : WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("messageBody : \(message.body)")
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChargingStationNewFreeVC : WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        AlertPresenter.alertInformation(fromVC: self, message: message)
        completionHandler()
    }
}
