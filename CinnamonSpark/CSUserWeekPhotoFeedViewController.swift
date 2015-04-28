//
//  CSPhotoBrowserViewController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSUserWeekPhotoFeedViewController: CSPhotoBrowser, CSCameraDelegate, CSAPIRequestDelegate, UIWebViewDelegate {
    
//    var userPhotoFeedViewController : CSUserPhotoFeedViewController!
    
    var cameraViewController : CSCameraViewController!
    
    var webView : UIWebView!
    
    override init(){
        super.init()
        self.title = "Week"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setQuirkyMessage("Let's have a look\n at your patterns together.")
    }
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
        
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.view.backgroundColor = viewsInsideBackgroundColor
        
        // Add web view
        var webframe = self.view.frame
        let tabBarHeight = self.tabBarController?.tabBar.frame.height as CGFloat!
        
        webframe.origin.y += 10
        webframe.size.height = webframe.size.height - tabBarHeight - 50
        
        self.webView = UIWebView(frame: webframe)
        self.webView.delegate = self
        self.webView.backgroundColor = viewsInsideBackgroundColor
        let url = NSURL(string: "\(primaryAPIEndpoint)/users/\(CSAPIRequest().uniqueIdentifier())/week_view")
        webView.loadRequest(NSURLRequest(URL: url!))
        self.view.addSubview(webView)
        
    }
    
    
    // MARK: - Webview delegate methods
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        // Assuming fragment is the id of a meal_record
        if let fragment = request.URL.fragment{
            self.openMealViewController()
            
            return false
        }
        
        return true
    }
    
    func openMealViewController(){
        // TODO: - Improve this code please with a custom navigation controller for user's needs
        if let navigation = self.navigationController as? CSUserPhotoFeedNavigationController{
            navigation.openUserPhotoFeedViewControllerAnimated(true)
        }
    }
    
    
}

