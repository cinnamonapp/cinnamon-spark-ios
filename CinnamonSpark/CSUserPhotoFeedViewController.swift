//
//  CSPhotoBrowserViewController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSUserPhotoFeedViewController: CSPhotoBrowser, CSCameraDelegate, CSAPIRequestDelegate, UIWebViewDelegate {
    
    var webView : UIWebView!
    
    override init(){
        super.init()
        self.title = "You"
        self.tabBarItem = UITabBarItem(title: "You", image: UIImage(named: "Meals"), tag: 1)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.setQuirkyMessage(UserFeedQuirkyMessages.sample())
    }
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
        
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
//        self.navigationController?.appendMisterCinnamon()
        
        self.view.backgroundColor = viewsBackgroundColor
        
        // Add web view
        var webframe = self.view.frame
        
        self.webView = UIWebView(frame: webframe)
        self.webView.delegate = self
        self.webView.backgroundColor = viewsBackgroundColor
        let url = NSURL(string: "\(primaryAPIEndpoint)/users/\(CSAPIRequest().uniqueIdentifier())/meals")
        webView.loadRequest(NSURLRequest(URL: url!))
        self.view.addSubview(webView)
        
    }
    
    
    // MARK: - Webview delegate methods
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        // Assuming fragment is the id of a meal_record
        if let fragment = request.URL.fragment{
            self.openMealDetailViewControllerWithPhotoId(fragment, animated: true)
            
            return false
        }
        
        return true
    }
    
    func openMealDetailViewControllerWithPhotoId(photoId: String, animated: Bool){
        let mealDetailViewController = CSMealRecordDetailView(photoId: photoId)
        
        self.presentViewController(mealDetailViewController, animated: animated, completion: nil)
    }
    
}

