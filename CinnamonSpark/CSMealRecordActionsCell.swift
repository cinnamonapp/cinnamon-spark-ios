//
//  CSMealRecordActionsCell.swift
//  Cinnamon
//
//  Created by Alessio Santo on 16/06/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSMealRecordActionsCell: UICollectionViewCell {
    
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var commentButtonItem: CSCommentBarButtonItem!
    @IBOutlet var loveButtonItem: CSLoveBarButtonItem!
    
    override init() {
        super.init()
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    func configure(){
        
    }
    
    override func awakeFromNib() {
        self.addConstraint(NSLayoutConstraint(item: self.toolbar, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        backgroundColor = UIColor.clearColor()
    }
    
    override func layoutSubviews() {
        commentButtonItem.customView?.frame = bounds
        loveButtonItem.customView?.frame = bounds
        
        toolbar.frame = bounds
    }
}

class CSCommentBarButtonItem : CSIconLabelBarButtonItem{
    override var iconReservedWidth : CGFloat{
        get{
            return 0.6
        }
    }
    override var labelReservedWidth : CGFloat{
        get{
            return 0.4
        }
    }
    
    override func configure() {
        super.configure()
        iconImage = UIImage(named: "bubble")
    }
}

class CSLoveBarButtonItem : CSIconLabelBarButtonItem{
    override var iconReservedWidth : CGFloat{
        get{
            return 0.6
        }
    }
    override var labelReservedWidth : CGFloat{
        get{
            return 0.4
        }
    }
    
    var isLoved : Bool {
        get{
            return _isLoved
        }
        
        set{
            _isLoved = newValue
            updateIcon()
        }
    }
    var _isLoved = false
    
    override func configure() {
        super.configure()
        isLoved = false
    }
    
    func updateIcon(){
        if(isLoved){
            iconImage = UIImage(named: "heart-filled")
        }else{
            iconImage = UIImage(named: "heart")
        }
    }
}

class CSIconLabelBarButtonItem: UIBarButtonItem{
    
    private let iconImageView : UIImageView = UIImageView()
    let icon    : UIButton  = UIButton()
    
    let label   : UILabel   = UILabel()
    
    var iconReservedWidth : CGFloat{
        get{
            return 0.3
        }
    }
    var labelReservedWidth : CGFloat{
        get{
            return 0.7
        }
    }
    
    override var target : AnyObject?{
        get{
            return super.target
        }
        
        set{
            super.target = newValue
            prepareForInteraction()
        }
    }
    
    override var action : Selector{
        get{
            return super.action
        }
        
        set{
            super.action = newValue
            prepareForInteraction()
        }
    }
    
    var iconImage : UIImage? {
        get{
            return iconImageView.image
        }
        
        set{
            if let image = newValue{
                iconImageView.image = newValue
            }
        }
    }
    
    override init() {
        super.init()
        configure()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure(){
        customView = UIView()
        
        icon._parent_ = self
        
        label.font = DefaultFont?.fontWithSize(12)
        label.textColor = ColorPalette.DefaultTextColor

        
        iconImageView.contentMode = UIViewContentMode.ScaleAspectFit
        icon.addSubview(iconImageView)
        
        customView?.addSubview(icon)
        customView?.addSubview(label)
        
        updateFrames()
    }
    
    func updateFrames(){
        icon.frame = CGRectMake(0, 0, width * iconReservedWidth, 44)
        icon.frame.origin.x = width / 2 - icon.frame.width / 2 // Center the icon
        iconImageView.frame = icon.bounds
        iconImageView.frame.size.width = icon.frame.width
        
        label.frame = CGRectMake(CGRectGetMaxX(icon.frame) + 5, 0, width * labelReservedWidth, 44)
    }
    
    override func awakeFromNib() {
        
    }
    
    func prepareForInteraction(){
        // Touch events
        
        if let target: AnyObject = self.target{
            
            label.passedArguments = self.passedArguments
            icon.passedArguments = self.passedArguments
            
            label.addTarget(target, action: self.action, passedArguments: passedArguments)
            icon.addTarget(target, action: self.action, forControlEvents: UIControlEvents.TouchUpInside)
            
            
        }
    }

}



@objc
protocol Argumentable{
    var passedArguments : AnyObject?{get set}
    
    optional func setTarget(target: AnyObject?, action: Selector, passedArguments: AnyObject?)
}

@objc
protocol Parentable{
    var _parent_ : AnyObject?{get set}
}

private var passedArgumentsAssociationKey: UInt8 = 0
extension UILabel : Argumentable{
    var passedArguments : AnyObject? {
        get{
            return objc_getAssociatedObject(self, &passedArgumentsAssociationKey) as AnyObject?
        }
        
        set{
            objc_setAssociatedObject(self, &passedArgumentsAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    func addTarget(target: AnyObject?, action: Selector, passedArguments: AnyObject?) {
        self.userInteractionEnabled = true
        self.passedArguments = passedArguments
        
        // Apply a transparent ui button layer on top
        let tapGesture = UITapGestureRecognizer(target: target!, action: action)
        tapGesture.passedArguments = passedArguments
        
        self.addGestureRecognizer(tapGesture)
    }
}


extension UIButton : Argumentable{
    var passedArguments : AnyObject? {
        get{
            return objc_getAssociatedObject(self, &passedArgumentsAssociationKey) as AnyObject?
        }
        
        set{
            objc_setAssociatedObject(self, &passedArgumentsAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
}

private var _parent_AssociationKey: UInt8 = 0
extension UIButton : Parentable{
    var _parent_ : AnyObject? {
        get{
            return objc_getAssociatedObject(self, &_parent_AssociationKey) as AnyObject?
        }
        
        set{
            objc_setAssociatedObject(self, &_parent_AssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
}

extension UIBarButtonItem : Argumentable{
    var passedArguments : AnyObject? {
        get{
            return objc_getAssociatedObject(self, &passedArgumentsAssociationKey) as AnyObject?
        }
        
        set{
            objc_setAssociatedObject(self, &passedArgumentsAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    func setTarget(target: AnyObject?, action: Selector, passedArguments: AnyObject?) {
        self.passedArguments    = passedArguments
        self.target             = target
        self.action             = action
    }
}


extension UIGestureRecognizer : Argumentable{
    var passedArguments : AnyObject? {
        get{
            return objc_getAssociatedObject(self, &passedArgumentsAssociationKey) as AnyObject?
        }
        
        set{
            objc_setAssociatedObject(self, &passedArgumentsAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    func addTarget(target: AnyObject?, action: Selector, passedArguments: AnyObject?) {
        self.passedArguments    = passedArguments
        
        if let t: AnyObject = target{
            self.addTarget(t, action: action)
        }
    }
    
}


