//
//  ETechAsyncRequest.swift
//  HafoosCRM
//
//  Created by etech-9 on 22/11/19.
//  Copyright © 2019 Tushar S. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol ETechAsyncRequestDelegate: NSObjectProtocol {
    @objc func eTechAsyncRequestDelegate(_ action: String, responseData: Response)
}

class ETechAsyncRequest: NSObject {

    var delegate: ETechAsyncRequestDelegate? = nil
    var strAction:String = String()
    
//    var pendingAction: String = String()
//    var pendingReqData: Request = Request()
    var arrPendingReqest = [PendingReqest]()
    var isTokenGenerate = false
    
    func applicaitonUpgradeCheck(responsedictionary : NSDictionary) {
        
        let response = Response()
        response.resposeObject = responsedictionary
        
        if (self.delegate?.responds(to: #selector(ETechAsyncRequestDelegate.eTechAsyncRequestDelegate(_:responseData:))))!{
            
            if let upgradeData = responsedictionary["upgrade"] as? [String:Any] {
                
                if let iosData = upgradeData["iOS"] as? [String:Any] {
                    
                    if iosData["isVersionDifferent"] as? String == "yes"{
                        
                        if iosData["forceUpdateApp"] as? String == "yes" {
//                        if iosData["forceUpdateApp"] as? String == "no" {
                            Util.setDefaultValue(data: true, key: Constant.UserDefaultKey.KEY_FORCE_UPDATE_APP)
                            Util.appDelegate.openUpgradeScreen(dicData: iosData as NSDictionary)
                        }else {
                            Util.setDefaultValue(data: false, key: Constant.UserDefaultKey.KEY_FORCE_UPDATE_APP)
                            self.isTokenGenerate = false
                            
                            if responsedictionary["res_code"] as? Int != Constant.ResponseStatus.FAIL_TOKEN {
                                self.delegate?.eTechAsyncRequestDelegate(self.strAction, responseData: response)
                                Util.appDelegate.openUpgradeScreen(dicData: iosData as NSDictionary)
                            }
                        }
                    
                    }else {
//                        self.isTokenGenerate = false
//                        if responsedictionary["res_code"] as? Int != Constant.ResponseStatus.FAIL_TOKEN {
                            self.delegate?.eTechAsyncRequestDelegate(self.strAction, responseData: response)
//                        }
                    }
                }
            }
        }
    }
    
    func saveAccessToken(responsedictionary : NSDictionary) {
        
        print("saveAccessToken Called")
        
        if let objResData = responsedictionary["res_data"] as? [String:Any] {
            
            if let objTokenData = objResData["token_data"] as? [String:Any] {
                
                let dicTokens : NSMutableDictionary = NSMutableDictionary()
                
                if let accessToken = objTokenData["access_token"] as? String {
                    
                    dicTokens["access_token"] = accessToken
                }
                if let refreshToken = objTokenData["refresh_token"] as? String {
                    
                    dicTokens["refresh_token"] = refreshToken
                }
                
                Util.setRefreshTokenData(dicTokens: dicTokens)
            }
        }
    }
    
    func getAccessTokenFromRefreshTokenAPI() {
        
        print("getAccessTokenFromRefreshToken Called")
        
        let action = Constant.API.GET_TOKEN_FROM_REFRESH_TOKEN
        
        let request: Request = Request()
        
        request.dictParamValues["grant_type"] = "refresh_token"
        request.dictParamValues["client_id"] = "ranking-star"
        request.dictParamValues["client_secret"] = "b4bca6aa25828cf702d06cbc9656d4e3"
        request.dictParamValues["refresh_token"] = Util.getRefreshToken()
        
        request.setDefaultHeaderParamWithoutLogin()
        
        let asyncRequest = ETechAsyncRequest()
        asyncRequest.delegate = AOUTHDelegate(delegate!, self)
        
        self.isTokenGenerate = true
        asyncRequest.sendPostRequest(action, requestData: request)
    }
    
    func getResponseRefreshTokenAPI(responsedictionary : NSDictionary) -> Bool {
        
        print("getResponseOfTokenFromRefreshToken Called")
        
        if let objResData = responsedictionary["res_data"] as? [String:Any] {
            
            if let objTokenDetails = objResData["token_details"] as? [String:Any] {
                
                let dicTokens : NSMutableDictionary = NSMutableDictionary()
                
                if let accessToken = objTokenDetails["access_token"] as? String {
                    
                    dicTokens["access_token"] = accessToken
                }
                if let refreshToken = objTokenDetails["refresh_token"] as? String {
                    
                    dicTokens["refresh_token"] = refreshToken
                }
                
                Util.objUserDefault.removeObject(forKey: Constant.UserDefaultKey.RS_KEY_TOKENS)
                Util.setRefreshTokenData(dicTokens: dicTokens)
                
                return true
            }
        }
        return false
//        self.sendPostRequest(pendingAction, requestData: pendingReqData)
    }
    
    //MARK: POST Request
    func sendPostRequest(_ action: String, requestData: Request) {
        
        strAction = action
        let strUrl = Constant.API.BASEURL + action
     //   requestData.dictHeaderValues = ["Content-Type":"application/x-www-form-urlencoded"]
     //   requestData.dictHeaderValues = ["Content-Type":"application/json"]
        
        printDebug("URL :" + strUrl)
        printDebug("req data : \(requestData.dictParamValues)")
        printDebug("Header data : \(requestData.dictHeaderValues)")
        
        let url = URL(string: strUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        
        Alamofire.request(strUrl, method: .post, parameters: requestData.dictParamValues, encoding: URLEncoding.default, headers: requestData.dictHeaderValues).responseJSON
        {
                (response:DataResponse<Any>) in
                
                switch(response.result) {
                    
                case .success(_):
                    printDebug("res Dic : \(String(describing: response.result.value))")
                    let responsedictionary = (response.result.value as! NSDictionary)
                    
//                    let response = Response()
//                    response.resposeObject = responsedictionary
//
//                    if (self.delegate?.responds(to: #selector(ETechAsyncRequestDelegate.eTechAsyncRequestDelegate(_:responseData:))))!{
//
//                        self.delegate?.eTechAsyncRequestDelegate(self.strAction, responseData: response)
//                    }
                    
                    if action == Constant.API.LOGIN_URL || action == Constant.API.VERIFY_SOCIAL_LOGIN {
                        // Save access token in userdefault
                        self.saveAccessToken(responsedictionary: responsedictionary)
                    }
                    
                    
                    else if responsedictionary["res_code"] as! Int == Constant.ResponseStatus.FAIL_TOKEN && action != Constant.API.GET_TOKEN_FROM_REFRESH_TOKEN {
                        
                        //Save Current API data to furthur use.
                        let objPendingReqest = PendingReqest()
                        objPendingReqest.pendingAction = action
                        objPendingReqest.pendingReqData = requestData
                        self.arrPendingReqest.append(objPendingReqest)
                        print("LOG : Pending API. \(action)")
                        
                        if self.isTokenGenerate == false {
                            // Get access token from refresh token with API
                            self.getAccessTokenFromRefreshTokenAPI()
                        }
                    }
                    
//                    if responsedictionary["res_code"] as! Int == Constant.ResponseStatus.FAIL_TOKEN &&
//                        self.isTokenGenerate == false {
//
//                        // Get access token from refresh token with API
//                        self.getAccessTokenFromRefreshTokenAPI()
//                    }
                    
                    
                    
                    self.applicaitonUpgradeCheck(responsedictionary: responsedictionary)
                    
                    break
                    
                case .failure(_):
                    printDebug("Response FAILURE : \(response.result.error)")

                    let response = Response()
                    if (self.delegate?.responds(to: #selector(ETechAsyncRequestDelegate.eTechAsyncRequestDelegate(_:responseData:))))!{
                        self.delegate?.eTechAsyncRequestDelegate(self.strAction, responseData: response)
                    }
                    break
                    // }
                }
        }
    }
    
    func pushToLoginPage() {
        Util.removeAllDataOnLogout()
        
        let objLoginVC = LoginVC()
        
        let objMainVc = MainVC()
        Util.objMainVC = objMainVc
        let navMainVC  : UINavigationController = UINavigationController(rootViewController: objMainVc)
        navMainVC.navigationController?.isNavigationBarHidden = true
        navMainVC.isNavigationBarHidden = true
        Util.currentNavigationController = navMainVC
        Util.slideMenuController.changeMainViewController(navMainVC, close: true)

        Util.currentNavigationController.pushViewController(objLoginVC, animated: true)
    }
    
    class AOUTHDelegate: NSObject, ETechAsyncRequestDelegate {
       
        var parent: ETechAsyncRequest = ETechAsyncRequest()
        var parentDelegate: ETechAsyncRequestDelegate? = nil
        var objPendingReqest = PendingReqest()
        
        convenience override init() {
            self.init(nil, nil)
        }
        
        init(_ parentDel:ETechAsyncRequestDelegate?, _ parent: ETechAsyncRequest?) {
            self.parent = parent!
            parentDelegate = parentDel
            super.init()
        }
        
        func eTechAsyncRequestDelegate(_ action: String, responseData: Response) {
            print("LOG : Authorization success")
            
            var dicResponse = [String:Any]()
//            if (responseData.resposeObject as? NSDictionary) == nil {
//
//                //Call to Parent delegate.
//                print("LOG : Call to Parent delegate.")
//                parent.isTokenGenerate = false
//
//                if (self.parentDelegate?.responds(to: #selector(ETechAsyncRequestDelegate.eTechAsyncRequestDelegate(_:responseData:))))!{
//
//                    self.parentDelegate?.eTechAsyncRequestDelegate(action, responseData: ETechAsyncRequest.getErrorResponse())
//                }
//
//            }else {
                
            if (responseData.resposeObject as? NSDictionary) != nil {
                
                dicResponse = responseData.resposeObject as! [String:Any]
                
                if dicResponse["res_code"] as! Int == Constant.ResponseStatus.SUCCESS {
                    
                    if action == Constant.API.GET_TOKEN_FROM_REFRESH_TOKEN {
                        
                        //Get response and save access and refresh token
                        print("LOG : Get response and save access and refresh token")
                        if parent.getResponseRefreshTokenAPI(responsedictionary: dicResponse as NSDictionary) {
                            
                            //Call Pending API.
                                
                            if parent.arrPendingReqest.count > 0 {
                                parent.arrPendingReqest.forEach { (objPendingAPI) in
                                    
                                    objPendingReqest = objPendingAPI
                                    
                                    print("LOG : Call Pending API. \(objPendingAPI.pendingAction)")
                                    objPendingAPI.pendingReqData.setDefaultHeaderParamWithLogin()
                                    parent.sendPostRequest(objPendingAPI.pendingAction, requestData: objPendingAPI.pendingReqData)
                                    
                                    if let index = parent.arrPendingReqest.last {
                                        
                                        parent.arrPendingReqest.removeAll()
                                    }
                                }
                            }
                        }
                    }
                }else {
                    //Refresh token expired. Push User To Login Page Forcefully.
                    print("LOG : Refresh token expired. Push User To Login Page Forcefully.")
                    parent.arrPendingReqest.removeAll()
                    parent.isTokenGenerate = false
                    self.parent.pushToLoginPage()
                }
            }
            
                
//            }
                
//                if dicResponse["res_code"] as! Int != Constant.ResponseStatus.SUCCESS {
//
//                    //Call to Parent delegate.
//                    print("LOG : Call to Parent delegate.")
//                    parent.isTokenGenerate = false
//
//                    if (self.parentDelegate?.responds(to: #selector(ETechAsyncRequestDelegate.eTechAsyncRequestDelegate(_:responseData:))))!{
//
//                        self.parentDelegate?.eTechAsyncRequestDelegate(action, responseData: ETechAsyncRequest.getErrorResponse())
//                    }
//                }
//                else {
//                    if parent.isTokenGenerate &&
//                        dicResponse["res_code"] as! Int == Constant.ResponseStatus.FAIL_TOKEN {
//
//                        //Refresh token expired. Push User To Login Page Forcefully.
//                        print("LOG : Refresh token expired. Push User To Login Page Forcefully.")
//                        parent.isTokenGenerate = false
//                        self.parent.pushToLoginPage()
//
//                    } else if action == Constant.API.GET_TOKEN_FROM_REFRESH_TOKEN {
//                        //Get response and save access and refresh token
//                        print("LOG : Get response and save access and refresh token")
//                        if parent.getResponseRefreshTokenAPI(responsedictionary: dicResponse as NSDictionary) {
//
//                            //Call Pending API.
//
//                            if parent.arrPendingReqest.count > 0 {
//                                parent.arrPendingReqest.forEach { (objPendingAPI) in
//
//                                    objPendingReqest = objPendingAPI
//
//                                    print("LOG : Call Pending API. \(objPendingAPI.pendingAction)")
//                                    objPendingAPI.pendingReqData.setDefaultHeaderParamWithLogin()
//                                    parent.sendPostRequest(objPendingAPI.pendingAction, requestData: objPendingAPI.pendingReqData)
//
//                                    if let index = parent.arrPendingReqest.last {
//
//                                        parent.arrPendingReqest.removeAll()
//                                    }
//                                }
//                            }
//                        }
//                    }else {
//
//                        //Call to Parent delegate.
//                        print("LOG : Call to Parent delegate.")
//                        parent.isTokenGenerate = false
//
//                        if (self.parentDelegate?.responds(to: #selector(ETechAsyncRequestDelegate.eTechAsyncRequestDelegate(_:responseData:))))!{
//
//                            self.parentDelegate?.eTechAsyncRequestDelegate(objPendingReqest.pendingAction, responseData: ETechAsyncRequest.getErrorResponse())
//                        }
//                    }
//                }
//            }
        }
    }
    
    public static func getErrorResponse() -> Response {
        let dicResponse : NSDictionary = [Constant.ResponseParam.RESPONSE_FLAG:Constant.ResponseStatus.FAIL,
                    Constant.ResponseParam.RESPONSE_MESSAGE : "INTERNAL_SERVER_ERROR".localizedLanguage()]
        
        let errRes = Response()
        errRes.resposeObject = dicResponse
//        appDele.viewCheckAccess.activityIndicator.stopAnimating()
        
        return errRes
    }
    
    
    func sendPostRequestWithBody(_ action: String, requestData: Request) {
            
        strAction = action
        let strUrl = Constant.API.BASEURL + action
//        requestData.dictHeaderValues = ["Content-Type":"application/x-www-form-urlencoded"]
        requestData.dictHeaderValues = ["Content-Type":"application/json"]
        
        printDebug("URL :" + strUrl)
        printDebug("req data : \(requestData.dictParamValues)")
        printDebug("Header data : \(requestData.dictHeaderValues)")
            
        let headers = [ "Content-Type": "application/json" ]
        let urlComponent = URLComponents(string: strUrl)!
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestData.dictParamValues)
        request.allHTTPHeaderFields = headers
        
        Alamofire.request(request).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
                
            case .success(_):
                printDebug("res Dic : \(String(describing: response.result.value))")
                let responsedictionary = (response.result.value as! NSDictionary)
                
                let response = Response()
                response.resposeObject = responsedictionary
                
                if (self.delegate?.responds(to: #selector(ETechAsyncRequestDelegate.eTechAsyncRequestDelegate(_:responseData:))))!{
                    self.delegate?.eTechAsyncRequestDelegate(self.strAction, responseData: response)
                }
                break
                
            case .failure(_):
                printDebug("Response FAILURE : \(response.result.error)")
                //                    if error._code == NSURLErrorTimedOut
                //                    {
                //                        GeneralUtill.appDelegate.hideProsess()
                //                        print("Time out")
                //                        break
                //                    }
                //                    else
                //                    {
                let response = Response()
                if (self.delegate?.responds(to: #selector(ETechAsyncRequestDelegate.eTechAsyncRequestDelegate(_:responseData:))))!{
                    self.delegate?.eTechAsyncRequestDelegate(self.strAction, responseData: response)
                }
                break
                // }
            }
        }
    }
    
    static let alamofireManager : SessionManager = {
        let policies:[String:ServerTrustPolicy] = ["https://zssskg8wh4.execute-api.us-east-1.amazonaws.com": .disableEvaluation]
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 60
        
        let manager = SessionManager(configuration: sessionConfiguration, serverTrustPolicyManager: ServerTrustPolicyManager(policies:policies))
        
        return manager
        
    }()
    
    func sendPostRequestWithImage(_ action:String, withImageParamName:String, image:UIImage,requestData: Request) {
        
//        _ parameters : [String:Any], _ strUrl : String, image : UIImage
        
        strAction = action
        let strUrl = Constant.API.BASEURL + action
       // let refURL = action
        printDebug("URL :" + strUrl)
        printDebug("req data : \(requestData.dictParamValues)")
        
       // requestData.dictHeaderValues = ["Content-Type":"application/json"]
        
//        if let refURL = URL(string: "\(Constants.BASE_URL)\(strUrl)")! {
            
            ETechAsyncRequest.alamofireManager.startRequestsImmediately = true
            ETechAsyncRequest.alamofireManager.upload(multipartFormData: { multiPartFormData in
                
                if let imageData = image.jpegData(compressionQuality: 0.6) {
                    multiPartFormData.append(imageData, withName: "\(withImageParamName)", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
                
                for (key, value) in requestData.dictParamValues {
                    if let value = value as? String {
                        multiPartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            },
             to: strUrl,
             method: .post,
             headers: requestData.dictHeaderValues,
             encodingCompletion: { encodingResult in
                switch encodingResult {

                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        printDebug("Upload Progress : \(progress.fractionCompleted)")
                    })
                    
                    upload.responseString { response in
                        
                        switch(response.result) {
                            
                        case .success(_):
                            
                            printDebug("res Dic : \(String(describing: response.result.value))")
                           // let responsedictionary = (response.result.value as! NSDictionary)
                            let response = Response()
                            
                                response.resposeObject =  ["res_code":1] //["res_code":1]//responsedictionary
                            if (self.delegate?.responds(to: #selector(ETechAsyncRequestDelegate.eTechAsyncRequestDelegate(_:responseData:))))!{
                                self.delegate?.eTechAsyncRequestDelegate(self.strAction, responseData: response)
                            }
                            break
                        case .failure(_):
                            
                          //  printDebug("Response FAILURE : \(response.result.error)")
                            let response = Response()
                            response.resposeObject = ["res_code":0]
                            if (self.delegate?.responds(to: #selector(ETechAsyncRequestDelegate.eTechAsyncRequestDelegate(_:responseData:))))!{
                                self.delegate?.eTechAsyncRequestDelegate(self.strAction, responseData: response)
                            }
                            break
                        }
                        
//                        if response.result.isSuccess {
//                            printDebug(response.debugDescription)
//
//                            if let jsonDictioanry = response.result.value as? [String:Any] {
//                                printDebug("AsyncRequestHelper image upload jsonDictioanry \(jsonDictioanry)")
//
//                                self.delegate.sendData(response: jsonDictioanry, url: strAction)
//                            }
//
//                        }else{
//                            printDebug(response.error?.localizedDescription)
//                        }
                    }
                    break
                    
                case .failure(let encodingError):
                    printDebug(encodingError)
                }
            })
            
//        }else {
//            printDebug("Something went wrong")
//        }s
        
    }
    
/*    func sendImageUploadData(_ parameters : [String:Any], _ strUrl : String, image : UIImage, withImageParamName:String) {
        
        if let refURL : URL = URL(string: Constant.API.BASEURL + strUrl)! {
            
            ETechAsyncRequest.alamofireManager.startRequestsImmediately = true
            ETechAsyncRequest.alamofireManager.upload(multipartFormData: { multiPartFormData in

                if let imageData = image.jpegData(compressionQuality: 0.6) {
                    multiPartFormData.append(imageData, withName: withImageParamName, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
                
                for (key, value) in parameters {
                    if let value = value as? String {
                        multiPartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            },
             to: refURL,
             method: .post,
             encodingCompletion: { encodingResult in
                switch encodingResult {

                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress : \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        if response.result.isSuccess {
                            print(response.debugDescription)
                            
                            if let jsonDictioanry = response.result.value as? [String:Any] {
                                print("AsyncRequestHelper image upload jsonDictioanry \(jsonDictioanry)")
                                
                                //self.delegate.sendData(response: jsonDictioanry, url: strUrl)
                                let response = Response()
                                if (self.delegate?.responds(to: #selector(ETechAsyncRequestDelegate.eTechAsyncRequestDelegate(_:responseData:))))!{
                                    self.delegate?.eTechAsyncRequestDelegate(strUrl, responseData: response)
                                }
                            }
                            
                        }else{
                            print(response.error?.localizedDescription)
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
            })
            
        }else {
            print("Something went wrong")
        }
        
    }
    */
    
  /*  func sendPostRequestWithImage1(_ action:String, withImageParamName:String, image:UIImage,requestData: Request){

        strAction = action
//        let strUrl = Constant.API.BASEURL + action
        
        let strUrl = action
        requestData.dictHeaderValues = ["Content-Type":"application/json"]

        printDebug("URL :" + strUrl)

        printDebug("req data : \(requestData.dictParamValues)")
        printDebug("req data : \(requestData.dictHeaderValues)")
        printDebug("image : \(image)")


        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImage().jpegData(compressionQuality: 0.6) {
                //            if let imageData = UIImageJPEGRepresentation(image, 1) {
                //multipartFormData.append(imageData, withName: "file", fileName: "111.jpeg", mimeType: "image/jpeg")
                multipartFormData.append(imageData, withName: withImageParamName)
                //multipartFormData.append(imageData, withName: "\(withImageParamName)", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }

            for (key, value) in requestData.dictParamValues {

                multipartFormData.append(((value as! String).data(using: .utf8))!, withName: key)
            }}, to: strUrl, method: .post, headers: requestData.dictHeaderValues,
                encodingCompletion: { encodingResult in

                    switch encodingResult {

                    case .success(let upload, _, _):

                        upload.uploadProgress(closure: { (progress) in
                            printDebug("porgressss  : \(progress.fractionCompleted)")
                        })

                        upload.responseString { response in

                            switch(response.result) {

                            case .success(_):
                                printDebug("res Dic : \(response.result.value)")
                                let responsedictionary = (response.result.value as! NSDictionary)
//
                                let response = Response()
                                response.resposeObject = responsedictionary

                                if (self.delegate?.responds(to: #selector(ETechAsyncRequestDelegate.eTechAsyncRequestDelegate(_:responseData:))))!{
                                    self.delegate?.eTechAsyncRequestDelegate(self.strAction, responseData: response)
                                }
                                break

                            case .failure(_):
                                printDebug("Response FAILURE : \(response.result.error)")
                                let response = Response()
                                response.resposeObject = ["flag":0]
                                if (self.delegate?.responds(to: #selector(ETechAsyncRequestDelegate.eTechAsyncRequestDelegate(_:responseData:))))!{
                                    self.delegate?.eTechAsyncRequestDelegate(self.strAction, responseData: response)
                                }
                                break

                            }
                        }
                        break

                    case .failure(let encodingError):
                        printDebug(encodingError.localizedDescription)
                        break
                    }
        })
    }*/

    
   
}

