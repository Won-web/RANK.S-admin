//
//  OTP.swift
//  RankingStar
//
//  Created by Hitarthi on 28/02/22.
//  Copyright © 2022 Etech. All rights reserved.
//

import UIKit

class OTP: NSObject {

    var userID : String!
    var email : String!
    var otp : Int!
    var otpFor : String!
    var password : String!
    
    static func dictToObjectConvertionFrgtPwd(dictData : NSDictionary) -> OTP {
        
        let objOTP = OTP()
        objOTP.userID = ""
        objOTP.otp = 0
        
        if let data = dictData["user_id"] as? String {
            objOTP.userID = data
        }
        
        if let data = dictData["otp"] as? Int {
            objOTP.otp = data
        }
        
        return objOTP
        
    }
    
    static func dictToObjectConvertionVerifyOTP(dictData : NSDictionary) -> OTP {
        
        let objOTP = OTP()
        objOTP.userID = ""
        
        if let profileData = dictData["profile_details"] as? [String:Any] {
            
            if let data = profileData["user_id"] as? String {
                objOTP.userID = data
            }
        }
        
        return objOTP
        
    }
    
}
