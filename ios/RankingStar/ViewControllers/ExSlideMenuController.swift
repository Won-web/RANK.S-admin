//
//  ExSlideMenuController.swift
//  HafoosCRM
//
//  Created by etech-9 on 25/11/19.
//  Copyright © 2019 Tushar S. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ExSlideMenuController: SlideMenuController {

    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if vc is ChargingStarHistoryVC ||
            vc is WebViewWithTabVC ||
            vc is WebViewVC ||
            vc is SettingVC ||
            vc is PushNotificationListVC ||
            vc is NoticeVC ||
            vc is SignUpVC ||
            vc is LoginVC ||
            vc is EditUserProfileVC ||
            vc is TearmAndConditionVC ||
            //vc is GiftVC ||
            vc is MainVC {
                return true
            }
        }
        return false
    }
    
    
    override func track(_ trackAction: TrackAction) {
        switch trackAction {
        case .leftTapOpen:
            print("TrackAction: left tap open.")
        case .leftTapClose:
            print("TrackAction: left tap close.")
        case .leftFlickOpen:
            print("TrackAction: left flick open.")
        case .leftFlickClose:
            print("TrackAction: left flick close.")
        case .rightTapOpen:
            print("TrackAction: right tap open.")
        case .rightTapClose:
            print("TrackAction: right tap close.")
        case .rightFlickOpen:
            print("TrackAction: right flick open.")
        case .rightFlickClose:
            print("TrackAction: right flick close.")
        }
    }
}
