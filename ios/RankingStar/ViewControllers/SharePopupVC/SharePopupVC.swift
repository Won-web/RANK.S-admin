//
//  LoginVC.swift
//  RankingStar
//
//  Created by Jinesh on 13/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit
import Material
import FBSDKLoginKit
import FBSDKShareKit
import Social
import Photos
import KakaoMessageTemplate
import KakaoLink

class SharePopupVC: BaseVC {
    
    // var objChargingStarHistoryModel : ChargingStarHistoryModel!
    @IBOutlet var btnTalk: UIButton!
    @IBOutlet var btnFacebook: UIButton!
    @IBOutlet var btnInstagram: UIButton!
    @IBOutlet var btnClose: UIButton!
    
    @IBOutlet var lblShareViewTitle: UILabel!
    
    let btnFBSDKShareButton : FBShareButton = FBShareButton()
    var shareDialog: ShareDialog!
    var imgContestantProfile:UIImage!
    var objUserProfileModel:UserProfileModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareDialog = ShareDialog()
        //  objChargingStarHistoryModel = ChargingStarHistoryModel(vc: self)
        
        
        setUIColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissAlertInfoPresenter()
    }
    
    //MARK: custom method
    func setUIColor()
    {
        self.view.backgroundColor = Constant.Color.VIEW_TRANSPERENT_BG_POPUP_COLOR
        lblShareViewTitle.setHeaderUIStyleWhite(value: "LBL_SHARE_VIEW_TITLE")
        btnTalk.setBackgroundImage(UIImage(named: Constant.Image.talk), for: .normal)
        btnFacebook.setBackgroundImage(UIImage(named: Constant.Image.facebook), for: .normal)
        btnInstagram.setBackgroundImage(UIImage(named: Constant.Image.insta), for: .normal)
        btnClose.setBackgroundImage(UIImage(named: Constant.Image.round_closed), for: .normal)
        btnClose.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        btnTalk.setBtnRoundUI()
        btnFacebook.setBtnRoundUI()
        btnInstagram.setBtnRoundUI()
        btnClose.setBtnRoundUI()
        
    }
    
    func sharePostOnKakaoTalk()
    {
        //  let url = "http://k.kakaocdn.net/dn/jTUdq/btqgeR1hshG/tXkLY8RuDwFN8ziujgupB0/kakaolink40_original.png"
        //http://etechservices.biz/rankingstar/assets/images/ranking_star_logo.png
        
        let template = KMTFeedTemplate {(feedTemplateBuilder) in
            
            feedTemplateBuilder.content = KMTContentObject (builderBlock: {(contentBuilder) in
                contentBuilder.title = "\(self.objUserProfileModel.strContestName!) - \(self.objUserProfileModel.strUserName!) \("PLEASE_SUPPORT_PARTICIPANTS".localizedLanguage())" // (Name of contest) - (Name of Contestant) 참가자를 응원해주세요
//                contentBuilder.title =  Util.applicationName //"RankingStar"
//                contentBuilder.desc = "ALT_SHARE_IF_APP_NOT_INSTALL".localizedLanguage()
                
                if(self.objUserProfileModel.strImageUrl != nil)
                {
                    contentBuilder.imageURL = URL (string: self.objUserProfileModel.strImageUrl )!
                }else
                {
                    contentBuilder.imageURL = URL (string: "http://etechservices.biz/rankingstar/assets/images/ranking_star_logo.png")!
                }
                
                contentBuilder.link = KMTLinkObject (builderBlock: {(linkBuilder) in
                    //       linkBuilder.mobileWebURL = URL (string: "https://apps.apple.com/us/app/kakaotalk/id362057947")!
                    linkBuilder.webURL = URL (string: "http://rankingstar.cafe24.com/api/shareContestantOnFacebook?contest_id=\(self.objUserProfileModel.strContestId!)&contestant_id=\(self.objUserProfileModel.strContestantId!)&language=\("LANGUAGE_DEFAULT".localizedLanguage())")!
                    
                    linkBuilder.iosExecutionParams = "contest_id=\(self.objUserProfileModel.strContestId!)&contestant_id=\(self.objUserProfileModel.strContestantId!)&language=\("LANGUAGE_DEFAULT".localizedLanguage())"
                    
                    linkBuilder.androidExecutionParams = "contest_id=\(self.objUserProfileModel.strContestId!)&contestant_id=\(self.objUserProfileModel.strContestantId!)&language=\("LANGUAGE_DEFAULT".localizedLanguage())"
                    
                    linkBuilder.mobileWebURL = URL (string: "http://rankingstar.cafe24.com/api/shareContestantOnFacebook?contest_id=\(self.objUserProfileModel.strContestId!)&contestant_id=\(self.objUserProfileModel.strContestantId!)&language=\("LANGUAGE_DEFAULT".localizedLanguage())")!
                    
                })
            })
            
//            feedTemplateBuilder.addButton ( KMTButtonObject (builderBlock: {(buttonBuilder) in
//                buttonBuilder.title = "BTN_TITLE_SHOW_SHARE_POST".localizedLanguage()
//                buttonBuilder.link = KMTLinkObject (builderBlock: {(linkBuilder) in
//                    linkBuilder.mobileWebURL = URL (string: "http://rankingstar.cafe24.com/api/shareContestantOnFacebook?contest_id=\(self.objUserProfileModel.strContestId!)&contestant_id=\(self.objUserProfileModel.strContestantId!)&language=\("LANGUAGE_DEFAULT".localizedLanguage())")!
//                    //                       linkBuilder.mobileWebURL = URL (string: "https://apps.apple.com/us/app/%EB%84%A4%EC%9D%B4%EB%B2%84-naver/id393499958")!
//                })
//            }))
            
//            feedTemplateBuilder.addButton ( KMTButtonObject (builderBlock: {(buttonBuilder) in
//                buttonBuilder.title = "BTN_TITLE_SHOW_SHARE_POST".localizedLanguage()// the app
//                buttonBuilder.link = KMTLinkObject (builderBlock: {(linkBuilder) in
//                    linkBuilder.iosExecutionParams = "contest_id=\(self.objUserProfileModel.strContestId!)&contestant_id=\(self.objUserProfileModel.strContestantId!)&language=\("LANGUAGE_DEFAULT".localizedLanguage())"
//                    linkBuilder.androidExecutionParams = "contest_id=\(self.objUserProfileModel.strContestId!)&contestant_id=\(self.objUserProfileModel.strContestantId!)&language=\("LANGUAGE_DEFAULT".localizedLanguage())"
//                })
//            }))
        }
        
        KLKTalkLinkCenter.shared().sendDefault (with: template, success: {(warningMsg, argumentMsg) in
            printDebug ( "warning message: \(String (describing: warningMsg))" )
            printDebug ( "argument message: \(String (describing: argumentMsg))" )
        }, failure: {(error) in
            AlertPresenter.alertInformation(fromVC: self, message: "INTERNAL_SERVER_ERROR")
        })
    }
    
    // facebook login and get user Details
    func customFacebookLoginButton()
    {
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.hideProgress()
        }
        let loginManager = LoginManager()
        loginManager.logOut()
        //        loginManager.logOut()
        //        AccessToken.current = nil
        //        Profile.current = nil
        self.showProgress()
        loginManager.logIn(permissions: ["public_profile"], from: self) { (result, error) in
            self.hideProgress()
            if error != nil{
                printDebug("error \(String(describing: error))")
                DispatchQueue.main.async {
                    AlertPresenter.alertInformation(fromVC: self, message: "Connection_with_facebook_not_success_fully")
                    return
                }
            }
            if(result != nil)
            {
                if(result?.isCancelled)! {
                    DispatchQueue.main.async {
                        AlertPresenter.alertInformation(fromVC: self, message: "Connection_with_facebook_not_success_fully")
                        
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        self.btnFBSDKShareLinkContent()
                    }
                    //self.btnFBSDKShareButton.sendActions(for: .touchUpInside)
                    //self.setAletr(title: "", message: NSLocalizedString("Click_on_Post_to_share_app", comment: "Click on Post to share app"))
                    
                }
            }
        }
    }
    
    func showUserEmailDetail()
    {
        GraphRequest(graphPath: "me", parameters: ["fields":"email, id,name,first_name,gender"]).start { (connection, result, error) in
            if error != nil
            {
                //                AlertPresenter.alertInformation(fromVC: self, message: "Connection_with_facebook_not_success_fully")
                return
            }
            printDebug("result : \(result as! NSDictionary)")
        }
    }
    
    // share application detail on facebook
    func shareApplicationOnfaceBook()
    {
        let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
       // facebookComposer?.setInitialText("Enjoy the devotional hymns of Hanuman Chalisa on your iPhone and worship Lord Hanuman to fulfil your life.")
        facebookComposer?.add(URL(string: "https://newsroom.fb.com/"))
       // facebookComposer?.add(UIImage(named: "hanuman"))
        
        self.present(facebookComposer!, animated: true, completion: {
            AlertPresenter.alertInformation(fromVC: self, message: "Click_on_Post_to_share_app")
            
        })
    }
    
    // facebook share link content
    func btnFBSDKShareLinkContent()
    {
        let content : ShareLinkContent = ShareLinkContent()
//        content.contentURL = URL(string: "http://itunes.apple.com/in/app/hanuman-chalisha-free/id327904895?mt=8")!
//        content.contentURL = URL(string: "https://newsroom.fb.com/")!
//        content.contentURL = URL(string: "http://www.etechservices.biz/rankingstar/api/shareContestantOnFacebook?contest_id=\(objUserProfileModel.strContestId!)&contestant_id=\(objUserProfileModel.strContestantId!)")!
        
        content.contentURL = URL(string: "http://rankingstar.cafe24.com/api/shareContestantOnFacebook?contest_id=\(objUserProfileModel.strContestId!)&contestant_id=\(objUserProfileModel.strContestantId!)&language=\("LANGUAGE_DEFAULT".localizedLanguage())")!
        
//        http://rankingstar.cafe24.com/api/shareContestantOnFacebook?contest_id=1&contestant_id=1&language=korean
        
        btnFBSDKShareButton.shareContent = content
        
        btnFBSDKShareButton.frame = CGRect(x: 0.0, y: 0.0, width: 0.01, height: 0.01)
        self.view.addSubview(btnFBSDKShareButton)
        
        shareDialog.shareContent = content
        shareDialog.delegate = self
        shareDialog.fromViewController = self
        
        shareDialog.mode = .web
        if(shareDialog.show() == false)
        {
            shareDialog.show()
        }
        self.hideProgress()
        
    }
    
    func saveImageToDocumentDirectory(image: UIImage ) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "insta_image001.igo" // name of the image to be saved
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 1.0),!FileManager.default.fileExists(atPath: fileURL.path){
            do {
                try data.write(to: fileURL)
                printDebug("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    
    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image!
        }
        return UIImage.init(named: "default.png")!
    }
    
    func loadImageFromDocumentDirectoryPath(nameOfImage : String) -> String {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if var dirPath = paths.first{
            
            //            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            dirPath.append(nameOfImage)
            return dirPath
            //            let image    = UIImage(contentsOfFile: imageURL.path)
            //            return image!
        }
        return ""
    }
    
    
    
    
    @objc func shareToInstagram(image:UIImage)
    {
        let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
        
        let assetID = request.placeholderForCreatedAsset?.localIdentifier ?? ""
        let shareStr = "instagram://library?LocalIdentifier=" + assetID
        let shareUrl:URL? = URL(string: shareStr)
        
        
        if #available(iOS 13.0, *) {
            self.view.window?.windowScene?.open(shareUrl!, options: nil, completionHandler: { (isOpen) in
                if(!isOpen)
                {
                    AlertPresenter.alertInformation(fromVC: self, message: "ALERT_INSTAGRAM_NOT_INSTALLD")
                }
            })
        } else {
            if UIApplication.shared.canOpenURL(shareUrl!) {
                UIApplication.shared.open(shareUrl!)
            } else {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_INSTAGRAM_NOT_INSTALLD")
            }
        }
    }
    
    @objc func shareImageToInstagram(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        let dirPath          = paths.first
        let imageURL = URL(fileURLWithPath: dirPath!).appendingPathComponent("Image2.igo").absoluteString
        let shareStr = "instagram://library?LocalIdentifier=" + imageURL
        let shareUrl:URL? = URL(string: shareStr)
        
        
        if #available(iOS 13.0, *) {
            self.view.window?.windowScene?.open(shareUrl!, options: nil, completionHandler: { (isOpen) in
                if(!isOpen)
                {
                    AlertPresenter.alertInformation(fromVC: self, message: "ALERT_INSTAGRAM_NOT_INSTALLD")
                }
            })
        } else {
            if UIApplication.shared.canOpenURL(shareUrl!) {
                UIApplication.shared.open(shareUrl!)
            } else {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_INSTAGRAM_NOT_INSTALLD")
            }
        }
    }
    
    func shareDirectMessageToInstagram(stickerImage:UIImage,backgrundImage:UIImage,contentUrl: String)
    {
        // not working
        //        if let storyUrl = URL(string: "instagram://library")
        //        if let storyUrl = URL(string: "instagram://app")
        if let storyUrl = URL(string: "instagram://share")
        {
            guard let stickerImageData = stickerImage.pngData() else { return }
            guard let backgrundImageData = backgrundImage.pngData() else { return }
            let pastboardItems:[String : Any] = [
                "com.instagram.sharedSticker.stickerImage" : stickerImageData,
                "com.instagram.sharedSticker.contentURL" : contentUrl
            ]
            //            "com.instagram.sharedSticker.backgroundImage" : backgrundImageData,
            
            let pasteboardOption = [
                UIPasteboard.OptionsKey.expirationDate : Date().addingTimeInterval(60*24)
            ]
            UIPasteboard.general.setItems([pastboardItems], options: pasteboardOption)
            UIPasteboard.general.string = "Hello world"
            if #available(iOS 13.0, *) {
                self.view.window?.windowScene?.open(storyUrl, options: nil, completionHandler: { (isOpen) in
                    if(!isOpen)
                    {
                        AlertPresenter.alertInformation(fromVC: self, message: "ALERT_INSTAGRAM_NOT_INSTALLD")
                    }
                })
            } else {
                if UIApplication.shared.canOpenURL(storyUrl) {
                    UIApplication.shared.open(storyUrl)
                } else {
                    AlertPresenter.alertInformation(fromVC: self, message: "ALERT_INSTAGRAM_NOT_INSTALLD")
                }
            }
        }
    }
    
    func shareStoryToInstagram(stickerImage:UIImage,backgrundImage:UIImage,contentUrl: String)
    {
        
        if let storyUrl = URL(string: "instagram-stories://share")
        {
            guard let stickerImageData = stickerImage.pngData() else { return }
//            guard let backgrundImageData = backgrundImage.pngData() else { return }
            //
            let pastboardItems:[String : Any] = [
                "com.instagram.sharedSticker.stickerImage" : stickerImageData,
//                "com.instagram.sharedSticker.backgroundImage" : backgrundImageData,
                "com.instagram.sharedSticker.contentURL" : contentUrl
            ]
            let pasteboardOption = [
                UIPasteboard.OptionsKey.expirationDate : Date().addingTimeInterval(60*24)
            ]
            UIPasteboard.general.setItems([pastboardItems], options: pasteboardOption)
            
            if #available(iOS 13.0, *) {
                self.view.window?.windowScene?.open(storyUrl, options: nil, completionHandler: { (isOpen) in
                    if(!isOpen)
                    {
                        AlertPresenter.alertInformation(fromVC: self, message: "ALERT_INSTAGRAM_NOT_INSTALLD")
                    }
                })
            } else {
                if UIApplication.shared.canOpenURL(storyUrl) {
                    UIApplication.shared.open(storyUrl)
                } else {
                    AlertPresenter.alertInformation(fromVC: self, message: "ALERT_INSTAGRAM_NOT_INSTALLD")
                }
            }
        }
    }
    
    func shareToInstagramActivityManager()
    {
        let image = UIImage(named: Constant.Image.splace_screen1)
        let AppName:String =  Util.applicationName
        // let url:URL =  URL(string: "www.google.com")!
        let objectsToShare: [AnyObject] = [image!,AppName as AnyObject]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.message,UIActivity.ActivityType.mail,UIActivity.ActivityType.openInIBooks ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    //MARK:- Button clicked
    @IBAction func btnTalkClicked(_ sender: UIButton) {
        if(Util.isNetworkReachable()) {
            sharePostOnKakaoTalk()
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    @IBAction func btnFacebookClicked(_ sender: UIButton) {
        if(Util.isNetworkReachable()) {
            customFacebookLoginButton()
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
        
    }
    @IBAction func btnInstagramClicked(_ sender: UIButton) {
        if(Util.isNetworkReachable()) {
            let imageBG:UIImage = UIImage(named: Constant.Image.splace_screen1)!
            let imageForground:UIImage = imgContestantProfile //UIImage(named: "splace_screen1")!
            //        shareToInstagramActivityManager()
            shareStoryToInstagram(stickerImage: imageForground, backgrundImage: imageBG, contentUrl: "https://google.com/")
            //        UIImageWriteToSavedPhotosAlbum(imageForground, self, #selector(shareImageToInstagram(_:didFinishSavingWithError:contextInfo:)), nil)
            //        UIImageWriteToSavedPhotosAlbum(imageForground, self, #selector(shareToInstagram(image: imageForground)), nil)
            //        shareToInstagram(image: imageForground)
            //shareDirectMessageToInstagram(stickerImage: imageForground, backgrundImage: imageBG, contentUrl: "https://google.com/")
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
        
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SharePopupVC: SharingDelegate
{
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        AlertPresenter.alertInformation(fromVC: self, message: "Post_share_successfully")
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        AlertPresenter.alertInformation(fromVC: self, message: "Post_not_share_successfully")
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        AlertPresenter.alertInformation(fromVC: self, message: "Post_not_share_successfully")
    }
    
    func setAletr(title: String, message: String)
    {
        AlertPresenter.alertInformation(fromVC: self, message: message)
        //        let alert1 = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("Ok", comment: "Ok"))
        //        alert1.show()
    }
}



