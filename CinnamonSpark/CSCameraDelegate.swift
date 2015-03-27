//
//  CSCameraDelegate.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 23/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit
@objc
protocol CSCameraDelegate : CSBaseDelegate {
    
    optional func didTakePicture(image: UIImage, withSelectionValue selectedValue: AnyObject)
    optional func didFinishUploadingPicture(thumbUrl: NSURL, originalUrl: NSURL)
}
