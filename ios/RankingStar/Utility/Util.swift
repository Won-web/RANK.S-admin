//
//  Util.swift
//  HafoosCRM
//
//  Created by etech-9 on 22/11/19.
//  Copyright © 2019 Tushar S. All rights reserved.
//

import UIKit
import Reachability
import Kingfisher
import SystemConfiguration.CaptiveNetwork
import ZVProgressHUD
import SlideMenuControllerSwift
import Material
import AVKit
import AVFoundation
import Parchment
import GTProgressBar

func printDebug(_ log : Any) {
    print(log)
}

//public enum oauthInrgration {
//    case ContestList
//    case ContestantList
//}

var rechability = try! Reachability()

class Util: NSObject {
    
    static let CONST_STAUS_TAG = 38482458385
    
    static let applicationName = "APP_NAME".localizedLanguage()
    static let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    static var sideMenuNavVC : UINavigationController!
    static var slideMenuController : ExSlideMenuController!
    static var objMainVC : MainVC!
    static let appDelegate : AppDelegate =  UIApplication.shared.delegate as! AppDelegate
    static let objUserDefault = UserDefaults.standard
    static var currentNavigationController:UINavigationController!
//    static var isUpdateVCShow = false
    static var objUpdateAppVC : UpdateAppVC!
    
    static var isBackButtonDisable : Bool = false
    static var isDeleteAccBtnTapped : Bool = false
    
    static func statusBarColor(color : UIColor, statusLight : Bool? = true, isGradient : Bool? = true) {
       let statusBar: UIView? = UIApplication.shared.statusBarUIView
        if (statusBar?.responds(to:#selector(setter: UIView.backgroundColor)))! {
            statusBar?.backgroundColor = color
//            if(isGradient == true && color != UIColor.clear)
//            {
//                statusBar?.setRightToLeftPinkGradientViewUI()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    statusBar?.setRightToLeftPinkGradientViewUI(isClearColor: true)
//                }
//            }else
//            {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    statusBar?.setRightToLeftPinkGradientViewUI(isClearColor: true)
//                }
//               //statusBar?.setRightToLeftPinkGradientViewUI(isClearColor: true)
//            }
            if(statusLight!)
            {
                UIApplication.shared.statusBarStyle = .lightContent
            }else
            {
                UIApplication.shared.statusBarStyle = .default
            }
            
        }
    }
    
    static func setStatusBarHide(isHidden : Bool) {
        UIApplication.shared.statusBarUIView?.isHidden = isHidden
        UIApplication.shared.setStatusBarHidden(isHidden, with: .fade)
    }
    
    static func showLoading() {
        ZVProgressHUD.show()
    }
    
    static func hideLoading() {
        ZVProgressHUD.dismiss()
    }
    
    static func isNetworkReachable() -> Bool {
        return (rechability!.isReachable)
    }
    
   
    
    static func setDefaultValue(data: Any,key : String) {
        let userDefault = UserDefaults.standard
        userDefault.set(data, forKey: key)
        userDefault.synchronize()
    }
    
    static func getDefaultValue(key : String) -> Any? {
        let userDefault = UserDefaults.standard
        if userDefault.value(forKey: key) == nil {
            return nil
        } else {
            return userDefault.value(forKey: key) as Any
        }
    }
    
    static func setDeviceID() {
        let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString
        print("identifierForVendor: ", identifierForVendor!)
        let data = identifierForVendor!.data(using: .utf8)
        let status = KeyChain.save(key: Constant.UserDefaultKey.UNIQUE_DEVICE_ID, data: data!)
        print("status: ", status)
    }
    
    static func getDeviceID() -> String {
        
        var deviceID : String = ""
        if let receivedData = KeyChain.load(key: Constant.UserDefaultKey.UNIQUE_DEVICE_ID) {
            deviceID = String(decoding: receivedData, as: UTF8.self)
            print("getDeviceID > deviceID: ", deviceID)
        }
        
        return deviceID
//        return "3D60FB88-0E68-4EBC-B072-554D6121D145"
    }
    
    static func getIsUserLoginWithFacebook() -> String
    {
        if let value:String = getDefaultValue(key : Constant.UserDefaultKey.KEY_IS_USER_LOGIN_WITH_FACEBOOK) as? String
        {
            return value
        }else
        {
           return "0"
        }
    }
    
    static func setIsUserLoginWithFacebook(strValue:String)
    {
        setDefaultValue(data: strValue,key: Constant.UserDefaultKey.KEY_IS_USER_LOGIN_WITH_FACEBOOK)
    }
    
    static func getIsUserAutoLogin() -> String
    {
        if let value:String = getDefaultValue(key : Constant.UserDefaultKey.KEY_IS_USER_AUTO_LOGIN) as? String
        {
            return value
        }else
        {
           return "0"
        }
    }
    
    static func setIsUserAutoLogin(strValue:String)
    {
        setDefaultValue(data: strValue,key: Constant.UserDefaultKey.KEY_IS_USER_AUTO_LOGIN)
    }
    
    
    static func getIsUserLogin() -> String
    {
        if let value:String = getDefaultValue(key : Constant.UserDefaultKey.KEY_IS_USER_EMAIL_LOGIN) as? String
        {
            return value
        }else
        {
           return "0"
        }
    }
    
    static func setIsUserLogin(strValue:String)
    {
        setDefaultValue(data: strValue,key: Constant.UserDefaultKey.KEY_IS_USER_EMAIL_LOGIN)
    }
    
    static func getIsUserLoginType() -> String
    {
        if let value:String = getDefaultValue(key : Constant.UserDefaultKey.KEY_LOGIN_TYPE) as? String
        {
            return value
        }else
        {
            return Constant.ResponseParam.LOGIN_TYPE_AUTH
        }
    }
    
    static func setIsUserLoginType(strValue:String)
    {
        setDefaultValue(data: strValue,key: Constant.UserDefaultKey.KEY_LOGIN_TYPE)
    }
    
    static func getUserProfileDict() -> [String:Any]?
    {
        if let value:[String:Any] = getDefaultValue(key : Constant.UserDefaultKey.KEY_USER_PROFILE_DICT) as? [String:Any]
        {
            return value
        }else
        {
            return nil
        }
    }
    
    static func setUserProfileDict(strValue:[String:Any])
    {
        setDefaultValue(data: strValue,key: Constant.UserDefaultKey.KEY_USER_PROFILE_DICT)
    }
    
    static func getAccessToken() -> String {
        var accessToken = ""
        
        if let dicToken : NSDictionary =
            Util.getDefaultValue(key: Constant.UserDefaultKey.RS_KEY_TOKENS) as? NSDictionary {
            
            accessToken = dicToken["access_token"] as! String
        }
        
        return accessToken
    }
    
    static func getRefreshToken() -> String {
        var refreshToken = ""
        
        if let dicToken : NSDictionary =
            Util.getDefaultValue(key: Constant.UserDefaultKey.RS_KEY_TOKENS) as? NSDictionary {
            
            refreshToken = dicToken["refresh_token"] as! String
        }
        
        return refreshToken
    }
    
    static func setRefreshTokenData(dicTokens : NSDictionary) {
        Util.setDefaultValue(data: dicTokens, key: Constant.UserDefaultKey.RS_KEY_TOKENS)
    }
    
    static func getBase64EncodedString(username : String, password : String) -> String {
        return "\(username):\(password)".data(using: .isoLatin1)?.base64EncodedString() ?? ""
    }
    
    
    static func circleImage(image : UIImageView, borderColor : UIColor) {
        image.layer.borderWidth = 0.5
        image.layer.masksToBounds = false
        image.layer.borderColor = borderColor.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    
    static func isValidEmail(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            printDebug("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    static func intToNumberFormat(intValue:Int) -> String
    {
        return String(format: "%ld", locale: Locale.current, intValue)
    }
    
    static func removeAllDataOnLogout()
    {
        Util.setIsUserLogin(strValue: "0")
        Util.setIsUserAutoLogin(strValue: "0")
        Util.setUserProfileDict(strValue: ["":""])
    }
    
     static func getLblWidth(label: UILabel) -> CGFloat {

    //        let constraint = CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
            let constraint = CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.frame.size.height)
            var size: CGSize
            let context = NSStringDrawingContext()

        let boundingBox: CGSize? = label.text?.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: context).size
            size = CGSize(width: ceil((boundingBox?.width)!), height: ceil((boundingBox?.height)!))
        return size.width
    }
    
    static func getLblHeight(label: UILabel,lblWidth:CGFloat = 10) -> CGFloat {
        
       // let constraint = CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let constraint = CGSize(width: lblWidth, height: CGFloat.greatestFiniteMagnitude)
        var size: CGSize
        let context = NSStringDrawingContext()
        
        let boundingBox: CGSize? = label.text?.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: context).size
        size = CGSize(width: ceil((boundingBox?.width)!), height: ceil((boundingBox?.height)!))
        return size.height
    }
    
    static func convertDateFormat(date : String, dateFormat : String, newDateFormat : String) -> String! {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        let newFormat = DateFormatter()
        newFormat.dateFormat = newDateFormat
        
        if let date = formatter.date(from: date){
            return newFormat.string(from: date)
        }else{
            return nil
        }
    }
    
    static func ConvertStringToDate(dateString : String, dateFormat : String) -> Date {
        
//        let dateString = "Thu, 22 Oct 2015 07:45:17 +0000"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
//        dateFormatter.locale = Locale.init(identifier: "en_GB")

        let dateObj = dateFormatter.date(from: dateString)

        dateFormatter.dateFormat = dateFormat
        print("Dateobj: \(dateFormatter.string(from: dateObj!))")
        
        return dateObj!
    }
    
    static func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    static func image(with sourceImage: UIImage?, scaledToHeight i_height: Float) -> UIImage? {
        let oldHeight = Float(sourceImage?.size.height ?? 0.0)
        let scaleFactor = i_height / oldHeight
        
        let newWidth = Float((sourceImage?.size.width ?? 0.0) * CGFloat(scaleFactor))
        let newHeight = oldHeight * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width: CGFloat(75), height: CGFloat(newHeight)))
        sourceImage?.draw(in: CGRect(x: 0, y: 0, width: CGFloat(newWidth), height: CGFloat(newHeight)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
//    func image1(with sourceImage: UIImage?, scaledToWidth i_width: Float) -> UIImage? {
//        let oldWidth = Float(sourceImage?.size.width ?? 0.0)
//        let scaleFactor = i_width / oldWidth
//
//        let newHeight = Float((sourceImage?.size.height ?? 0.0) * CGFloat(scaleFactor))
//        let newWidth = oldWidth * scaleFactor
//
//        UIGraphicsBeginImageContext(CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight)))
//        sourceImage?.draw(in: CGRect(x: 0, y: 0, width: CGFloat(newWidth), height: CGFloat(newHeight)))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
    
    func scheduleNotification() {
            let center = UNUserNotificationCenter.current()

            let content = UNMutableNotificationContent()
            
            content.title = "progress 10%"
            content.body = "The early bird catches the worm, but the second mouse gets the cheese."
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.default

    //        var dateComponents = DateComponents()
    //        dateComponents.hour = 10
    //        dateComponents.minute = 30
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.removeAllPendingNotificationRequests()
            center.add(request)
        }
}

extension String {
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        return emailTest.evaluate(with: self)
    }
    
    func isValidePhone() -> Bool
    {
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func localizedLanguage() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = Util.CONST_STAUS_TAG
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        if let slide = viewController as? SlideMenuController {
            return topViewController(slide.mainViewController)
        }
        return viewController
    }
}

extension UINavigationBar {
    
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
    
