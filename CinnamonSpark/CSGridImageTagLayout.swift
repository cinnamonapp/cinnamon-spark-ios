//
//  CSPhotoGridLayout.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 02/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSGridImageTagLayout: UICollectionViewFlowLayout {
    
    override init(){
        super.init()
        let mainScreenBounds = UIScreen.mainScreen().bounds
        
        let itemWidth : CGFloat = mainScreenBounds.width / 3 - 1
        let itemHeight : CGFloat = itemWidth
        
        self.itemSize = CGSizeMake(itemWidth, itemHeight)
        
        self.minimumInteritemSpacing = 1
        
        self.minimumLineSpacing = 1
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
