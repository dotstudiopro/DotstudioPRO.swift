//
//  InfiniteCarousel.swift
//  Ouroboros
//
//  Created by Ian Terrell on 10/21/15.
//  Copyright © 2015 WillowTree Apps. All rights reserved.
//

import UIKit

open class InfiniteCarousel: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Initialization
    
    /// Override to set delegate in case there is no future specific delegate.
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }

    /// Override to set delegate in case there is no future specific delegate.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        guard collectionViewLayout is UICollectionViewFlowLayout else {
            fatalError("InfiniteCarousel can only be used with UICollectionViewFlowLayout instances")
        }
        object_setClass(collectionViewLayout, Layout.self)
        delegate = self
        setNeedsFocusUpdate()
    }
    
    /// The number of cells that are generally focused on the screen.
    ///
    /// Usually the total number of visible is this many + 2, since the edges are showing slices
    /// of the cells before and after.
    ///
    /// This is used to decide both how many cells to add around the core as a buffer for infinite
    /// scrolling as well as how many cells ahead or behind we allow the user to focus at once.
    @IBInspectable open var itemsPerPage: Int = 1 {
        didSet {
            buffer = itemsPerPage * 2
        }
    }
    
    /// Whether or not to auto-scroll this carousel when the user is not interacting with it.
    @IBInspectable open var autoScroll: Bool = false
    
    /// The time in between auto-scroll events.
    @IBInspectable open var autoScrollTime: Double = 9.0
    
    /// The timer used to control auto-scroll behavior
    var scrollTimer: Timer?
    
    /// The original data source for the carousel
    open internal(set) weak var rootDataSource: UICollectionViewDataSource!
        
    /// The original delegate for the carousel
    open internal(set) weak var rootDelegate: UICollectionViewDelegateFlowLayout?
    
    /// The index of the item that is currently in focus.
    ///
    /// The layout uses this to know which page to center in the view.
    internal(set) var currentlyFocusedItem: Int = 0
    open var adjustedCurrentlyFocusedItem: Int {
        get {
            if self.count == 0 {
                return 0
            }
            let currentlyFocusedIndexPath = IndexPath(item: self.currentlyFocusedItem, section: 0)
            let adjustedIndexPath = self.adjustedIndexPathForIndexPath(currentlyFocusedIndexPath)
            return adjustedIndexPath.item
        }
    }

    /// The index of the item that was in focus when the user began a touch event.
    ///
    /// This is used to determine how far we can advance focus in a single gesture.
    open internal(set) var initiallyFocusedItem: Int?
    
    /// Override dataSource to set up our responder chain
    open override weak var dataSource: UICollectionViewDataSource? {
        get {
            return super.dataSource
        }
        set {
            rootDataSource = newValue
            super.dataSource = self
        }
    }

    /// Override delegate to set up our responder chain
    open override weak var delegate: UICollectionViewDelegate? {
        get {
            return super.delegate
        }
        set {
            rootDelegate = newValue as? UICollectionViewDelegateFlowLayout
            super.delegate = self
        }
    }

    /// Number of cells to buffer
    open internal(set) var buffer: Int = 2
    
    /// Cached count of current number of items
    var count = 0

    /// Whether or not we're cued to jump
    var jumping = false
    
    /// Current direction our focus is traveling
    var focusHeading: UIFocusHeading?
    
    /// Cell to focus on if we update focus
    var manualFocusCell: IndexPath?
    
    /// Returns the index path of the root data source item given an index path from this collection
    /// view, which naturally includes the buffer cells.
    open func adjustedIndexPathForIndexPath(_ indexPath: IndexPath) -> IndexPath {
        let index = indexPath.item
        let wrapped = (index - buffer < 0) ? (count + (index - buffer)) : (index - buffer)
        let adjustedIndex = wrapped % count
        return IndexPath(item: adjustedIndex, section: 0)
    }
    
    open override func reloadData() {
        super.reloadData()
        
        DispatchQueue.main.async {
            guard self.count > 0 else {
                return
            }
            self.scrollToItem(self.buffer, animated: false)
            self.beginAutoScroll()
        }
    }
    
    // For the empty case, returns 0. For a non-empty data source, returns the original number
    // of cells plus the buffer cells.
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        count = rootDataSource.collectionView(collectionView, numberOfItemsInSection: section)
        guard count > 0 else {
            return 0
        }
        return count + 2 * buffer
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let adjustedPath = adjustedIndexPathForIndexPath(indexPath)
        return rootDataSource.collectionView(collectionView, cellForItemAt: adjustedPath)
    }
    
    open func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return manualFocusCell
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        initiallyFocusedItem = currentlyFocusedItem
        super.touchesBegan(touches, with: event)
    }
    
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let adjustedPath = adjustedIndexPathForIndexPath(indexPath)
        rootDelegate?.collectionView?(collectionView, didSelectItemAt: adjustedPath)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        rootDelegate?.scrollViewWillBeginDragging?(scrollView)
        self.stopAutoScroll()
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        rootDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        self.beginAutoScroll() // added by ketan to restart auto scroll timer when manual scroll is done..
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        rootDelegate?.scrollViewDidScroll?(scrollView)
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        rootDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    
    open func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        // Allow users to leave
        guard let to = context.nextFocusedIndexPath else {
            beginAutoScroll()
            return true
        }
        
        // Allow users to enter
        guard context.previouslyFocusedIndexPath != nil else {
            stopAutoScroll()
            return true
        }
        
        // Restrict movement to a page at a time if we're swiping, but don't break
        // keyboard access in simulator.
        if initiallyFocusedItem != nil && abs(to.item - initiallyFocusedItem!) > itemsPerPage {
            return false
        }
        
        focusHeading = context.focusHeading
        currentlyFocusedItem = to.item
        
        if focusHeading == .left && to.item < buffer {
            jumping = true
            currentlyFocusedItem += count
        }
        
        if focusHeading == .right && to.item >= buffer + count {
            jumping = true
            currentlyFocusedItem -= count
        }
        
        manualFocusCell = IndexPath(item: currentlyFocusedItem, section: 0)
        return true
    }
    
    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard jumping else {
            return
        }
        
        jumping = false
        
        if focusHeading == .left {
            jump(.forward)
        } else {
            jump(.backward)
        }
        
        currentlyFocusedItem = manualFocusCell!.item
        setNeedsFocusUpdate()
    }
    
    func scrollToItem(_ item: Int, animated: Bool) {
        if let initialOffset = (self.collectionViewLayout as! Layout).offsetForItemAtIndex(item) {
            self.setContentOffset(CGPoint(x: initialOffset,y: self.contentOffset.y), animated: animated)
        }
        
        // Update focus element in case we have it
        self.currentlyFocusedItem = item
        self.manualFocusCell = IndexPath(item: self.currentlyFocusedItem, section: 0)
        self.setNeedsFocusUpdate()
        rootDelegate?.scrollViewDidScroll?(self)
    }
    
    // MARK: - Auto Scroll
    
    func beginAutoScroll() {
        guard autoScroll else {
            return
        }
        
        scrollTimer?.invalidate()
        scrollTimer = Timer.scheduledTimer(timeInterval: autoScrollTime, target: self,
            selector: #selector(InfiniteCarousel.scrollToNextPage), userInfo: nil, repeats: true)
    }
    
    func stopAutoScroll() {
        scrollTimer?.invalidate()
    }
    
    @objc func scrollToNextPage() {
        if count == 0 {
            return
        }
        var nextItem = self.currentlyFocusedItem + itemsPerPage
        if nextItem >= buffer + count {
            nextItem -= count
            jump(.backward)
        }

        scrollToItem(nextItem, animated: true)
    }
    
    // MARK: - Jump Helpers
    
    enum JumpDirection {
        case forward
        case backward
    }
    
    func jump(_ direction: JumpDirection) {
        let currentOffset = self.contentOffset.x
        var jumpOffset = CGFloat(count) * (collectionViewLayout as! Layout).totalItemWidth
        if case .backward = direction {
            jumpOffset *= -1
        }
        self.setContentOffset(CGPoint(x: currentOffset + jumpOffset, y: self.contentOffset.y),
            animated: false)
    }
    
    // MARK: - Layout
    
    class Layout: UICollectionViewFlowLayout {
        var totalItemWidth: CGFloat {
            return itemSize.width + minimumLineSpacing
        }
        
        var carousel: InfiniteCarousel {
            guard let carousel = collectionView as? InfiniteCarousel else {
                fatalError("This layout should only be used by InfiniteCarousel instances")
            }
            return carousel
        }
        
        func offsetForItemAtIndex(_ index: Int) -> CGFloat? {
            let pageSize = carousel.itemsPerPage
            let pageIndex = (index / pageSize)
            let firstItemOnPageIndex = pageIndex * pageSize
            let firstItemOnPage = IndexPath(item: firstItemOnPageIndex, section: 0)
            
            guard let cellAttributes = self.layoutAttributesForItem(at: firstItemOnPage) else {
                return nil
            }
            
            let offset = ((carousel.bounds.size.width - (CGFloat(pageSize) * totalItemWidth) - minimumLineSpacing) / 2.0) + minimumLineSpacing
            return cellAttributes.frame.origin.x - offset
        }
        
        override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
            
//            if velocity.x > 1.0 {
////                carousel.scrollToNextPage()
//                var nextItem = carousel.currentlyFocusedItem + carousel.itemsPerPage
//                if nextItem >= carousel.buffer + carousel.count {
//                    nextItem -= carousel.count
//                    carousel.jump(.Backward)
//                }
//                carousel.scrollToItem(nextItem, animated: true)
//            } else if velocity.x < 1.0 {
////                carousel.scrollToPr
//                var nextItem = carousel.currentlyFocusedItem - carousel.itemsPerPage
//                if nextItem >= carousel.buffer + carousel.count {
//                    nextItem -= carousel.count
//                    carousel.jump(.Forward)
//                }
//                carousel.scrollToItem(nextItem, animated: true)
//            }
            
            #if os(iOS)
                var currentItem = carousel.currentlyFocusedItem
                if velocity.x > 1.0 {
                    currentItem = (carousel.currentlyFocusedItem + 1) % carousel.count
                } else if velocity.x < -1.0 {
                    currentItem = (carousel.currentlyFocusedItem + carousel.count - 1) % carousel.count
                }
                carousel.currentlyFocusedItem = currentItem
            #endif
            
            guard let offset = offsetForItemAtIndex(carousel.currentlyFocusedItem) else {
                return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            }
            return CGPoint(x: offset, y: proposedContentOffset.y)
        }
    }
}
