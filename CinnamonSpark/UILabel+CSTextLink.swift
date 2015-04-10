//
//  UILabel+CSTextLink.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 10/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

private var labelUIButtonAssociationKey: UInt8 = 0

extension UILabel {
    
    private var labelUIButton : UIButton? {
        get {
            return objc_getAssociatedObject(self, &labelUIButtonAssociationKey) as UIButton?
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &labelUIButtonAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    
    // TODO: - Take the superview automatically even when it's not there yet
    func addTarget(target: AnyObject, action: Selector, forControlEvents: UIControlEvents, passedValue: AnyObject?, superView sView: UIView){
        
        if(self.labelUIButton == nil){
            // Set the font color to make it seem a link
            self.textColor = UIColor(red: 64/255, green: 134/255, blue: 168/255, alpha: 1)
            self.userInteractionEnabled = false
            
            // Apply a transparent ui button layer on top
            self.labelUIButton = UIButton(frame: self.frame)
            self.labelUIButton?.passedValue = passedValue
            sView.addSubview(self.labelUIButton!)
        }
        
        self.labelUIButton?.addTarget(target, action: action, forControlEvents: forControlEvents)
        
    }

}


private var passedValueAssociationKey: UInt8 = 0
extension UIButton{
    var passedValue : AnyObject? {
        get{
            return objc_getAssociatedObject(self, &passedValueAssociationKey) as AnyObject?
        }
        
        set{
            objc_setAssociatedObject(self, &passedValueAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
}