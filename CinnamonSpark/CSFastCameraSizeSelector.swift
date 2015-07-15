//
//  CSFastCameraSizeSelector.swift
//  Cinnamon
//
//  Created by Alessio Santo on 18/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSFastCameraSizeSelector : UIView{
    
    var backgroundLayer     : CALayer!
    var maskCircleLayer     : CAShapeLayer!
    var borderCircleLayer   : CAShapeLayer!
    var values              : [CSFastCameraSize]!{
        get{
            return _values
        }
        
        set{
            _values = newValue
            
            if let ifDelegate = delegate{
                if(ifDelegate.respondsToSelector("sizeSelectorDidChangeSelectedValue:selectedValue:")){
                    ifDelegate.sizeSelectorDidChangeSelectedValue(self, selectedValue: selectedValue)
                }
            }
        }
    }
    var _values : [CSFastCameraSize] = []
    
    var delegate : CSFastCameraSizeSelectorDelegate?
    
    private var selectedValueIndex : Int{
        get{
            return _selectedValueIndex
        }
        
        set{
            var index = newValue
            
            if(values == nil){
                return
            }
            
            // If it exceeds put it back to 0
            if(index + 1 > values.count){
                index = 0
            }
            
            // If it is negative put it back to the highest number
            if(index < 0){
                index = values.count - 1
            }
            
            _selectedValueIndex = index
        }
    }
    private var _selectedValueIndex : Int = 0
    
    var selectedValue : CSFastCameraSize?{
        get{
            if(values != nil && values.count > 0){
                return values[selectedValueIndex]
            }else{
                return nil
            }
        }
    }
    
    var maxRadius : CGFloat{
        get{
            let percentage : CGFloat = 0.85
            return bounds.width * percentage / 2
        }
    }
    
    var minRadius : CGFloat{
        get{
            let percentage : CGFloat = 0.35
            return bounds.width * percentage / 2
        }
    }
    
    override init(){
        super.init()
    }
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, values: [CSFastCameraSize]!){
        self.init()
        self.frame = frame
        self.values = values
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        
        configureTapGesture()
        
        backgroundLayer = CALayer()
        backgroundLayer.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.5).CGColor
        //        layer.addSublayer(backgroundLayer)
        
        borderCircleLayer = CAShapeLayer()
        borderCircleLayer.fillColor = UIColor.clearColor().CGColor
        borderCircleLayer.lineWidth = 8
        borderCircleLayer.strokeColor = UIColor.whiteColor().CGColor
        
        maskCircleLayer = CAShapeLayer()
        maskCircleLayer.fillRule = kCAFillRuleEvenOdd
        
        backgroundLayer.mask = maskCircleLayer
        layer.addSublayer(backgroundLayer)
        
        layer.addSublayer(borderCircleLayer)
        
    }
    
    func selectValueWithIndex(index: Int){
        selectedValueIndex = index
    }
    
    func configureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        self.addGestureRecognizer(tapGesture)
    }
    
    func handleTapGesture(sender: AnyObject){
        selectedValueIndex++
        
        if let ifDelegate = delegate{
            if(ifDelegate.respondsToSelector("sizeSelectorDidChangeSelectedValue:selectedValue:")){
                ifDelegate.sizeSelectorDidChangeSelectedValue(self, selectedValue: selectedValue)
            }
        }
        
        self.setNeedsLayout()
    }
    
    func calculateRadius() -> CGFloat{
        
        if(values == nil){
            return bounds.width / 2
        }
        
        let step : CGFloat = (maxRadius - minRadius) / CGFloat(values.count - 1) // Calculate the step size
        let radius : CGFloat = minRadius + step * CGFloat(selectedValueIndex) // Starting from the minRadius add needed steps
        return radius
        
    }
    
    func circlePath() -> UIBezierPath{
        let origin = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        
        let s : CGFloat = CGFloat(-(M_PI)/2.0)
        let e : CGFloat = CGFloat(3*M_PI/2.0)
        
        return UIBezierPath(arcCenter: origin, radius: calculateRadius(), startAngle: s, endAngle: e, clockwise: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        
        let path : CGMutablePathRef = CGPathCreateMutable()
        CGPathAddPath(path, nil, CGPathCreateWithRect(bounds, nil))
        CGPathAddPath(path, nil, circlePath().CGPath)
        
        maskCircleLayer.path = path
        
        borderCircleLayer.frame = bounds
        borderCircleLayer.path = circlePath().CGPath
    }
    
}


class CSFastCameraSize : NSObject{
    var id : Int!
    var name : String!
    
    convenience init(id: Int, name: String){
        self.init()
        
        self.id = id
        self.name = name
    }
}

protocol CSFastCameraSizeSelectorDelegate : NSObjectProtocol {
    func sizeSelectorDidChangeSelectedValue(sizeSelector: CSFastCameraSizeSelector!, selectedValue: CSFastCameraSize?)
}