    func setNavWhiteUI(navBarText : String) {
      
        Util.statusBarColor(color: UIColor.white)
        self.barTintColor = UIColor.white
        
        self.topItem?.title = navBarText.localizedLanguage()
        self.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : Constant.Color.TEXT_BLACK_COLOR,
            NSAttributedString.Key.font : Constant.Font.NAVIGATIONBAR_TEXT
        ]
        self.isTranslucent = false
    }
    
    func setUI(navBarText : String, isBlack:Bool = false) {
      
        if(isBlack == true)
        {
           // Util.statusBarColor(color: Constant.Color.NAVIGATION_BAR_BG_BLACK_COLOR)
            self.barTintColor = Constant.Color.NAVIGATION_BAR_BG_BLACK_COLOR
        }else
        {
            Util.statusBarColor(color: UIColor.white)
            //self.barTintColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
//            let uiImage = UIImageView(image: UIImage(named: Constant.Image.nav_gradient_pink)) ////
            //uiImage.setFitImageInImageView()
//            self.setBackgroundImage(uiImage.image, for: .default) /////
           // self.setBackgroundImage(self.setRightToLeftNavPinkGradientViewUI(), for: .default)
        }
        
        
        let imageView = UIImageView(image:UIImage(named: Constant.Image.logo_kor))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        let imageViewTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.navTitleTapped))
//        imageViewTabbed.intIndex = indexPath.row
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageViewTabbed)
        
        //self.navigationItem.titleView = imageView
        self.topItem?.titleView = imageView
        
        
       // self.topItem?.title = navBarText.localizedLanguage()
        self.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : Constant.Color.NAVIGATIONBAR_TEXT_COLOR,
            NSAttributedString.Key.font : Constant.Font.NAVIGATIONBAR_TEXT
        ]
        self.isTranslucent = false
        
    }
    
    @objc func navTitleTapped() {
        
        if Util.isBackButtonDisable == false {
            let objMainVc = MainVC()
            Util.objMainVC = objMainVc
            let navMainVC  : UINavigationController = UINavigationController(rootViewController: objMainVc)
            navMainVC.navigationController?.isNavigationBarHidden = true
            navMainVC.isNavigationBarHidden = true
            Util.currentNavigationController = navMainVC
            Util.slideMenuController.changeMainViewController(navMainVC, close: true)
        }
    }
    
    func setLeftNavUI(navBarText : String) {
     //   Util.statusBarColor(color: Constant.Color.NAVIGATION_BAR_BG_COLOR)
        self.barTintColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        
       // self.topItem?.title = navBarText.localizedLanguage()
        let objLabel = UILabel()
        objLabel.text = navBarText.localizedLanguage()
        objLabel.font = Constant.Font.NAVIGATIONBAR_TEXT
        objLabel.textColor = Constant.Color.NAVIGATIONBAR_TEXT_COLOR
        objLabel.sizeToFit()
        self.topItem?.leftBarButtonItem = UIBarButtonItem(customView: objLabel)
//        self.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor : Constant.Color.NAVIGATIONBAR_TEXT_COLOR,
//            NSAttributedString.Key.font : Constant.Font.NAVIGATIONBAR_TEXT
//        ]
        self.isTranslucent = false
    }
    
    func setForgotPasswordUI(navBarText : String) {
       // Util.statusBarColor(color: Constant.Color.NAVIGATIONBAR_TEXT_COLOR)
        self.topItem?.title = navBarText.localizedLanguage()
        self.barTintColor = Constant.Color.NAVIGATIONBAR_TEXT_COLOR
        
        self.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : Constant.Color.NAVIGATION_BAR_BG_COLOR,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20.0)
        ]
        self.isTranslucent = false
    }
}

extension UIViewController {
    
