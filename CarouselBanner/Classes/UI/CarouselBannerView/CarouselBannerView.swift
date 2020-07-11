//
//  CarouselBannerView.swift
//  CarouselBanner
//
//  Created by Admin on 7/11/20.
//  Copyright © 2020 Charle Meenu Prabhat Technologies. All rights reserved.
//

import UIKit

/*
 * CarouselBannerView is a subclass of UICollectionView which is intended to be used to carousel through cells which don't extend to the edges of a screen. The previous and subsequent cells are scaled as the carousel scrolls.
 */
open class CarouselBannerView: UICollectionView {
    
    private var lastCurrentCenterCellIndex: IndexPath?
    @IBInspectable public var inset: CGFloat = 0.0 {
        didSet {
            configureLayout()
        }
    }
    
    open var currentCenterCell: UICollectionViewCell? {
        
        let lowerBound = inset - 20
        let upperBound = inset + 20
        
        for cell in visibleCells {
            let cellRect = convert(cell.frame, to: nil)
            if cellRect.origin.x > lowerBound && cellRect.origin.x < upperBound {
                return cell
            }
        }
        return nil
    }
    
    open var currentCenterCellIndex: IndexPath? {
        guard let currentCenterCell = self.currentCenterCell else { return nil }
        
        return indexPath(for: currentCenterCell)
    }
    
    override open var contentSize: CGSize {
        didSet {
            
            guard let dataSource = dataSource,
                let invisibleScrollView = invisibleScrollView else { return }
            let numberSections = dataSource.numberOfSections?(in: self) ?? 1
            // Calculate total number of items in collection view
            var numberItems = 0
            for i in 0..<numberSections {
                let numberSectionItems = dataSource.collectionView(self, numberOfItemsInSection: i)
                numberItems += numberSectionItems
            }
            
            let contentWidth = invisibleScrollView.frame.width * CGFloat(numberItems)
            invisibleScrollView.contentSize = CGSize(width: contentWidth, height: invisibleScrollView.frame.height)
        }
    }
    
    fileprivate var invisibleScrollView: UIScrollView!
    fileprivate var invisibleWidthConstraint: NSLayoutConstraint?
    fileprivate var invisibleLeftConstraint: NSLayoutConstraint?
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init(withFrame frame: CGRect, andInset inset: CGFloat) {
        self.init(frame: frame, collectionViewLayout: ScalingCarouselLayout(withCarouselInset: inset))
        self.inset = inset
    }
    
    override open func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        invisibleScrollView.setContentOffset(rect.origin, animated: animated)
    }
    
    override open func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        super.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        let originX = (CGFloat(indexPath.item) * (frame.size.width - (inset * 2)))
        let rect = CGRect(x: originX, y: 0, width: frame.size.width - (inset * 2), height: frame.height)
        scrollRectToVisible(rect, animated: animated)
        lastCurrentCenterCellIndex = indexPath
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        addInvisibleScrollView(to: superview)
    }
    
    public func didScroll() {
        scrollViewDidScroll(self)
    }
    
    public func deviceRotated() {
        guard let lastCurrentCenterCellIndex = currentCenterCellIndex ?? lastCurrentCenterCellIndex else { return }
        DispatchQueue.main.async {
            self.reloadData()
            self.scrollToItem(at: lastCurrentCenterCellIndex, at: .centeredHorizontally, animated: false)
            self.didScroll()
        }
    }
}

private typealias PrivateAPI = CarouselBannerView
fileprivate extension PrivateAPI {
    
    func addInvisibleScrollView(to superview: UIView?) {
        guard let superview = superview else { return }
        
        /// Add our 'invisible' scrollview
        invisibleScrollView = UIScrollView(frame: bounds)
        invisibleScrollView.translatesAutoresizingMaskIntoConstraints = false
        invisibleScrollView.isPagingEnabled = true
        invisibleScrollView.showsHorizontalScrollIndicator = false
        invisibleScrollView.isUserInteractionEnabled = false
        invisibleScrollView.delegate = self
        
        addGestureRecognizer(invisibleScrollView.panGestureRecognizer)
        superview.addSubview(invisibleScrollView)
        invisibleScrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        invisibleScrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        configureLayout()
    }
    
    func configureLayout() {
        
        // Create a ScalingCarouselLayout using our inset
        collectionViewLayout = ScalingCarouselLayout(
            withCarouselInset: inset)
        
        guard let invisibleScrollView = invisibleScrollView else { return }
        
        // Remove constraints if they already exist
        invisibleWidthConstraint?.isActive = false
        invisibleLeftConstraint?.isActive = false
        
        invisibleWidthConstraint = invisibleScrollView.widthAnchor.constraint(
            equalTo: widthAnchor, constant: -(2 * inset))
        invisibleLeftConstraint =  invisibleScrollView.leftAnchor.constraint(
            equalTo: leftAnchor, constant: inset)
        
        // Activate the constraints
        invisibleWidthConstraint?.isActive = true
        invisibleLeftConstraint?.isActive = true
        
        // To avoid carousel moving when cell is tapped
        isPagingEnabled = true
        isScrollEnabled = false
    }
}

extension CarouselBannerView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateOffSet()
        for cell in visibleCells {
            if let infoCardCell = cell as? CarouselBannerCVC {
                infoCardCell.scale(withCarouselInset: inset)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
        guard let indexPath = currentCenterCellIndex else { return }
        lastCurrentCenterCellIndex = indexPath
    }
    
    private func updateOffSet() {
        contentOffset = invisibleScrollView.contentOffset
    }
}

