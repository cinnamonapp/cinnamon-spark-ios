//
//  CSFastCameraServingSizeSelector.swift
//  Cinnamon
//
//  Created by Alessio Santo on 15/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSFastCameraServing : NSObject{
    var id : Int!
    var name : String!
    
    convenience init(id: Int!, name: String!){
        self.init()
        
        self.id     = id
        self.name   = name
    }
}

class CSFastCameraServingSelector: UIScrollView{
    
    var servings : [CSFastCameraServing] = []
    
    var selectedServing : CSFastCameraServing?{
        get{
            return servings[_selectedServingIndex]
        }
    }
    var _selectedServingIndex = 0
    
    var servingLabels : [UILabel]{
        get{
            
            if(_servingLabels != nil && _servingLabels.count > 0){
                return _servingLabels
            }
            
            var array : [UILabel] = []
            
            for serving in servings{
                let label = UILabel(frame: CGRectMake(0,0,100,30))
                label.text = serving.name
                label.sizeToFit()
                
                array.append(label)
            }
            
            _servingLabels = array
            
            return array
        }
    }
    var _servingLabels : [UILabel]!
    
    override init(){
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(frame: CGRect, servings: [CSFastCameraServing]){
        self.init()
        self.frame = frame
        self.servings = servings
        
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func calculateXPositionForServingAtIndex(index: Int) -> CGFloat{
        var position : CGFloat = 0
        
        let step : CGFloat = bounds.size.width / CGFloat(servings.count + 1)
        let servingLabel = servingLabels[index]
        
        position = step * CGFloat(index + 1) - servingLabel.bounds.width / 2
        
        return position
    }
    
    func calculateYPositionForServingAtIndex(index: Int) -> CGFloat{
        var position : CGFloat = 0
        
        let servingLabel = servingLabels[index]
        
        position = bounds.height / 2 - servingLabel.bounds.height / 2
        
        return position
    }
    
    func frameForServingAtIndex(index: Int) -> CGRect{
        var newFrame = servingLabels[index].frame
        newFrame.origin.x = calculateXPositionForServingAtIndex(index)
        newFrame.origin.y = calculateYPositionForServingAtIndex(index)
        
        return newFrame
    }
    
    func setSelectedServingWithIndex(index: Int){
        _selectedServingIndex = index
        highlightSelectedServing()
    }
    
    func setSelectedServingWithTapGesture(tapGesture: UITapGestureRecognizer){
        if let index = tapGesture.passedValue as? Int{
            setSelectedServingWithIndex(index)
        }
    }
    
    private func highlightSelectedServing(){
        for servingLabel in servingLabels{
            servingLabel.textColor = UIColor.whiteColor()
        }
        
        servingLabels[_selectedServingIndex].textColor = UIColorFromHex(0xF17223, alpha: 1)
    }
    
    func configure(){
        for (index, servingLabel) in enumerate(servingLabels){
            servingLabel.textColor = UIColor.whiteColor()
            servingLabel.addTarget(self, action: "setSelectedServingWithTapGesture:", forControlEvents: UIControlEvents.TouchUpInside, passedValue: index)
            self.addSubview(servingLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for (index, servingLabel) in enumerate(servingLabels){
            servingLabel.frame = frameForServingAtIndex(index)
        }
        
        highlightSelectedServing()
    }
}
