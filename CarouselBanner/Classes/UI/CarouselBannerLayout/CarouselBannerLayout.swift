//
//  CarouselBannerLayout.swift
//  CarouselBanner
//
//  Created by Admin on 7/11/20.
//  Copyright © 2020 Charle Meenu Prabhat Technologies. All rights reserved.
//

import UIKit

/*
 CarouselBannerLayout is used together with SPBCarouselView to provide a carousel-style collection view.
*/

open class ScalingCarouselLayout: UICollectionViewFlowLayout {
    
    open var inset: CGFloat = 0.0
    convenience init(withCarouselInset inset: CGFloat = 0.0) {
        self.init()
        self.inset = inset
    }
    
    override open func prepare() {
        
        guard let collectionViewSize = collectionView?.frame.size else { return }
        
        // Set itemSize based on total width and inset
        itemSize = collectionViewSize
        itemSize.width = itemSize.width - (inset * 2)
        
        // Set scrollDirection and paging
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
        
        sectionInset = UIEdgeInsets(top: 0.0, left: inset, bottom: 0.0, right: inset)
        footerReferenceSize = CGSize.zero
        headerReferenceSize = CGSize.zero
    }
}
