//
//  AppDelegate.swift
//  RankingStar
//
//  Created by Jinesh on 13/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import KakaoOpenSDK
import NaverThirdPartyLogin
import UserNotifications

import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   
    var token = ""
    var objRefreshUserDetailsDelegate : RefreshUserDetailsDelegate!
    var isPushViewOn = false
    let refererAppLink: [AnyHashable : Any]? = nil
    var objOriantation: UIInterfaceOrientationMask = UIInterfaceOrientationMask.portrait
    var uniqueDeviceId = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotification(application: application)
        
        IQKeyboardManager.sharedManager().enable = true
        UIApplication.shared.applicationIconBadgeNumber = 0
//        createMenuView()
        if(Util.getIsUserAutoLogin() == "0")
        {
            Util.removeAllDataOnLogout()
        }
        loadLoginVC()
        
        GIDSignIn.sharedInstance().clientID = Constant.GOOGL_CLIENT_ID
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        let objNaver = NaverThirdPartyLoginConnection.getSharedInstance()
        objNaver?.isInAppOauthEnable = true
        objNaver?.isNaverAppOauthEnable = true
        objNaver?.setOnlyPortraitSupportInIphone(true)
        objNaver?.serviceUrlScheme = kServiceAppUrlScheme
        objNaver?.consumerKey = kConsumerKey
        objNaver?.consumerSecret = kConsumerSecret
        objNaver?.appName = kServiceAppName
                
        uniqueDeviceId = Util.getDeviceID()
        if uniqueDeviceId.count <= 0 {
            print("Create new device id in storage")
            Util.setDeviceID()
            uniqueDeviceId = Util.getDeviceID()
            print("uniqueDeviceId : \(uniqueDeviceId)")
        }
        else {
            //getDeviceID > deviceID:  B2B2E265-DB0E-4F24-BB01-407AC6CED0B4
            //found storage uniqueDeviceId : B2B2E265-DB0E-4F24-BB01-407AC6CED0B4
            print("found storage uniqueDeviceId : \(uniqueDeviceId)")
        }
        
        
//        let transactionId = "Mayur@12345"
//        print("transactionId.md5: \(transactionId.md5)")
//        print("transactionId.md5: \(transactionId.md5)")
//        print("transactionId.md5: \(transactionId.md5)")
        
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       // return
        GIDSignIn.sharedInstance().handle(url)
        if KOSession.isKakaoAccountLoginCallback(url){
           return KOSession.handleOpen(url)
        } //1500714912
        
        if(url.absoluteString.contains(Constant.NAVER_AUTH_TOKEN))
        {
            NaverThirdPartyLoginConnection.getSharedInstance()?.receiveAccessToken(url)
        }
        
        if (url.scheme == "kakaoa6b3933e5b425ac2e27a134cb851fbc9" && url.host == "kakaolink") || (url.scheme == "share" && url.host == "contestant") {
            
            let contestant_id = Util.getQueryStringParameter(url: url.absoluteString, param: "contestant_id")
            let contest_id = Util.getQueryStringParameter(url: url.absoluteString, param: "contest_id")
            
            createMenuView()
            if contestant_id != nil && contest_id != nil {
                
                if Util.currentNavigationController == nil {
                    
                    let objMainVc = MainVC()
                    Util.objMainVC = objMainVc
                    
                    let objContestantProfileVC = ContestantProfileVC()
                    objContestantProfileVC.objContestant.strContestId = contest_id
                    objContestantProfileVC.objContestant.strId = contestant_id
                    
                    let navMainVC  : UINavigationController = UINavigationController(rootViewController: objMainVc)
                    Util.currentNavigationController = navMainVC
                    Util.currentNavigationController.pushViewController(objContestantProfileVC, animated: true)
                    navMainVC.navigationBar.isHidden = true
                    navMainVC.navigationController?.isNavigationBarHidden = true
                    
                    window?.rootViewController = Util.currentNavigationController
                }else {
                    let objContestantProfileVC = ContestantProfileVC()
                    objContestantProfileVC.objContestant.strContestId = contest_id
                    objContestantProfileVC.objContestant.strId = contestant_id
                    Util.currentNavigationController.pushViewController(objContestantProfileVC, animated: true)
                }
            }
        }
        
        if(url.absoluteString.contains(Constant.FACEBOOK_AUTH_TOKEN) || url.absoluteString.contains("facebook"))
        {
            return ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        printDebug("handleEventsForBackgroundURLSession")
        completionHandler()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }

