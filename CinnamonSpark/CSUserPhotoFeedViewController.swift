//
//  CSPhotoBrowserViewController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSUserPhotoFeedViewController: CSPhotoBrowser, CSCameraDelegate, CSAPIRequestDelegate {
    
    var cameraViewController : CSCameraViewController!
    let mealSizesArray = ["small", "medium", "large"]
    
    var webView : UIWebView!
    
    override init(){
        super.init()
        self.title = "You"
        self.tabBarItem = UITabBarItem(title: "You", image: UIImage(named: "Meals"), tag: 1)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.view.backgroundColor = viewsBackgroundColor
        
        // Add web view
        var webframe = self.view.frame
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height as CGFloat!
        let tabBarHeight = self.tabBarController?.tabBar.frame.height as CGFloat!
        webframe.origin.y = (webframe.origin.y + navigationBarHeight)
        webframe.size.height = webframe.size.height - tabBarHeight
        
        self.webView = UIWebView(frame: webframe)
        self.webView.backgroundColor = viewsBackgroundColor
        let url = NSURL(string: "\(apiEndpoints.production)/users/\(CSAPIRequest().uniqueIdentifier())/meals")
        webView.loadRequest(NSURLRequest(URL: url!))
        self.view.addSubview(webView)
        
        
    }
    
    
    
    
    // Camera stuff
    func didTakePicture(image: UIImage, withSelectionValue selectedValue: AnyObject) {
        // Save image to photo album
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func didSuccessfullyCreateMealRecord(response: NSDictionary) {
        self.webView.reload()
    }
    
    func openCamera(){
        
        cameraViewController = CSCameraViewController()
        cameraViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: cameraViewController)
        
        //        self.navigationController?.pushViewController(cameraViewController, animated: true)
        presentViewController(navigationController, animated: true, completion: nil)
    }

}

