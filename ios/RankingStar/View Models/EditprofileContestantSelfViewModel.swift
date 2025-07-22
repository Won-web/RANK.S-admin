//
//  LeadViewModel.swift
//  HafoosCRM
//
//  Created by etech-9 on 26/11/19.
//  Copyright © 2019 Tushar S. All rights reserved.
//

import UIKit
import Photos

class EditprofileContestantSelfViewModel: NSObject {

    private var vcRef : EditprofileContestantSelfVC!
    var arrImageAndVideoList:[ImageAndVideoList] = []
    
    var arrImageList : [ImageAndVideoList] = []
    
    var objUserProfileModel = UserProfileModel()
//    var arrMyMediaGallaryModel = [MyMediaGallaryModel]()
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : EditprofileContestantSelfVC!) {
        super.init()
        vcRef = vc
    }
    
    func setDataInImageVideoArray(arrMyMediaGallaryModel: [MyMediaGallaryModel])
    {
        arrImageAndVideoList.removeAll()
        for objMedia in arrMyMediaGallaryModel
        {
            if(objMedia.srtMediaType == Constant.ResponseParam.MEDIA_TYPE_IMAGE)
            {
                let objImageAndVideoList = ImageAndVideoList()
                objImageAndVideoList.isImage = true
                objImageAndVideoList.isYouTubeVideo = false
                objImageAndVideoList.objMyImage.isUrl = true
                objImageAndVideoList.objMyImage.strUrl = objMedia.srtMediaPath
                objImageAndVideoList.objMyImage.strThumbUrl = objMedia.srtThumbPath
                objImageAndVideoList.objMyImage.objMyMediaGallaryModel = objMedia
                arrImageList.append(objImageAndVideoList)
                arrImageAndVideoList.append(objImageAndVideoList)
            }else if (objMedia.srtMediaType == Constant.ResponseParam.MEDIA_TYPE_YOUTUBE_VIDEO)
            {
                let objImageAndVideoList = ImageAndVideoList()
                objImageAndVideoList.isImage = false
                objImageAndVideoList.isYouTubeVideo = true
                objImageAndVideoList.objMyVideo.isFromServerUrl = false
                objImageAndVideoList.objMyVideo.strUrl = objMedia.srtMediaPath
                objImageAndVideoList.objMyVideo.strThumbUrl = objMedia.srtThumbPath
                objImageAndVideoList.objMyVideo.objMyMediaGallaryModel = objMedia
//                arrImageAndVideoList.append(objImageAndVideoList)
            }else {
                let objImageAndVideoList = ImageAndVideoList()
                objImageAndVideoList.isImage = false
                objImageAndVideoList.isYouTubeVideo = false
                objImageAndVideoList.objMyVideo.isFromServerUrl = true
                objImageAndVideoList.objMyVideo.strUrl = objMedia.srtMediaPath
                objImageAndVideoList.objMyVideo.strThumbUrl = objMedia.srtThumbPath
                objImageAndVideoList.objMyVideo.objMyMediaGallaryModel = objMedia
                arrImageAndVideoList.append(objImageAndVideoList)
            }
        }
    }
    //MARK:- Right Buttons
    
   
    
    //MARK:- Lead List Data
    
    func getTableNumberOfSection() -> Int {
        return arrImageAndVideoList.count
    }
    
    func setUserProfileAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()
        	
        requestHelper.setUserProfileSelfAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                self.vcRef.onProfileUpdateApiCompleted(isSuccess:true, message: resMessage)
//                arrChargingHistoryModel = resObj as! arrChargingHistoryModel
               
            }
            else{
                self.vcRef.onProfileUpdateApiCompleted(isSuccess:false, message: resMessage)
            }
        })
    }
    
    func getMediaGallaryAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()

        requestHelper.getMediaGallaryAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in

            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                var arrMyMediaGallaryModel = [MyMediaGallaryModel]()
                arrMyMediaGallaryModel.removeAll()
                let objMyMediaGallaryModel = resObj as! MyMediaGallaryModel
                
                arrMyMediaGallaryModel = objMyMediaGallaryModel.arrMyMediaGallaryModel
                self.arrImageAndVideoList.removeAll()
                for objMedia in arrMyMediaGallaryModel
                {
                    if(objMedia.srtMediaType == Constant.ResponseParam.MEDIA_TYPE_IMAGE)
                    {
                        let objImageAndVideoList = ImageAndVideoList()
                        objImageAndVideoList.isImage = true
                        objImageAndVideoList.objMyImage.isUrl = true
                        objImageAndVideoList.objMyImage.strUrl = objMedia.srtThumbPath
                        objImageAndVideoList.objMyImage.objMyMediaGallaryModel = objMedia
                        self.arrImageAndVideoList.append(objImageAndVideoList)
                    }else
                    {
                        let objImageAndVideoList = ImageAndVideoList()
                        objImageAndVideoList.isImage = false
                        objImageAndVideoList.objMyVideo.isFromServerUrl = true
                        objImageAndVideoList.objMyVideo.strUrl = objMedia.srtMediaPath
                        objImageAndVideoList.objMyVideo.objMyMediaGallaryModel = objMedia
                        self.arrImageAndVideoList.append(objImageAndVideoList)
                    }
                }
                self.vcRef.mediaGallarySuccessResponse()
            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
    
//    func getContestantDetailsAPI(objUser : UserProfileModel) {
//            let requestHelper = RequestHelper()
//
//            requestHelper.getContestantDetailsAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
//
//                self.vcRef.onApiSuccessHideProgress()
//                if resCode == Constant.ResponseStatus.SUCCESS {
//                    self.objUserProfileModel = resObj as! UserProfileModel
//                    self.vcRef.contestantDetailSuccessResponse()
//    //                arrChargingHistoryModel = resObj as! arrChargingHistoryModel
//
//                }
//                else{
//                    self.vcRef.showMessage(message: resMessage)
//                }
//            })
//        }
    
    func imageArrayUploadApi(objUser : UserProfileModel,indexToUpload:Int,totalImageToUpload:Int) {
        let requestHelper = RequestHelper()
        
        requestHelper.imageArrayUploadApi(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                self.vcRef.isImageUpdateApiSuccess(isSuccess:true,indexToUpload:indexToUpload,totalImageToUpload:totalImageToUpload)
                //                arrChargingHistoryModel = resObj as! arrChargingHistoryModel
                
            }
            else{
                self.vcRef.isImageUpdateApiSuccess(isSuccess:false,indexToUpload:indexToUpload,totalImageToUpload:totalImageToUpload)
            }
        })
    }
    
    
    
    func deleteMediaGalleryItemAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()
        
        requestHelper.deleteMediaGalleryItemAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                self.vcRef.successMediaGalleryItemDelete(isSuccess: true)
            }
            else{
                self.vcRef.successMediaGalleryItemDelete(isSuccess: false)
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
    
    
}