//    var sideMenuNavVC : UINavigationController!
    func createMenuView() {

        let objMainVC = MainVC()
        let navMainVC  : UINavigationController = UINavigationController(rootViewController: objMainVC)
        navMainVC.navigationController?.isNavigationBarHidden = true
        navMainVC.isNavigationBarHidden = true

        let objSideMenuVC = SideMenuVC()
        Util.objMainVC = objMainVC
        Util.currentNavigationController = objMainVC.navigationController
        let navRightVC  : UINavigationController = UINavigationController(rootViewController: objSideMenuVC)
        navRightVC.navigationController?.isNavigationBarHidden = true
        navRightVC.isNavigationBarHidden = true

        let slideMenuController = ExSlideMenuController(mainViewController: navMainVC, leftMenuViewController: navRightVC)
      //  let slideMenuController = ExSlideMenuController(mainViewController: navMainVC, rightMenuViewController: navRightVC)
        slideMenuController.delegate = objMainVC
        slideMenuController.changeLeftViewWidth(UIScreen.main.bounds.width)
//        slideMenuController.changeRightViewWidth(UIScreen.main.bounds.width - 60)

        let sideMenuNavVC : UINavigationController = UINavigationController(rootViewController: slideMenuController)
        sideMenuNavVC.navigationBar.isHidden = true
        sideMenuNavVC.navigationController?.isNavigationBarHidden = true

        Util.slideMenuController = slideMenuController
//        Util.sideMenuNavVC = sideMenuNavVC

        self.window?.rootViewController = sideMenuNavVC
    }
        
    func loadLoginVC() {
    
       // let objLoginVC = PushNotificationListVC()
        let objSplaceScreenVC = SplaceScreenVC()
        
        let navVc : UINavigationController = UINavigationController(rootViewController: objSplaceScreenVC)
        navVc.navigationBar.isHidden = true
        navVc.navigationController?.isNavigationBarHidden = true
        
        self.window?.rootViewController = navVc
        self.window?.makeKeyAndVisible()
    }
    
    func openUpgradeScreen(dicData : NSDictionary) {
        
        if let isForceUpdateTapped : Bool = Util.getDefaultValue(key: Constant.UserDefaultKey.KEY_FORCE_UPDATE_APP) as? Bool {
            if isForceUpdateTapped {
                if Util.objUpdateAppVC == nil {
                    Util.objUpdateAppVC = UpdateAppVC()
                    Util.objUpdateAppVC.dicData = dicData
                    Util.currentNavigationController.pushViewController(Util.objUpdateAppVC, animated: true)
                }
            }
            else {
                if let isSkipTapped : Bool = Util.getDefaultValue(key: Constant.UserDefaultKey.KEY_FORCE_UPDATE_SKIP_TAPPED) as? Bool {
                    if !isSkipTapped {
                        if Util.objUpdateAppVC == nil {
                            Util.objUpdateAppVC = UpdateAppVC()
                            Util.objUpdateAppVC.dicData = dicData
                            Util.currentNavigationController.pushViewController(Util.objUpdateAppVC, animated: true)
                        }
                    }
                }else {
                    if Util.objUpdateAppVC == nil {
                        Util.objUpdateAppVC = UpdateAppVC()
                        Util.objUpdateAppVC.dicData = dicData
                        Util.currentNavigationController.pushViewController(Util.objUpdateAppVC, animated: true)
                    }
                }
            }
        }
    }
    
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.objOriantation = orientation
            }
        }
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
}

func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}

func registerForPushNotification(application: UIApplication) {     //
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
        
        print("Permission granted: \(granted)")
        guard granted else { return }
        getNotificationSettings()
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate
{
    //MARK:- UNUserNotificationCenterDelegate
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }

        token = tokenParts.joined()
        print("Device Token: \(token)")
        //Device Token: 9a0bbdfdc834904a6d9c68d3861578b865878585f9f33bd29122b7998ba96e55
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if error != nil {
            print("Device Register Failed :: >>>> \(error.localizedDescription)")
        }
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types.rawValue == 0 {
            print("Failed to register : ")
        }
        else {
            application.registerForRemoteNotifications()
        }
//        UIApplication.shared.applicationIconBadgeNumber = 1
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // when app is in foreground
        
        let userInfo = notification.request.content.userInfo
        printDebug(userInfo)
        
        var customParam : NSDictionary? 
         customParam = userInfo[AnyHashable("customParam")] as! NSDictionary?
        let aps : NSDictionary? = userInfo[AnyHashable("aps")] as! NSDictionary?
        var alert : String? = nil;
        if aps != nil {
            alert = aps?["alert"] as? String? ?? nil;
            print("Alert: \(alert)")
        }
        
        var remainingStar : String? = nil
        if customParam != nil {
            remainingStar = customParam?["receiver_star"] as? String? ?? nil
        }
        if (remainingStar != nil) {
            var dictData1:[String: Any]? = Util.getUserProfileDict()
            if(dictData1 != nil) {
                dictData1!["remaining_star"] = remainingStar
            }
            Util.setUserProfileDict(strValue: dictData1!)
            
            if objRefreshUserDetailsDelegate != nil {
                objRefreshUserDetailsDelegate.getUserStar()
            }
        }
        
        completionHandler(UNNotificationPresentationOptions.alert)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // when push notification display
        print("Recieve notificaton on foreground: \(userInfo)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // when tap on notification
        
        print("Tap on notification: \(userInfo)")
        
//        let objPushNotificationListVC = PushNotificationListVC()
//
//        let navPushVC  : UINavigationController = UINavigationController(rootViewController: objPushNotificationListVC)
//        navPushVC.navigationController?.isNavigationBarHidden = true
//        navPushVC.isNavigationBarHidden = true
//        Util.currentNavigationController = navPushVC
//        Util.slideMenuController.changeMainViewController(navPushVC, close: true)
//        {
        
//        if isPushViewOn == false {
//            if UIApplication.shared.applicationState == .active
//            {
//                Util.objMainVC.pushViewControllerFromSideMenu(index: 5)
//                //            print("Push notification On SCREEN")
//            }
//            else
//            {
//                createMenuView()
//                Util.objMainVC.pushViewControllerFromSideMenu(index: 5)
//                //            print("Push notification On background")
//            }
//        }
    }
}



