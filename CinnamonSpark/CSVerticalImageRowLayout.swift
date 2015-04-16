//
//  CSVerticalSocialLayout.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 02/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSVerticalImageRowLayout: UICollectionViewFlowLayout {
    
    override init(){
        super.init()
        let mainScreenBounds = UIScreen.mainScreen().bounds
        
        let itemWidth  : CGFloat = mainScreenBounds.width
        let rowHeight  : CGFloat = 30
        let itemHeight : CGFloat = itemWidth + rowHeight * 2
        
        self.itemSize = CGSizeMake(itemWidth, itemHeight)
        
        self.minimumInteritemSpacing = 1.0
        self.minimumLineSpacing = 0

//        self.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
