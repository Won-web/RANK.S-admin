//
//  SceneDelegate.swift
//  RankingStar
//
//  Created by Jinesh on 13/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKCoreKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
      //  self.window = UIWindow(frame: UIScreen.main.bounds)
        
//        Util.sceneDelegate = self
//        IQKeyboardManager.sharedManager().enable = true
//        GIDSignIn.sharedInstance().clientID = Constant.GOOGL_CLIENT_ID
//        
//        createMenuView()
       // loadLoginVC()
    //    com.rankingstar.ios.app
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        let _ = ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

     

        func createMenuView() {
            
            let objMainVC = MainVC()

            let navMainVC  : UINavigationController = UINavigationController(rootViewController: objMainVC)
            navMainVC.navigationController?.isNavigationBarHidden = true
            navMainVC.isNavigationBarHidden = true
            
            let objSideMenuVC = SideMenuVC()
            
            let navRightVC  : UINavigationController = UINavigationController(rootViewController: objSideMenuVC)
            navRightVC.navigationController?.isNavigationBarHidden = true
            navRightVC.isNavigationBarHidden = true

            let slideMenuController = ExSlideMenuController(mainViewController: navMainVC, rightMenuViewController: navRightVC)
            slideMenuController.delegate = objMainVC
            slideMenuController.changeLeftViewWidth(UIScreen.main.bounds.width - 60)
            slideMenuController.changeRightViewWidth(UIScreen.main.bounds.width - 60)

            let sideMenuNavVC : UINavigationController = UINavigationController(rootViewController: slideMenuController)
            sideMenuNavVC.navigationBar.isHidden = true
            sideMenuNavVC.navigationController?.isNavigationBarHidden = true

            Util.slideMenuController = slideMenuController
//            Util.sideMenuNavVC = sideMenuNavVC
            
            self.window?.rootViewController = sideMenuNavVC
    //        self.window?.makeKeyAndVisible()
        }
    
    func loadLoginVC() {
//        let objLoginVC = LoginVC()
        let objLoginVC = ContestantProfileVC()
        
        let navVc : UINavigationController = UINavigationController(rootViewController: objLoginVC)
        navVc.navigationBar.isHidden = true
        navVc.navigationController?.isNavigationBarHidden = true
        
        self.window?.rootViewController = navVc
        self.window?.makeKeyAndVisible()
    }
}

// Date : 3 April, 2020
// Issue No : Done -> 38, 53, 70, 108, Aspect ratio in imageview

