//
//  YoutubePlayerVC.swift
//  MrZzz
//
//  Created by eTech on 23/10/19.
//  Copyright © 2019 eTech. All rights reserved.
//

import UIKit
import YoutubePlayerView

class YoutubePlayerVC: BaseVC {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var youtubePlayer: YoutubePlayerView!
    var url_YouTube_Key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        navBar.setUI(navBarText: "RANKING_STAR") //2020 Analyst Korea
        self.leftBarButton(navBar : navBar , imgName : Constant.Image.back_black)
        
        youtubePlayer.delegate = self
        let videoID = extractYoutubeIdFromLink(link: url_YouTube_Key)
        youtubePlayer.loadWithVideoId(videoID!)
    }

    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscape, andRotateTo: UIInterfaceOrientation.landscapeLeft)
        navBar.isHidden = false
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portraitUpsideDown)
        navBar.isHidden = true
    }
    
    func extractYoutubeIdFromLink(link: String) -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0,length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }
    
    override func leftBarButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
}


extension YoutubePlayerVC: YoutubePlayerViewDelegate {
    
    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState) {
        switch state {
        case .ended:
            self.navigationController?.popViewController(animated: true)
            break
        default: break
        }
    }
}

