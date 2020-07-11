//
//  CarouselVC.swift
//  CarouselBanner
//
//  Created by Admin on 7/11/20.
//  Copyright © 2020 Charle Meenu Prabhat Technologies. All rights reserved.
//

import UIKit

class CarouselVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var carousel: CarouselBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CarouselVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let cell = cell as? CarouselBannerCVC {
            cell.mainView.backgroundColor = .clear
        }
        return cell
    }
}

extension CarouselVC: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carousel.didScroll()
    }
}

extension CarouselVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
