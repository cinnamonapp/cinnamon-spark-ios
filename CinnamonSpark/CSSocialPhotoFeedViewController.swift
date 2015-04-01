//
//  CSPhotoBrowserViewController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSSocialPhotoFeedViewController: CSPhotoFeedViewController {

    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.getMealRecords(.All)
    }
    
}

