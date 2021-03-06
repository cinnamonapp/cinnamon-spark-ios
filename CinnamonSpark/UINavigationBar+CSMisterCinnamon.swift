//
//  UINavigationBar+CSMisterCinnamon.swift
//  Cinnamon
//
//  Created by Alessio Santo on 21/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

private var quirkyTitleAssociationKey: UInt8 = 0

extension UIViewController{
    
    var quirkyTitle : String {
        get{
            return objc_getAssociatedObject(self, &quirkyTitleAssociationKey) as String
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &quirkyTitleAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    func appendMisterCinnamon(){
        
        // Assume that it is a normal view
        var barOrNil = self.navigationController?.navigationBar
        
        // If not present
        if (barOrNil == nil){
            // Check if it's a navigation controller
            if let navController = self as? UINavigationController{
                barOrNil = navController.navigationBar
            }
        }
        
        // Unwrap the bar and customize it
        if let bar = barOrNil{
            
            bar.appendMisterCinnamon()
            
        }
    }
    
    func setQuirkyMessage(message: String){
        self.navigationController?.navigationBar.setQuirkyMessage(message)
    }
    
    func setDishCount(value: String){
        self.navigationController?.navigationBar.setDishCount(value)
    }

}


private var quirkySentenceAssociationKey    : UInt8     = 0
private var dishCountLabelAssociationKey    : UInt8     = 0
private let navigationBarIncreaseValue      : CGFloat   = 30

extension UINavigationBar{
    
    var quirkySentence : UILabel? {
        get{
            return objc_getAssociatedObject(self, &quirkySentenceAssociationKey) as UILabel?
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &quirkySentenceAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    var dishCountLabel : UILabel? {
        get{
            return objc_getAssociatedObject(self, &dishCountLabelAssociationKey) as UILabel?
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &dishCountLabelAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    func setQuirkyMessage(message: String){
        self.quirkySentence?.text = message
    }
    
    func setDishCount(value: String){
        self.dishCountLabel?.text = value
    }
    
    private func newHeight() -> CGFloat{
        return self.frame.height + navigationBarIncreaseValue
    }
    
    private func newFrame() -> CGRect{
        var frame = self.frame
        frame.size.height = frame.size.height + navigationBarIncreaseValue
        
        return frame
    }
    
    func appendMisterCinnamon(){
        
        
        // Add an additional piece to increase navbar height
        let additionalSpace = UIView(frame: self.frame)
        additionalSpace.frame.origin.y = self.frame.height
        additionalSpace.frame.size.height = navigationBarIncreaseValue
        
        // Set the same color for the bar and the additional space
        let color = viewsBackgroundColor
        self.translucent = false
        self.barTintColor = color

        if(UINavigationBar.conformsToProtocol(UIAppearanceContainer)){
            UINavigationBar.appearance().tintColor = UIColor.blackColor()
        }
        
        additionalSpace.backgroundColor = color
        
        quirkySentence?.removeFromSuperview()
        quirkySentence = UILabel(frame: self.frame)
        
        let quirkySentenceLabel = quirkySentence!
        
        quirkySentenceLabel.frame.size.width = self.frame.size.width / 2
        quirkySentenceLabel.frame.origin.x = (self.frame.width - quirkySentenceLabel.frame.width) / 2
        quirkySentenceLabel.frame.origin.y = 20
        quirkySentenceLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        quirkySentenceLabel.numberOfLines = 0
        quirkySentenceLabel.textAlignment = NSTextAlignment.Center
        quirkySentenceLabel.font = quirkySentenceLabel.font.fontWithSize(12)
            
        self.titleTextAttributes = [
            NSFontAttributeName: quirkySentenceLabel.font.fontWithSize(1),
            NSForegroundColorAttributeName: color // so that is invisible
        ]

        
        let characterImage = UIImageView(frame: self.newFrame())
        characterImage.frame.size.width = 100
        characterImage.frame.origin.x = self.frame.width - characterImage.frame.width + 10
        characterImage.frame.origin.y = 0
        characterImage.image = UIImage(named: "MrCinnamon")
        
        let dishCountView = UIView()
        let width : CGFloat = 30
        let height : CGFloat = 30
        let xpos = quirkySentenceLabel.frame.origin.x - width
        let ypos = quirkySentenceLabel.frame.origin.y + 5
        dishCountView.frame = CGRectMake(xpos, ypos, width, height)
        
        let notificationBubble = UIImageView(image: UIImage(named: "NotificationBubble"))
        notificationBubble.frame = dishCountView.frame
        notificationBubble.frame.origin = CGPointMake(0, 0)
        
        self.dishCountLabel = UILabel(frame: notificationBubble.frame)
        self.dishCountLabel?.text = userDishCount.description
        self.dishCountLabel?.font = self.dishCountLabel?.font.fontWithSize(12)
        self.dishCountLabel?.textAlignment = NSTextAlignment.Center

        dishCountView.addSubview(notificationBubble)
        dishCountView.addSubview(self.dishCountLabel!)
        
        self.addSubview(additionalSpace)
        self.addSubview(characterImage)
        self.addSubview(quirkySentenceLabel)
//        self.addSubview(dishCountView)
        
    }
    
}



extension Array{
    func sample() -> T{
        let randomIndex = Int(arc4random_uniform(UInt32(self.count)))

        return self[randomIndex]
    }
}