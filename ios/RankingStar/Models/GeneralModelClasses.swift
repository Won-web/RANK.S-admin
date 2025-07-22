//
//  GeneralModelClasses.swift
//  Unboxdeals
//
//  Created by kETAN on 20/04/18.
//  Copyright © 2018 etech-9. All rights reserved.
//

import Foundation
import UIKit
import Photos

//MARK: CustomFacebookDataM
class CustomFacebookDataM
{
    var strEmail:String!

    var strName:String!
    var strFirstName:String!
    var strId:String!
    var strGender:String!
}

//MARK: CustomGesture
class CustomTabGestur:UITapGestureRecognizer
{
    var intIndex:Int!
    var strUrl:String!
    var strUsername : String!
    var tblCell:EditProfileMsgCell!
    var objUICollectionViewCell:UICollectionViewCell!
    var objLabel:UILabel!
    var isYouTubeVideo = false
    
}

class MyFilterModel
{
    //var strContestCategoryId:String!
    var strContestId:String!
    var strCategoryName:String!
    var isSelected:Bool = false
    var strCategoryId:String!
    var isStatusActive:Bool!
    
    
    
    
}

class UserHobbiesModel
{
    var strHobbiesName:String!
    var strHobbiesDetail:String!
}

class UserMessageInfo
{
    var isMessageViewAllClicked:Bool!
    var strMessage:String!
    var intSubMsgCount:Int!
    var strTime:String!
    var strUserName:String!
    var totalLickes:Int!
    var isLicked:Bool!
}


class ImageAndVideoList
{
    var isImage:Bool!
    var isYouTubeVideo:Bool!
    var objMyImage:MyImage = MyImage()
    var objMyVideo:MyVideo = MyVideo()
}

class MyImage
{
    var isUrl:Bool!
    var uiImage:UIImage!
    var strUrl:String!
    var strThumbUrl:String!
    var objMyMediaGallaryModel:MyMediaGallaryModel!
}

class MyVideo
{
    var isFromServerUrl:Bool!
    var strUrl:String!
    var strThumbUrl:String!
    var thumbImage : UIImage!
    var objMyMediaGallaryModel:MyMediaGallaryModel!
}

class CategoryChargingStation {
    var viewColor : UIColor!
    var title : String!
    var detail : String!
}

//class FilterCategorysModel:NSObject
//{
//    var strContestCategoryId:String!
//    var strContestId:String!
//    var strCategoryName:String!
//    var isStatusActive:Bool!
//
//}

class GradientView: UIView {

    var gradient = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupGradientView(){

        CATransaction.begin()
                CATransaction.setDisableActions(true)

        gradient.colors = [Constant.Color.BTN_GREDIENT_PINK_LEFT.cgColor, Constant.Color.BTN_GREDIENT_PINK_RIGHT.cgColor]
        //gradient.frame = self.bounds
        //        gradient.frame = UIScreen.main.bounds
        // gradient.frame = CGRect(x: 0, y: 0, width: self.frame.width + 200, height: self.frame.height)
                
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0.0 , 1.0]
        //            gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
               // gradient.cornerRadius = self.frame.height/2
                
               // self.layer.insertSublayer(gradient, at: 0)
                CATransaction.commit()
        
        
//        gradient.colors = [UIColor.black.cgColor, UIColor.red.cgColor]
//        gradient.startPoint = CGPoint.zero
//        gradient.endPoint = CGPoint(x: 0, y: 1)
//        gradient.locations = [0.8,1.0]
       // self.layer.addSublayer(gradient)

    }

}
