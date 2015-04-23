//
//  CSTapSelector.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 23/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSMealSizeSelector: UIView{
    
    var imageView : UIImageView!
    var selectedValueIndex : Int!
    var images = [
        UIImage(named: "DishSmall"),
        UIImage(named: "DishMedium"),
        UIImage(named: "DishLarge")
    ]
    
    convenience init(mirrorView: UIView){
        self.init()
        
        self.imageView = UIImageView()
        
        self.frame = mirrorView.frame
        
        self.selectedValueIndex = 0
        
        self.imageView.frame = self.frame
        self.imageView.frame.origin = CGPointMake(0, 0)
        self.updateImage()
        
        self.addSubview(self.imageView)
        
        // Handle tap on selector
        var tapGesture = UITapGestureRecognizer(target: self, action: "handleTapSelection:")
        self.addGestureRecognizer(tapGesture)

    }
    
    
    // MARK: - Gesture recognition
    
    // Perform action when touched
    func handleTapSelection(sender: UIGestureRecognizer){
        
        // Increment the selected value index
        self.selectedValueIndex = self.selectedValueIndex + 1
        
        // If the index is out of bounds
        if (self.selectedValueIndex >= self.images.count){
            self.selectedValueIndex = 0
        }
        
        self.updateImage()
    }
    
    private func updateImage(){
        self.imageView.image = self.images[self.selectedValueIndex]
    }
    
    func selectedValue() -> AnyObject{
        return self.selectedValueIndex + 1
    }

    
}
