//
//  CSTapSelector.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 23/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSTapSelector: UIView {

    // Something like [0,1,2,3,4...]
    var valuesSet : NSArray!
    var minRadius = 50.0 as Float
    var maxRadius = 100.0 as Float

    private var _selectedValueIndex : Int!
    private var _initialOrigin : CGPoint!
    
    
    // Init the view with a set of values
    convenience init(values: NSArray, origin: CGPoint){
        self.init()
        
        // Set the array of values
        self.valuesSet = values
        
        // Set the origin with center anchor point
        self.setOriginFromCenter(origin)
        
        
        
        self.prepareView()
        
        // Handle tap on selector
        var tapGesture = UITapGestureRecognizer(target: self, action: "handleTapSelection:")
        self.addGestureRecognizer(tapGesture)
    }

    // Stuff to get the view ready to be shown
    private func prepareView(){
        // Set a transparent background
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        // Pick the first selected item
        self._selectedValueIndex = 0
        // Update frames
        self.refreshFrame()
    }
    
    // Set the origin of the view with center anchor point
    func setOriginFromCenter(origin: CGPoint){
        
        // Save the origin into initial origin if needed
        if(self._initialOrigin == nil){
            self._initialOrigin = origin
        }
        
        let halfWidth = self.frame.size.width / 2
        let halfHeight = self.frame.size.height / 2
        
        var newOrigin = origin
        newOrigin.x = newOrigin.x - halfWidth
        newOrigin.y = newOrigin.y - halfHeight
        
        self.frame.origin = newOrigin
    }
    
    func selectedValue() -> AnyObject{
        return self.valuesSet[self._selectedValueIndex]
    }
    
    private func radiusForSelectedValueIndex() -> Float{
        let step : Float = (self.maxRadius - self.minRadius) / Float(valuesSet.count - 1)
        
        return Float(self.minRadius) + Float(step) * Float(self._selectedValueIndex)
    }
    
    private func generateFrameForRadius(radius: Float) -> CGRect{
        var rect = CGRect()
        
        rect.origin = self.frame.origin
        
        rect.size = CGSizeMake(CGFloat(radius) * 2, CGFloat(radius) * 2)
        
        println(radius)
        
        return rect
    }
    
    func refreshFrame(){
        self.frame = self.generateFrameForRadius(self.radiusForSelectedValueIndex())
        self.setOriginFromCenter(self._initialOrigin)
    }
    
    func handleTapSelection(sender: UIGestureRecognizer){
        println("handling tap")
        
        self._selectedValueIndex = self._selectedValueIndex + 1
        
        var centerTransformation : CGAffineTransform
        
        if (self._selectedValueIndex >= self.valuesSet.count){
            self._selectedValueIndex = 0
        }
        
        self.refreshFrame()
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        
        /* Draw a circle */
        // Get the contextRef
        let contextRef = UIGraphicsGetCurrentContext();
        
        // Set the border width
        CGContextSetLineWidth(contextRef, 1.0)
        
        // Set the circle fill color to GREEN
//        CGContextSetRGBFillColor(contextRef, 255.0, 255.0, 255.0, 0.2)
        
        // Set the cicle border color to BLUE
        CGContextSetRGBStrokeColor(contextRef, 255.0, 255.0, 255.0, 0.7)
        
        // Fill the circle with the fill color
//        CGContextFillEllipseInRect(contextRef, rect)
        
        // Draw the circle border
        CGContextStrokeEllipseInRect(contextRef, rect)
    }

}
