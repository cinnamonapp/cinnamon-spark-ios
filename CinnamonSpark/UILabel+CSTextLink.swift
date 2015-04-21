//
//  UILabel+CSTextLink.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 10/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

private var passedValueAssociationKey: UInt8 = 0

extension UILabel {
    
    var passedValue : AnyObject? {
        get{
            return objc_getAssociatedObject(self, &passedValueAssociationKey) as AnyObject?
        }
        
        set{
            objc_setAssociatedObject(self, &passedValueAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    
    
    // TODO: - Take the superview automatically even when it's not there yet
    func addTarget(target: AnyObject, action: Selector, forControlEvents: UIControlEvents, passedValue: AnyObject?){
        
        // Set the font color to make it seem a link
        self.textColor = UIColor(red: 64/255, green: 134/255, blue: 168/255, alpha: 1)
        self.userInteractionEnabled = true
        self.passedValue = passedValue
        
        // Apply a transparent ui button layer on top
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        tapGesture.passedValue = passedValue
        
        self.addGestureRecognizer(tapGesture)
        
    }

}

extension UITapGestureRecognizer{
    var passedValue : AnyObject? {
        get{
            return objc_getAssociatedObject(self, &passedValueAssociationKey) as AnyObject?
        }
        
        set{
            objc_setAssociatedObject(self, &passedValueAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }

}