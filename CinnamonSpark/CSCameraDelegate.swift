//
//  CSCameraDelegate.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 23/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit
@objc
protocol CSCameraDelegate {
    
    optional func didTakePicture(image: UIImage, withSelectionValue selectedValue: AnyObject)
}
