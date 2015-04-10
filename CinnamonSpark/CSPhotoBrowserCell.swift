//
//  CSPhotoBrowserCell.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 03/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSPhotoBrowserCell: UICollectionViewCell {
    
    var photoBrowser : CSPhotoBrowser?
    var imageView : UIImageView!
    var captionView : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = viewsBackgroundColor
        
        self.initializeImageView()
        self.prepareImageViewForReuse()
        
        self.initializeCaptionView()
        self.prepareCaptionViewForReuse()

    }
    
    func setPhotoBrowser(photoBrowser browser: CSPhotoBrowser){
        self.photoBrowser = browser
        
        self.initializeImageView()
        self.prepareImageViewForReuse()
        
        self.initializeCaptionView()
        self.prepareCaptionViewForReuse()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    /**
    
    */
    private func initializeImageView(){
        self.imageView?.removeFromSuperview()
        self.imageView = UIImageView()
        self.contentView.addSubview(self.imageView)
    }
    
    private func prepareImageViewForReuse(){
        
        self.imageView.frame = CGRectMake(0, 0, 100, 100)
        
        if(self.photoBrowser?.collectionViewLayout is CSVerticalImageRowLayout){
            let y = self.contentView.frame.height - self.contentView.frame.width
            
            self.imageView.frame = CGRectMake(0, y, self.contentView.frame.width,  self.contentView.frame.width)
        }
        
        if(self.photoBrowser?.collectionViewLayout is CSGridImageTagLayout){
            self.imageView.frame = CGRectMake(0, 0, self.contentView.frame.width,  self.contentView.frame.width)
        }
    }
    
    private func initializeCaptionView(){
        self.captionView?.removeFromSuperview()
        self.captionView = CSPhotoBrowserCaptionView()
        self.contentView.addSubview(self.captionView)
    }
    
    private func prepareCaptionViewForReuse(){
        if(self.photoBrowser?.collectionViewLayout is CSVerticalImageRowLayout){
            let height = self.contentView.frame.height - self.contentView.frame.width
            
            self.captionView.frame = CGRectMake(0, 0, self.contentView.frame.width, height)
        }
    }
    
    func setImageWithURL(URL: NSURL){
        
        // TODO: Improve this temporary hack
        let thumbUrl = NSURL(string: URL.description.stringByReplacingOccurrencesOfString("original", withString: "thumbnail"))
        
        // First load the thumb image
        self.imageView.sd_setImageWithURL(thumbUrl, completed: { (image: UIImage!, error: NSError!, cache: SDImageCacheType, url: NSURL!) -> Void in
            // Then load the full image
            self.imageView.sd_setImageWithURL(URL, placeholderImage: image)
        })
        
    }
    
    func addSubviewToCaptionView(view: UIView){
        self.captionView.addSubview(view)
    }
    
}


class CSPhotoBrowserCaptionView : UIView{
    override func addSubview(view: UIView) {
        super.addSubview(view)
    }
}