//
//  CSAPIRequestDelegate.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 26/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

@objc
protocol CSAPIRequestDelegate : CSBaseDelegate {
    // Used when a meal record is created
    optional func didSuccessfullyCreateMealRecord(response: NSDictionary)
}
