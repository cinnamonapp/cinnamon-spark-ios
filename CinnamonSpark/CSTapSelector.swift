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
    convenience init(values: NSArray, origin: CGPoint, minimumRadius: Float?, maximumRadius: Float?){
        self.init()
        
        // Set the minimum radius from the user if it's present
        if(minimumRadius != nil){
            self.minRadius = minimumRadius!
        }
        
        // Set the maximum radius from the user if it's present
        if(maximumRadius != nil){
            self.maxRadius = maximumRadius!
        }
        
        
        
        // Set the array of values
        self.valuesSet = values
        
        // Set the origin with center anchor point
        self.setOriginFromCenter(origin)
        
        self.prepareView()
        
        // Handle tap on selector
        var tapGesture = UITapGestureRecognizer(target: self, action: "handleTapSelection:")
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Getters and setters
    
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
    
    // Returns the radius for the current selectedValueIndex
    private func radiusForSelectedValueIndex() -> Float{
        let step : Float = (self.maxRadius - self.minRadius) / Float(valuesSet.count - 1) // Calculate the step size
        let radius : Float = self.minRadius + step * Float(self._selectedValueIndex) // Starting from the minRadius add needed steps
        return radius
    }
    
    // MARK: - View operations
    
    // Returns a new frame for the given radius
    private func generateFrameForRadius(radius: Float) -> CGRect{
        var rect = CGRect()
        
        rect.origin = self.frame.origin
        
        rect.size = CGSizeMake(CGFloat(radius) * 2, CGFloat(radius) * 2)
        
        println(radius)
        
        return rect
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
    
    // Update the frame size and position
    func refreshFrame(){
        self.frame = self.generateFrameForRadius(self.radiusForSelectedValueIndex())
        self.setOriginFromCenter(self._initialOrigin)
    }
    
    // MARK: - Gesture recognition
    
    // Perform action when touched
    func handleTapSelection(sender: UIGestureRecognizer){
        
        // Increment the selected value index
        self._selectedValueIndex = self._selectedValueIndex + 1
        
        // If the index is out of bounds
        if (self._selectedValueIndex >= self.valuesSet.count){
            self._selectedValueIndex = 0
        }
        
        self.refreshFrame()
    }
    
    // MARK: - Custom drawings
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        
        /* Draw a circle */
        // Get the contextRef
        let contextRef = UIGraphicsGetCurrentContext();
        
        let lineWidth : CGFloat = 3
        let borderRect = CGRectInset(rect, lineWidth * 0.5, lineWidth * 0.5);
        
        // Set the border width
        CGContextSetLineWidth(contextRef, lineWidth)
        
        // Set the circle fill color to GREEN
//        CGContextSetRGBFillColor(contextRef, 255.0, 255.0, 255.0, 0.2)
        
        // Set the cicle border color to BLUE
        CGContextSetRGBStrokeColor(contextRef, 255.0, 255.0, 255.0, 0.7)
        
        // Fill the circle with the fill color
//        CGContextFillEllipseInRect(contextRef, rect)
        
        // Draw the circle border
        CGContextStrokeEllipseInRect(contextRef, borderRect)
    }

}