    func showAlert(msg: String) -> Void {
        
        let strMsg = msg.localizedLanguage()
        let alertController = UIAlertController(title: Util.applicationName, message: strMsg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ALERT_BTN_OK".localizedLanguage() , style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertOk(msg: String, alertBtnAction : @escaping (_ btnTapped : Bool) -> Void ) -> Void {
        
        let strMsg = msg.localizedLanguage()
        let alertController = UIAlertController(title: Util.applicationName, message: strMsg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ALERT_BTN_OK".localizedLanguage(), style: .default) { (alert) in
            alertBtnAction(true)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertOkCancel(msg: String, alertBtnAction : @escaping (_ btnTapped : Bool) -> Void ) -> Void {
        
        let strMsg = msg.localizedLanguage()
        let alertController = UIAlertController(title: Util.applicationName, message: strMsg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ALERT_BTN_OK".localizedLanguage(), style: .default) { (alert) in
            alertBtnAction(true)
        }
        let CancelAction = UIAlertAction(title: "ALERT_BTN_CANCEL".localizedLanguage(), style: .cancel) { (alert) in
            alertBtnAction(false)
        }
        alertController.addAction(OKAction)
        alertController.addAction(CancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    
//    func showLoadingView(viewForLoading : UIView)
//        {
//            self.view.addSubview(viewForLoading)
////    //        appDelegate.window?.addSubview(viewForLoading)
////    //        viewForLoading.backgroundColor = UIColor.red
////            SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: -64))
////            SVProgressHUD.setDefaultMaskType(.none)
////            SVProgressHUD.setContainerView(viewForLoading)
////    //        SVProgressHUD.setContainerView(appDelegate.window)
////            SVProgressHUD.show()
//            Util.showLoading()
//        }
//        
//        func hideLoadingView(viewForLoading : UIView)
//        {
//            viewForLoading.removeFromSuperview()
////            SVProgressHUD.setContainerView(nil)
////            SVProgressHUD.dismiss()
//            Util.hideLoading()
//        }
}

extension UIView
{
    @available(iOS 13.0, *)
    @objc var scene: UIScene? {
        return window?.windowScene
    }
    
    func setCurveShape()
    {
        self.clipsToBounds = false
        self.layer.cornerRadius = self.frame.size.width/8
        self.clipsToBounds = true
        self.layoutIfNeeded()
        self.updateFocusIfNeeded()
    }
    
    func rundViewWithBorderColor()
    {
        self.clipsToBounds = false
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 2
        self.borderColor = Constant.Color.VIEW_BORDER_COLOR
        self.clipsToBounds = true
        self.layoutIfNeeded()
        self.updateFocusIfNeeded()
    }
    
    func roundViewColor()
    {
        self.backgroundColor = UIColor.white
        self.clipsToBounds = false
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
        self.layoutIfNeeded()
        self.updateFocusIfNeeded()
    }
    
    func rundViewForBtnFacebook()
    {
        self.clipsToBounds = false
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }
    
    
    func rundViewWithBorderColorPink()
    {
        self.clipsToBounds = false
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 1
        self.borderColor = Constant.Color.VIEW_BORDER_PINK_COLOR
        self.clipsToBounds = true
        self.layoutIfNeeded()
        self.updateFocusIfNeeded()
    }
    
    func rectViewWithBorderColor()
    {
        self.clipsToBounds = false
        self.layer.borderWidth = 1
        self.borderColor = Constant.Color.LIGHT_GREY
        self.clipsToBounds = true
        self.layoutIfNeeded()
        self.updateFocusIfNeeded()
    }
    
    func rundViewWithBorderColorSemiGray()
    {
        self.clipsToBounds = false
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 2
        self.borderColor = Constant.Color.VIEW_SEMI_GRAY_BORDER_COLOR
        self.clipsToBounds = true
        self.layoutIfNeeded()
        self.updateFocusIfNeeded()
    }
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Constant.Color.BTN_GREDIENT_PINK_LEFT.cgColor, Constant.Color.BTN_GREDIENT_PINK_RIGHT.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

       layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @discardableResult
    func setGradientBackground1() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Constant.Color.BTN_GREDIENT_PINK_LEFT.cgColor, Constant.Color.BTN_GREDIENT_PINK_RIGHT.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

       layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setCardStyleView(_ cornerRadius : CGFloat? = 0.0) {
        self.layer.cornerRadius = cornerRadius!
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowColor = Constant.Color.LIGHT_GREY.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.7
    }
    
    func setCardStyleWithShadowView(_ cornerRadius : CGFloat? = 0.0) {
        self.layer.cornerRadius = cornerRadius!
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.3
    }

    func setTopToBottomPinkGradientViewUI()
    {
           // self.backgroundColor = UIColor.clear
//        let objGradientView = GradientView()
//        let gradient = objGradientView.gradient
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [Constant.Color.BTN_GREDIENT_PINK_RIGHT.cgColor, Constant.Color.BTN_GREDIENT_PINK_LEFT.cgColor]
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        gradient.frame = self.bounds
//        gradient.frame = CGRect(x: 0, y: 0, width: self.frame.width + 200, height: self.frame.height)
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
//            gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        gradient.cornerRadius = self.frame.height/2
        
        
        self.layer.insertSublayer(gradient, at: 0)
        CATransaction.commit()
    }
    
    func setLeftToRightPinkGradientViewUI()
    {
           // self.backgroundColor = UIColor.clear
//        let objGradientView = GradientView()
//        let gradient = objGradientView.gradient
        let gradient: CAGradientLayer = CAGradientLayer()

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        gradient.colors = [Constant.Color.BTN_GREDIENT_PINK_RIGHT.cgColor, Constant.Color.BTN_GREDIENT_PINK_LEFT.cgColor]
        gradient.frame = self.bounds
//        gradient.frame = CGRect(x: 0, y: 0, width: self.frame.width + 200, height: self.frame.height)
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
//            gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        gradient.cornerRadius = self.frame.height/2
        
        self.layer.insertSublayer(gradient, at: 0)
        CATransaction.commit()
    }
    
    func setRightToLeftNavPinkGradientViewUI() -> UIImage
    {
           // self.backgroundColor = UIColor.clear
        let objGradientView = GradientView(frame: self.bounds)
        objGradientView.layoutSubviews()
       // let gradient = objGradientView.gradient
       // objGradientView.setupGradientView()
//        let gradient: CAGradientLayer = CAGradientLayer()

//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
//
//        gradient.colors = [Constant.Color.BTN_GREDIENT_PINK_LEFT.cgColor, Constant.Color.BTN_GREDIENT_PINK_RIGHT.cgColor]
//        gradient.frame = self.bounds
////        gradient.frame = UIScreen.main.bounds
//
//       // gradient.frame = CGRect(x: 0, y: 0, width: self.frame.width + 200, height: self.frame.height)
//        gradient.locations = [0.0 , 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
////            gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
//       // gradient.cornerRadius = self.frame.height/2
//
//       // self.layer.insertSublayer(gradient, at: 0)
//        CATransaction.commit()
        return self.image(fromLayer: objGradientView.gradient)
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
    func setRightToLeftPinkGradientViewUI(isClearColor:Bool? = false, isColorPink : Bool? = false)
        {
            Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
            
            if isColorPink! {
                let objUIImageView = UIImageView(image: UIImage(named: Constant.Image.nav_gradient_pink))
                self.insertSubview(objUIImageView, at: 0)
                objUIImageView.setFitImageInImageView()
            }
            
//            let objUIImageView = UIImageView(image: UIImage(named: Constant.Image.nav_gradient_pink))
//            self.insertSubview(objUIImageView, at: 0)
//            objUIImageView.setFitImageInImageView()
            
//            self.backgroundColor = UIColor.clear
//            let gradient: CAGradientLayer = CAGradientLayer()
//
//            if(isClearColor!)
//            {
//                gradient.colors = [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.white.withAlphaComponent(0.0).cgColor]
//            }else
//            {
//                gradient.colors = [Constant.Color.BTN_GREDIENT_PINK_RIGHT.cgColor, Constant.Color.BTN_GREDIENT_PINK_LEFT.cgColor]
//            }
//            CATransaction.begin()
//            CATransaction.setDisableActions(true)
//            gradient.frame = self.bounds
//            gradient.locations = [0.0 , 1.0]
//            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
//            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
//           // gradient.cornerRadius = self.frame.height/2
//            self.layer.insertSublayer(gradient, at: 0)
//            CATransaction.commit()
        }
    
//    func setLeftToRightGrayGradientViewUI()
//    {
//           // self.backgroundColor = UIColor.clear
//        let gradient: CAGradientLayer = CAGradientLayer()
//
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
//        gradient.colors = [Constant.Color.BTN_GREDIENT_GRAY_RIGHT.cgColor, Constant.Color.BTN_GREDIENT_GRAY_LEFT.cgColor]
//        gradient.frame = self.bounds
////        gradient.frame = CGRect(x: 0, y: 0, width: self.frame.width + 200, height: self.frame.height)
//        gradient.locations = [0.0 , 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
////            gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
//        gradient.cornerRadius = self.frame.height/2
//
//        self.layer.insertSublayer(gradient, at: 0)
//        CATransaction.commit()
//    }
    
}

extension UICollectionView {
    
    func setCollectionViewshadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = Constant.Color.LIGHT_GREY.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowRadius = 4
    }
    func setCollectionViewshadow1() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = Constant.Color.LIGHT_GREY.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowRadius = 4
    }
}

extension FixedPagingViewController {
  
    func setFixedPageVCUI() {
        setFixedPageVCUI(txtColor: UIColor.white, selectedTxtColor: UIColor.white, tabBarColor: UIColor.white, indicatorColor : UIColor.white)
    }
    
    func setFixedPageVCUI(txtColor : UIColor , selectedTxtColor : UIColor , tabBarColor : UIColor, indicatorColor : UIColor) {
       self.indicatorOptions = .hidden
        self.menuInteraction = .none
        self.contentInteraction = .none
        self.selectedTextColor = selectedTxtColor
        self.textColor = txtColor
        self.selectedFont = Constant.Font.LBL_HEADER_TEXT_REG!
        
        self.font = Constant.Font.LBL_HEADER_TEXT_REG!
        self.indicatorColor = UIColor.clear
        self.selectedBackgroundColor = tabBarColor
        self.menuBackgroundColor = Constant.Color.LBL_WHITE
//        self.backgroundColor = UIColor.white
        setFixedPageMenuSizeVCUI(menuSize:50)
        
        
    }
    func setFixedPageMenuSizeVCUI(menuSize:CGFloat) {
        self.menuItemSize = .sizeToFit(minWidth: 150, height: menuSize)
    }
    
    
}

//struct Number {
//    static let withSeparator: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.groupingSeparator = "," // or possibly "." / ","
//        formatter.numberStyle = .decimal
//        return formatter
//    }()
//}

extension Int {
//    var stringWithSepator: String {
//        return Number.withSeparator.string(from: NSNumber(value: hashValue)) ?? ""
//    }
    
    func stringWithSepator(amount : Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current

//        let amount = 2358000
        let formattedString = formatter.string(for: amount)
       // print(String(describing: formattedString))
        
        return formattedString!
    }
}


extension UIButton
{
    func adjustBtnFontSizeIfTextIsOutOfBound()
    {
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    func setTitle(txtValue:String)
    {
        self.setTitle(txtValue.localizedLanguage(), for: .normal)
    }
    
    func setbtnNormalUIStyleFullBack(value : String) {
        self.setTitle(txtValue: value)
        self.setTitleColor(Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.LBL_NORMAL_TEXT
        
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: value)
        attributedText.underLine(subString: value)
        self.titleLabel!.attributedText = attributedText
        
        
//        var titleString : NSMutableAttributedString = NSMutableAttributedString(string: self.titleLabel!.text!)
//        titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue))

//        self.setAttributedTitle(titleString, forState: .Normal)
        
//        adjustFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnLoginWithEmailUI()
    {
        self.layer.cornerRadius =  self.frame.height/2;
        self.backgroundColor = Constant.Color.BTN_LOGIN_WITH_EMAIL_COLOR
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.FONT_LOGIN_WITH_EMAIL
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnSendVoteUI()
    {
        self.backgroundColor = Constant.Color.BTN_LOGIN_WITH_EMAIL_COLOR
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.FONT_LOGIN_WITH_EMAIL
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnEditUserProfileUI()
    {
        self.backgroundColor = Constant.Color.BTN_EDIT_USER_PROFILE_COLOR
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.LBL_NORMAL_TEXT
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnRoundUI()
    {
        self.setTitle(txtValue: "")
        self.layer.cornerRadius =  self.frame.height/2;
    }
    
    func setBtnSignUpUI()
    {
//        self.setGradientBackground1()
        self.setBackgroundImage(UIImage(named: Constant.Image.nav_gradient_pink), for: .normal)
       // self.layer.cornerRadius =  self.frame.height/2;
//        self.backgroundColor = Constant.Color.BTN_LOGIN_WITH_EMAIL_COLOR
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.FONT_LOGIN_WITH_EMAIL
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnContestantHomeUI()
    {
        //        self.setGradientBackground1()
//        self.setBackgroundImage(UIImage(named: Constant.Image.nav_gradient_pink), for: .normal)
        // self.layer.cornerRadius =  self.frame.height/2;
        self.backgroundColor = Constant.Color.BTN_GREDIENT_GRAY_LEFT
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.FONT_LOGIN_WITH_EMAIL
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnLoginWithGoogleUI()
    {
        self.layer.borderWidth = 3
        self.borderColor = Constant.Color.VIEW_BORDER_COLOR
        self.layer.cornerRadius =  self.frame.height/2;
        self.backgroundColor = Constant.Color.BTN_LOGIN_WITH_GOOGLE_COLOR
        self.setTitleColor(Constant.Color.BTN_BLACK_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.FONT_LOGIN_WITH_EMAIL
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnLoginUI()
    {
        self.layer.borderWidth = 1
        self.borderColor = Constant.Color.BTN_WHITE_BORDER_COLOR
        self.layer.cornerRadius =  self.frame.height/2;
        self.backgroundColor = UIColor.clear
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.BTN_NORMAL_LOGIN_TEXT
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnSemiBlackBorderAndTextUI()
    {
        self.layer.borderWidth = 1
        self.borderColor = Constant.Color.BTN_BORDER_COLOR
        self.layer.cornerRadius =  self.frame.height/2;
        self.backgroundColor = UIColor.clear
        self.setTitleColor(Constant.Color.TXT_PLACEHOLDER, for: .normal)
        self.titleLabel?.font = Constant.Font.BTN_NORMAL_LOGIN_TEXT
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnLoginWithFacebookUI()
    {
        self.layer.cornerRadius =  self.frame.height/2;
        self.backgroundColor = Constant.Color.BTN_LOGIN_WITH_FACEBOOK_COLOR
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.FONT_LOGIN_WITH_EMAIL
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnLoginWithKakaoUI()
    {
        self.layer.cornerRadius =  self.frame.height/2;
        self.backgroundColor = Constant.Color.BTN_LOGIN_WITH_KAKAO_COLOR
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.FONT_LOGIN_WITH_EMAIL
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnLoginWithNaverUI()
    {
        self.layer.cornerRadius =  self.frame.height/2;
        self.backgroundColor = Constant.Color.BTN_LOGIN_WITH_NAVER_COLOR
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.FONT_LOGIN_WITH_EMAIL
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnSignUpInfo(txtValue:String)
    {
        self.setTitle(txtValue.localizedLanguage(), for: .normal)
        setBtnSignUp()
    }
    
    func setBtnSignUp()
    {
        self.layer.cornerRadius =  4.0
        self.backgroundColor = Constant.Color.BTN_SUBMIT_BACKGROUND_COLOR
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.FONT_SIGN_UP
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnSendMessage()
    {
        self.backgroundColor = UIColor.clear
        self.setTitleColor(Constant.Color.BTN_SEND_MSG_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.LBL_EDIT_PROFILE_SEND_TEXT
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnEditProfileUI()
    {
        self.layer.borderWidth = 1
        self.borderColor = Constant.Color.BTN_WHITE_BORDER_PINK_COLOR
        self.layer.cornerRadius =  self.frame.height/2;
        self.backgroundColor = UIColor.clear
        self.setTitleColor(Constant.Color.BTN_PINK_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.BTN_NORMAL_LOGIN_TEXT
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnContestStatusPinkUICell()
    {
        
        self.layer.cornerRadius =  self.frame.height/2;
//        self.backgroundColor = UIColor.clear
        self.borderColor = Constant.Color.BTN_GREDIENT_PINK_RIGHT
       // self.layer.borderWidth = 2
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.BTN_NORMAL_LOGIN_TEXT
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnContestStatusPinkUI(_ isBold : Bool = false)
    {   
//        self.backgroundColor = UIColor.clear
        //self.setLeftToRightPinkGradientViewUI()
        self.setBackgroundImage(UIImage(named: Constant.Image.btn_gradient_pink), for: .normal)
        self.layer.cornerRadius =  self.frame.height/2;
        self.clipsToBounds = true
        self.borderColor = Constant.Color.BTN_GREDIENT_PINK_RIGHT
        self.layer.borderWidth = 2
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.BTN_NORMAL_LOGIN_TEXT
        if isBold {
            self.titleLabel?.font = Constant.Font.BTN_NORMAL_LOGIN_TEXT1
        }
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnContestStatusPinkUI1()
    {
        //        self.backgroundColor = UIColor.clear
        //self.setLeftToRightPinkGradientViewUI()
        self.setBackgroundImage(UIImage(named: Constant.Image.nav_gradient_pink), for: .normal)
        self.layer.cornerRadius =  self.frame.height/2;
        self.clipsToBounds = true
        self.borderColor = Constant.Color.BTN_GREDIENT_PINK_RIGHT
        self.layer.borderWidth = 2
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.BTN_NORMAL_LOGIN_TEXT1
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnContestStatusGrayUI(_ isBold : Bool = false)
    {
        self.layer.cornerRadius =  self.frame.height/2;
//        self.backgroundColor = UIColor.clear
       // self.setLeftToRightGrayGradientViewUI()
        self.backgroundColor = Constant.Color.BTN_GREDIENT_GRAY_LEFT
//        self.backgroundColor = Constant.Color.VIEW_BG_TOTAL_QUANTITY_COLOR
        self.borderColor = Constant.Color.BTN_GREDIENT_GRAY_RIGHT
        self.layer.borderWidth = 2
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.BTN_NORMAL_LOGIN_TEXT
        if isBold {
            self.titleLabel?.font = Constant.Font.BTN_NORMAL_LOGIN_TEXT1
        }
        adjustBtnFontSizeIfTextIsOutOfBound()
//        Constant.Color.VIEW_BG_TOTAL_QUANTITY_COLOR
    }
    
    func setBtnUseAllGrayUI()
        {
            self.layer.cornerRadius =  self.frame.height/2;
    //        self.backgroundColor = UIColor.clear
           // self.setLeftToRightGrayGradientViewUI()
            self.backgroundColor = Constant.Color.VIEW_BG_TOTAL_QUANTITY_COLOR
            self.borderColor = Constant.Color.BTN_GREDIENT_GRAY_RIGHT
            self.layer.borderWidth = 2
            self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
            self.titleLabel?.font = Constant.Font.BTN_NORMAL_LOGIN_TEXT
            adjustBtnFontSizeIfTextIsOutOfBound()
        }
    
    func setBtnSignUpDoubleCheckUI()
    {
        self.layer.cornerRadius = 10;
        //        self.backgroundColor = UIColor.clear
        // self.setLeftToRightGrayGradientViewUI()
        self.backgroundColor = Constant.Color.TXTF_BG_COLOR
        self.borderColor = Constant.Color.LIGHT_GREY_DARK_BORDER
        self.layer.borderWidth = 1.5
        self.setTitleColor(Constant.Color.LIGHT_GREY_DARK_BORDER, for: .normal)
        self.titleLabel?.font = Constant.Font.BTN_BOLD_SIGNUP_ID
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setBtnGreenRectUI()
    {
        self.backgroundColor = Constant.Color.BTN_SEND_GIFT
        self.setTitleColor(Constant.Color.BTN_WHITE_TEXT_COLOR, for: .normal)
        self.titleLabel?.font = Constant.Font.FONT_LOGIN_WITH_EMAIL
        self.layer.cornerRadius = 10
        adjustBtnFontSizeIfTextIsOutOfBound()
    }
    
    func setViewshadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = Constant.Color.LIGHT_GREY.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowRadius = 4
    }
    
}

extension TextField
{
    func setSimpleUITextfieldForCountryCode() {
        
        setTextFieldUI()
        self.clearButtonMode = .never
        self.clearsOnBeginEditing = false
        self.clearsOnInsertion = false
        self.placeholderLabel.text = "LBL_COUNTRY_CODE".localizedLanguage()
        // self.text = "LBL_COUNTRY_CODE".localizedLanguage()
       // self.attributedPlaceholder = NSAttributedString(string: "LBL_COUNTRY_CODE".localizedLanguage(), attributes: [NSAttributedStringKey.foregroundColor : Constant.BTN_TXTF_LIKE_PLACE_HOLDER_COLOR])
    }
    
    func addImageInTxtFRightSide(image:UIImage)
    {
        DispatchQueue.main.async {
            let imageView = UIImageView()
            imageView.image = image
            imageView.frame = CGRect(x: (self.frame.width - 30), y: 5, width: 20, height: 20)
            self.rightViewMode = UITextField.ViewMode.always
            self.addSubview(imageView)
        }
    }
    
    func setInValidTextFieldDetail(text:String)
    {
        self.setErrorTextFieldUiColorAndFont()
        self.detail = text.localizedLanguage()
    }
    
    func setInValidTextField(strInvalidMessage:String)
    {
        self.setErrorTextFieldUiColorAndFont()
        self.detail = strInvalidMessage.localizedLanguage()
    }
    
    func setTextFieldUIForZipCode()
    {
        self.isClearIconButtonEnabled = true
        self.keyboardType = .numberPad
        setTextFieldUI()
    }
    
    func setZipCodeMaximumSide(range: NSRange, string: String) -> Bool
    {
        // Use this mehtod in // textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        let maxLength = 5
        let currentString: NSString = self.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func setTextFieldUIForPhoneNumber()
    {
        self.isClearIconButtonEnabled = true
        self.keyboardType = .phonePad
        setTextFieldUI()
    }
    
    func setTextFieldUIForAnyName()
    {
        self.isClearIconButtonEnabled = true
        self.autocapitalizationType = .words
        setTextFieldUI()
    }
    
    func setTextFieldUIForEmail()
    {
        self.isClearIconButtonEnabled = true
        self.autocorrectionType = .no
        self.keyboardType = .emailAddress
        setTextFieldUI()
    }
    
    func setTextFieldUIForPassword()
    {
        self.isSecureTextEntry = true
        self.isVisibilityIconButtonEnabled = true
        setTextFieldUI()
    }
    
    func isValidZipCode() -> Bool
    {
        if(self.text! == "" || Int(self.text!) == nil || (self.text?.count)! != 5)
        {
            return false
        }
        return true
    }
    
    func setTextFieldUI()
    {
        self.font = Constant.Font.FONT_SIMPLE_DETAILS_BTN
        
        self.textColor = Constant.Color.EDIT_TEXT_COLOR
        self.placeholderVerticalOffset = 7
        self.placeholderActiveScale = 0.90
        //self.placeholderLabel.textColor = Constant.BTN_TXTF_LIKE_PLACE_HOLDER_COLOR
        self.dividerNormalHeight = 2
        self.dividerActiveHeight = 2
        self.placeholderLabel.font = Constant.Font.FONT_SIMPLE_DETAILS_BTN
        
//        self.placeholderActiveColor = Constant.BTN_TXTF_SELECTED_PLACE_HOLDER_DIVIDER_COLOR
//        self.placeholderNormalColor = Constant.BTN_TXTF_UNSELECTED_PLACE_HOLDER_DIVIDER_COLOR
        
        self.placeholderActiveColor = Constant.Color.BTN_TXTF_SELECTED_PLACE_HOLDER_COLOR
        self.placeholderNormalColor = Constant.Color.BTN_TXTF_UNSELECTED_PLACE_HOLDER_COLOR
        
        self.dividerNormalColor = Constant.Color.APP_VIEW_BG_GRAY
        self.dividerActiveColor = Constant.Color.APP_VIEW_BG_GRAY
        
    }

    func setTextFieldUiColorAndFont()
    {
        self.clearsOnBeginEditing = false
//        self.placeholderActiveColor = Constant.BTN_TXTF_SELECTED_PLACE_HOLDER_DIVIDER_COLOR
//        self.placeholderNormalColor = Constant.BTN_TXTF_UNSELECTED_PLACE_HOLDER_DIVIDER_COLOR
        
        self.placeholderActiveColor = Constant.Color.BTN_TXTF_SELECTED_PLACE_HOLDER_COLOR
        self.placeholderNormalColor = Constant.Color.BTN_TXTF_UNSELECTED_PLACE_HOLDER_COLOR
        
        self.dividerActiveColor = Constant.Color.APP_VIEW_BG_GRAY
        self.dividerNormalColor = Constant.Color.APP_VIEW_BG_GRAY
        
        self.font = Constant.Font.FONT_SIMPLE_DETAILS_BTN
        self.detail = ""
        self.detailColor = Constant.Color.BTN_TXTF_ERROR_COLOR
    }

    func setErrorTextFieldUiColorAndFont()
    {
        self.clearsOnBeginEditing = false
        self.placeholderActiveColor = Constant.Color.BTN_ERROR_TXTF_SELECTED_PLACE_HOLDER_COLOR
        self.placeholderNormalColor = Constant.Color.BTN_ERROR_TXTF_SELECTED_PLACE_HOLDER_COLOR
        self.dividerActiveColor = Constant.Color.BTN_ERROR_TXTF_SELECTED_PLACE_HOLDER_COLOR
        self.dividerNormalColor = Constant.Color.BTN_ERROR_TXTF_UNSELECTED_PLACE_HOLDER_COLOR
        
        self.detailColor = Constant.Color.BTN_TXTF_ERROR_COLOR
    }
    
    
}



extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage1 = image?.cgImage else { return nil }
        self.init(cgImage: cgImage1)
    }
    
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

extension UILabel
{
    func adjustFontSizeIfTextIsOutOfBound()
    {
        self.adjustsFontSizeToFitWidth = true
        self.adjustsFontForContentSizeCategory = true
    }
    
    func setEditProfileUIStyle(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LIGHT_GREY1
        self.font = Constant.Font.LBL_EDIT_PROFILE_TITLE
    }
    
    func setEditProfileUIStyle1(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LIGHT_GREY1
        self.font = Constant.Font.LBL_EDIT_PROFILE_DETAIL
    }
    
    func setCollectionTitleUIStyle(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR
        self.font = Constant.Font.LBL_COLLECTION_TEXT
    }
    
    func setLoginNormalUIStyle(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_NORMAL
        self.font = Constant.Font.LBL_NORMAL_TEXT
    }
    
    func setLoginNormalUIStyleFullBack(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR
        self.font = Constant.Font.LBL_NORMAL_TEXT
      //  adjustFontSizeIfTextIsOutOfBound()
    }
    
    func setLoginNormalUIStyleBackForCell(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR
        self.font = Constant.Font.LBL_NORMAL_TEXT
    }
    
    func setLoginNormalUIStyleNavColorForCell(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.CELL_TEXT_LIKE_NAC_COLOR
        self.font = Constant.Font.LBL_NORMAL_TEXT
    }
    
    func setLoginHeaderUIStyleFullBack(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR
        self.font = Constant.Font.LBL_HEADER_TEXT
    }
    
    func setEditProfileHeaderUIStyleFullBack(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR
        self.font = Constant.Font.LBL_HEADER_TEXT
    }
    
    func setSmallUIStyleWhite(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_WHITE
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setSmallUIStyleSemiblack(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.TEXT_BLACK_COLOR
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setSmallUIStyleBlue(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_TXT_CURRENT_LOGIN
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setForgotPwdUIStyle(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR
        self.font = Constant.Font.LBL_NORMAL_TEXT_VIEW
        
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: value.localizedLanguage())
        attributedText.underLine(subString: value.localizedLanguage())
        self.attributedText = attributedText
    }
    
    func setSmallUIStyleRed(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = UIColor.red
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setSmallUIStyleBlack(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = UIColor.black
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setSmallUIStyleEditProfilePink(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_TXT_PINK_COLOR
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setSmallUIStyleTabbarWhite(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_WHITE
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setSmallUIStyleWhiteCell(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_WHITE
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setLoginSmallUIStylePlaceHolderBlack(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_NORMAL
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setLoginSmallBGColorUITxtWhite(value : String) {
        self.text = value.localizedLanguage()
        self.layer.cornerRadius = self.bounds.height/2
        self.clipsToBounds = true
        self.textColor = Constant.Color.LBL_WHITE
        self.backgroundColor = Constant.Color.LBL_BG_COLOR
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setSmall2BGColorUITxtWhite(value : String) {
        self.text = value.localizedLanguage()
        self.layer.cornerRadius = self.bounds.height/2
        self.clipsToBounds = true
        self.textColor = Constant.Color.LBL_WHITE
        self.backgroundColor = Constant.Color.LBL_BG_COLOR
        self.font = Constant.Font.LBL_SMALL_TEXT2
    }
    
    func setSmall2BGColorUITxtWhiteCell(value : String) {
        self.text = value.localizedLanguage()
        self.layer.cornerRadius = self.bounds.height/2
        self.clipsToBounds = true
        self.textColor = Constant.Color.LBL_WHITE
        self.backgroundColor = Constant.Color.LBL_BG_COLOR
        self.font = Constant.Font.LBL_SMALL_TEXT2
    }
    
    func setSmall2UITxtWhiteCell(value : String) {
        self.text = value.localizedLanguage()
        self.layer.cornerRadius = self.bounds.height/2
        self.clipsToBounds = true
        self.textColor = Constant.Color.LBL_WHITE
        self.font = Constant.Font.LBL_SMALL_TEXT2
    }
    
    func widthForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat{
       let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width:
       CGFloat.greatestFiniteMagnitude, height: 21))
       label.numberOfLines = 0
       label.lineBreakMode = NSLineBreakMode.byCharWrapping
       label.font = font
       label.text = text
       label.sizeToFit()
       return label.frame.width
    }
    
    func setLoginNormalUIStyleWhite(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_WHITE
        self.font = Constant.Font.LBL_NORMAL_TEXT
    }
    
    func setLoginNormalUIStyleCell(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_WHITE
        self.font = Constant.Font.LBL_NORMAL_TEXT
    }
    
    func setLoginNormalUIStylePinkCell(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_CELL_PINK_COLOR
        self.font = Constant.Font.LBL_NORMAL_TEXT
    }
    
    func setNormalUIStylePink(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_TXT_PINK_COLOR
        self.font = Constant.Font.LBL_NORMAL_TEXT
    }
    
    func setBoldEditProfileUIStylePink(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_TXT_PINK_COLOR
        self.font = Constant.Font.LBL_NORMAL_BOLD_TEXT
    }
    
    func setBoldEditProfileSecondTitleBalck(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR
        self.font = Constant.Font.LBL_NORMAL_BOLD_TEXT
    }
    
    func setNoticeTitleStyle(value : String) {
        self.text = value.localizedLanguage()
        self.font = Constant.Font.LBL_NORMAL_BOLD_TEXT1
        self.textColor = Constant.Color.BLACK
    }
    
    func setNoticeDetailStyle(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LIGHT_GREY11
        self.font = Constant.Font.LBL_NORMAL_THIRD_TEXT1
    }
    
    func setBoldPushNotificationSecondTitlePink(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_TXT_PINK_COLOR
        self.font = Constant.Font.LBL_NORMAL_BOLD_TEXT
    }
    
    func setBoldEditProfileThirdTitleBalck(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR
        self.font = Constant.Font.LBL_NORMAL_THIRD_BOLD_TEXT
    }
    
    func setBoldEditProfileThirdTitleGrey(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_DARK_GREY_COLOR
        self.font = Constant.Font.LBL_NORMAL_THIRD_BOLD_TEXT
    }
    
    func setCategoryList(value : String,lblHeight:CGFloat) {
        self.text = value.localizedLanguage()

        self.borderColor = Constant.Color.VIEW_BORDER_PINK_COLOR
        self.clipsToBounds = false
        self.layer.borderWidth = 1
        self.layer.cornerRadius = lblHeight/2
        self.clipsToBounds = true
        self.textColor = Constant.Color.LBL_TXT_PINK_COLOR
        self.font = Constant.Font.LBL_NORMAL_TEXT
    }
    
    func setNormalEditProfileSecondTitleBalck(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR
        self.font = Constant.Font.LBL_NORMAL_TEXT
    }
    
    func setNormalSecondTitlePink(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.font = Constant.Font.LBL_NORMAL_TEXT
    }
    
    func setNormalEditProfileSecondTitleGray(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_GRAY_COLOR
        self.font = Constant.Font.LBL_NORMAL_TEXT
    }
    
    func setSmallTitleGray(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_GRAY_COLOR
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setSmallTitleSemiBlack(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_SEMI_BLACK_POPUP_COLOR
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setSignUpAvailableID(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_GRAY_COLOR
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setNormalEditProfileThirdTitleBalck(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR
        self.font = Constant.Font.LBL_NORMAL_THIRD_TEXT
    }
    
    func setNormalDateThirdTitlePlaceHolder(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LOGIN_NORMAL
        self.font = Constant.Font.LBL_NORMAL_THIRD_TEXT
    }
    
    func setSmallEditProfileThirdTitleBalckPinkCell(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_LIKE_COUNT_PINK
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setNormalEditProfileUIStylePink(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_TXT_PINK_COLOR
        self.font = Constant.Font.LBL_NORMAL_TEXT
    }
    
    func setLoginSmallBGColorUITxtPinkCell(value : String) {
        self.text = value.localizedLanguage()
        self.layer.cornerRadius = self.bounds.height/2
        self.clipsToBounds = true
        self.textColor = Constant.Color.LBL_WHITE
        self.backgroundColor = Constant.Color.LBL_CELL_BG_PINK_TEXT
        self.font = Constant.Font.LBL_SMALL_TEXT
    }
    
    func setLoginHeaderBigUIStylePinkCell(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_CELL_PINK_COLOR
        self.font = Constant.Font.LBL_BIG_TEXT_CELL
    }
    
    func setLoginHeaderBigUIStyleWhiteCell(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_WHITE
        self.font = Constant.Font.LBL_NORMAL_BOLD_TEXT
    }
    
    func setLoginHeaderBigUIStyleWhiteCell1(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_WHITE
        self.font = Constant.Font.LBL_NORMAL_BOLD_TEXT11
    }
    
    func setLoginHeaderBigUIStylePink(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_TXT_PINK_COLOR
        self.font = Constant.Font.LBL_BIG_TEXT
    }
    
    func setLoginHeaderVeryBigUIStylePink(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_TXT_PINK_COLOR
        self.font = Constant.Font.LBL_VERY_BIG_TEXT
        adjustFontSizeIfTextIsOutOfBound()
    }
    
    func setFgtPwdHeaderVeryBigUIStylePink(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_TXT_PINK_COLOR
        self.font = Constant.Font.LBL_VERY_BIG_TEXT_BOLD
        adjustFontSizeIfTextIsOutOfBound()
    }
    
    
    func setLoginHeaderUIStyleBlackCell(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.LBL_CELL_DARK_BLACK_COLOR
        self.font = Constant.Font.LBL_HEADER_TEXT_CELL
    }
    
    func setHeaderUIStyleWhite(value : String) {
        self.text = value.localizedLanguage()
        self.textColor = Constant.Color.BTN_WHITE_TEXT_COLOR
        self.font = Constant.Font.LBL_HEADER_TEXT
    }
    
    func setAttributedTextVoteCountCellLbl(text:String, subString:String)
    {
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(font: Constant.Font.LBL_SMALL_TEXT!, subString: subString)
        self.attributedText = attributedText
    }
    
    func setAttributedTextMsgCellLbl(text:String, subString:String)
    {
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(font: Constant.Font.LBL_NORMAL_THIRD_BOLD_TEXT!, subString: subString)
        self.attributedText = attributedText
    }
    
    func setAttributedTextPagingLbl(text:String, subString:String)
    {
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(font: Constant.Font.LBL_NORMAL_THIRD_BOLD_TEXT!, subString: subString)
        attributedText.apply(color: Constant.Color.TEXT_BLACK_COLOR, subString: subString)
        self.attributedText = attributedText
    }
    
    func setLableHeightAcoordingToText() {
        if self.text != nil {
            let constraint = CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
            var size: CGSize
            let context = NSStringDrawingContext()
            
            let boundingBox: CGSize? = self.text?.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font], context: context).size
            size = CGSize(width: ceil((boundingBox?.width)!), height: ceil((boundingBox?.height)!))
            
            var newFrame = self.frame
            newFrame.size.height = size.height
            self.frame = newFrame
        }
    }
    
    func setCellDetailsLblBlackInfo(lblValue : String)
    {
        self.text = lblValue.localizedLanguage()
        setCellDetailsLblBlackInfo()
    }
    
    func setCellDetailsLblBlackInfo()
    {
        self.font = Constant.Font.FONT_TBLV_CELL_DETAILS_LBL
        self.textColor = Constant.Color.TEXT_BLACK_COLOR
    }
    
    func setLblNoDataFoundUIInf(lblValue : String)
    {
        self.text = lblValue.localizedLanguage()
        setLblNoDataFoundUI()
    }
    
    func setLblNoDataFoundUI()
    {
        self.font = Constant.Font.FONT_NAVIGATION_HEADER
        self.textColor = Constant.Color.TXTF_LIKE_PLACE_HOLDER_COLOR
        adjustFontSizeIfTextIsOutOfBound()
    }
    
}
extension RaisedButton
{
    func setSimpleRaisedButtonWithBorderUI(withLocaliseText: String) -> Void {
        
        self.setTitle(withLocaliseText.localizedLanguage(), for: UIControl.State.normal)
        self.setTitle(withLocaliseText.localizedLanguage(), for: UIControl.State.selected)
        self.backgroundColor = UIColor.white
        self.titleLabel?.font = Constant.Font.FONT_BASE_VC_REGULAR
        self.titleLabel?.textColor = Constant.Color.COLOR_HEX_APP_LIGHT_SEMI_TRANSPARENT_COLOR
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.cornerRadiusPreset = CornerRadiusPreset.cornerRadius2// remove deafalut corner radius
        self.borderColor = Constant.Color.COLOR_HEX_APP_LIGHT_SEMI_TRANSPARENT_COLOR
        self.borderWidthPreset = .border1
        self.titleColor = Constant.Color.COLOR_HEX_APP_LIGHT_SEMI_TRANSPARENT_COLOR
        // button.selectedTitleColor = Constant.COLOR_HEX_APP_LIGHT_SEMI_TRANSPARENT_COLOR
        self.title = withLocaliseText.localizedLanguage()
        if #available(iOS 10.0, *) {
            self.titleLabel?.adjustsFontForContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
    }
}

extension UITextView
{
    func setRectViewTxtNormalBlack(value: String)
    {
        self.text = value.localizedLanguage()
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 0.5
        self.borderColor = Constant.Color.VIEW_SEPRETOR_COLOR
        self.textColor = Constant.Color.TXT_PLACEHOLDER_SEMI_BLACK
        self.font = Constant.Font.LBL_NORMAL_TEXT_VIEW
        
    }
    
    func setWriteCommentMaximumSide(range: NSRange, string: String) -> Bool
    {
        // Use this mehtod in // textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        let maxLength = 148
        let currentString: NSString = self.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
}

extension UITextField
{
    func setPaddingLeft(textfield : UITextField) {
           let paddingView1 : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: textfield.frame.height))
           textfield.leftView = paddingView1
           textfield.leftViewMode = UITextField.ViewMode.always
       }
    
    func setUIWithPlaceholder(placeHolder : String) {
        self.borderStyle = .none
        self.backgroundColor = UIColor.clear
        self.font = Constant.Font.TXTFIELD_PLACEHOLDER
        self.textColor = Constant.Color.TXT_TEXT
        self.tintColor = Constant.Color.TXT_TEXT
        self.attributedPlaceholder = NSAttributedString(string: placeHolder.localizedLanguage(),
                                                        attributes: [NSAttributedString.Key.foregroundColor: Constant.Color.TXT_PLACEHOLDER])
//        self.setPaddingLeft(textfield: self)
    }
    
    func setUIWithPlaceholderTxtBlackBig(placeHolder : String) {
            self.borderStyle = .none
            self.backgroundColor = UIColor.clear
            self.font = Constant.Font.TXTFIELD_PLACEHOLDER
            self.textColor = Constant.Color.TXT_TEXT
            self.tintColor = Constant.Color.TXT_TEXT
            self.attributedPlaceholder = NSAttributedString(string: placeHolder.localizedLanguage(),
                                                            attributes: [NSAttributedString.Key.foregroundColor: Constant.Color.TXT_PLACEHOLDER])
    //        self.setPaddingLeft(textfield: self)
        }
    
    func setSearchUIWithPlaceholder(placeHolder : String)
    {
        self.borderStyle = .none
       // self.placeholder = placeHolder.localizedLanguage()
        self.attributedPlaceholder = NSAttributedString(string: placeHolder.localizedLanguage(),
        attributes: [NSAttributedString.Key.foregroundColor: Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR])
        self.backgroundColor = UIColor.clear
//        self.font = Constant.Font.TXTFIELD_PLACEHOLDER
//        self.textColor = Constant.Color.TXTF_TXT_WHITE_COLOR
        self.font = Constant.Font.TXTFIELD_PLACEHOLDER
        self.textColor = Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR
    }
    
}

extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}

extension UIImageView {
    
//    func getImageFromURLForBanner(url : String, defImage: String = Constant.Image.Banner_iOS) {
//        self.kf.indicatorType = .activity
//        var img:UIImage!
//        if(defImage != "")
//        {
//            img = UIImage(named: defImage)
//        }else
//        {
//            img = UIImage(named: defImage)
//        }
//
//        self.kf.setImage(with: URL(string: url), placeholder: img, options: [.transition(.fade(0.0))], progressBlock: nil) { (img, err, type, url) in
//            if err != nil || img == nil
//            {
//                self.kf.indicatorType = .none
//                self.setImageFit(imageName: defImage)// = UIImage(named: Constant.Image.DEFAULT_IMAGE)
//                printDebug("Problem in caching image")
//            }
//        }
//    }
    
    func getImageFromURL(url : String, defImage: String = Constant.Image.Default_iOS) {
        self.kf.indicatorType = .none
        var img:UIImage!
        if(defImage != "")
        {
            img = UIImage(named: defImage)
        }else
        {
            img = UIImage(named: defImage)
        }
        
//        self.kf.setImage(with: URL(string: url), placeholder: img, options: [.forceRefresh], progressBlock: nil) { (img, err, type, url) in
//            if err != nil || img == nil
//            {
//                self.kf.indicatorType = .none
//                self.setImageFit(imageName: defImage)// = UIImage(named: Constant.Image.DEFAULT_IMAGE)
//              //  printDebug("Problem in caching image")
//                //                    ImageCache.default.clearDiskCache()
//                //                    ImageCache.default.clearMemoryCache()
//            }
//        }
        
        
        self.kf.setImage(with: URL(string: url), placeholder: img, options: [.transition(.fade(0.0))], progressBlock: nil) { (img, err, type, url) in
            if err != nil || img == nil
            {
                self.kf.indicatorType = .none
                self.setImageFit(imageName: defImage) // = UIImage(named: Constant.Image.DEFAULT_IMAGE)
//                printDebug("Problem in caching image")
            }
        }
    }
    
    func getImageFromURLWithWidth(url : String, height : CGFloat, defImage: String = Constant.Image.Default_iOS) -> CGFloat {
        self.kf.indicatorType = .none
        var img:UIImage!
        if(defImage != "") {
            img = UIImage(named: defImage)
        }else {
            img = UIImage(named: defImage)
        }
        
        var width = CGFloat()
        
        self.kf.setImage(with: URL(string: url), placeholder: img, options: [.transition(.fade(0.0))], progressBlock: nil) { (img, err, type, url) in
            if err != nil || img == nil
            {
                self.kf.indicatorType = .none
                self.setImageFit(imageName: defImage) // = UIImage(named: Constant.Image.DEFAULT_IMAGE)
                //                printDebug("Problem in caching image")
            }
            else {
                
                let imageSize = img?.size
                print("Image Size : \(imageSize)")
                width = (height * imageSize!.width) / imageSize!.height
                print(width)
            }
        }
        
        return width
    }

    
    func getImageFromLocalPath(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            printDebug(error)
        }
        return nil
    }
    
    func setImageFit(imageName : String) {
        self.image = UIImage(named: imageName)
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
    }
    
    func setImageFitRoundBorderEditProfile(imageName : String) {
        self.image = UIImage(named: imageName)
        self.contentMode = .scaleAspectFill
        self.layer.borderWidth = 1
        self.borderColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.layer.cornerRadius = self.bounds.height/2
        self.clipsToBounds = true
        
    }
    
    func setImageFill(imageName : String) {
        self.image = UIImage(named: imageName)
        self.contentMode = .scaleToFill
        self.clipsToBounds = true
    }
    
    func setImageFill(image : UIImage) {
        self.image = image
        self.contentMode = .scaleToFill
        self.clipsToBounds = true
    }
    
    func setAspectFillImageInImageView(image : UIImage) {
        self.image = image
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
    func setFillImageInImageView()
    {
        self.clipsToBounds = false
        self.contentMode = .scaleToFill
        self.clipsToBounds = true
    }
    
    func setFitImageInImageView()
    {
        self.clipsToBounds = false
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
    }
    
    func setAspectFillImageInImageView()
    {
        self.clipsToBounds = false
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}

extension GTProgressBar
{
    func createProgressbarUI(isLikeView:Bool, progressView:UIView)
    {
        DispatchQueue.main.async {
            
            if(isLikeView == true)
            {
                self.barFillColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
            }else
            {
                self.barFillColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
            }
            
            self.barBorderWidth = 0
            self.barFillInset = 1
            self.labelTextColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
            self.font = Constant.Font.LBL_NORMAL_TEXT!
            self.labelPosition = GTProgressBarLabelPosition.right
            self.backgroundColor = UIColor.white
           // self.barMaxHeight = 18
            self.barMaxHeight = 40
            self.direction = GTProgressBarDirection.clockwise
            
            /** >>>>>> ALPESH: DONT DELETE THIS COMMENT <<<<<<
                    //how to add check_mark image behind progress bar
                    //self.addCheckImgInProgressBarUI(progressView:progressView)
             **/
            self.frame = CGRect(x: 0, y: 0, width: progressView.frame.width, height: progressView.frame.height)
            self.sizeToFit()
            
            progressView.addSubview(self)
        }
    }
    
//    func addCheckImgInProgressBarUI(progressView:UIView)
//    {
//        // persiontage label size is 60
//        let xPosion:CGFloat  =  ((self.layer.width - 60) * self.progress) + 67
//
//        let imageView = UIImageView(image: UIImage(named: "check_voted_golden"))
//        imageView.contentMode = .scaleAspectFit
//        imageView.frame = CGRect(x: xPosion  , y: 0, width: self.layer.height, height: self.layer.height)
//        progressView.addSubview(imageView)
//
//        self.font = Constant.FONT_TBLV_CELL_DETAILS_LBL_BOLD!
//
//    }
}

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

extension Date {
    func isBetween(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
}
