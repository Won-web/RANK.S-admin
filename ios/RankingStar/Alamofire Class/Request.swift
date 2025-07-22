//
//  Request.swift
//  HafoosCRM
//
//  Created by etech-9 on 22/11/19.
//  Copyright © 2019 Tushar S. All rights reserved.
//

import UIKit

class Request: NSObject {
    var dictParamValues : [String:Any] = [:]
    var dictHeaderValues : [String : String] = [:]
    var dictQueryValues : [String : String] = [:]
    
    func setDefaultHeaderParamWithoutLogin() {
        
        let username = "ranking-star"
        let password = "b4bca6aa25828cf702d06cbc9656d4e3"
        let base64encoded =  Util.getBase64EncodedString(username: username, password: password)
        
        self.dictHeaderValues["Authorization"] = "Basic \(base64encoded)"
    }
    
    func setDefaultHeaderParamWithLogin() {
        
        self.dictHeaderValues["Authorization"] = "Bearer \(Util.getAccessToken())"
    }
    
    func setDefaultParameter() {
        self.dictParamValues["language"] = "LANGUAGE_DEFAULT".localizedLanguage()
        self.dictParamValues["os"] = Constant.ResponseParam.APPLICATION_OS
        self.dictParamValues["os_version"] = UIDevice.current.systemVersion
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.dictParamValues["app_version"] = appVersion
        }
        if let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            self.dictParamValues["build_version"] = buildVersion
        }
        
        self.dictParamValues["device_id"] = Util.appDelegate.uniqueDeviceId
        
    }
}
