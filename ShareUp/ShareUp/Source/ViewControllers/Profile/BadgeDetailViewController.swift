//
//  BadgeDetailViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/18.
//

import UIKit
import PanModal
import CollectionViewPagingLayout

final class BadgeDetailViewController: UIViewController {

    @IBOutlet weak var badgeLevelCollectionView: UICollectionView!
    @IBOutlet weak var badgeNameLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var badgeCountLabel: UILabel!
    @IBOutlet weak var badgeSetButton: UIButton!
            
    private let layout = CollectionViewPagingLayout()
    private var badgeAcheive = [String]()
    var category = String()
    var level = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.numberOfVisibleItems = 3
        badgeLevelCollectionView.collectionViewLayout = layout
        badgeLevelCollectionView.isPagingEnabled = true

        layout.delegate = self
        badgeLevelCollectionView.dataSource = self
        badgeLevelCollectionView.delegate = self
        
        
        for i in 1..<level {
            badgeAcheive.append(category + "\(i)")
        }
    }
}

extension BadgeDetailViewController: CollectionViewPagingLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badgeDetailCell", for: indexPath) as! BadgeLevelCollectionViewCell
        cell.badgeImageView.image = UIImage(named: badgeAcheive[indexPath.row])
        return cell
    }
    
    func onCurrentPageChanged(layout: CollectionViewPagingLayout, currentPage: Int) {
        
    }
    
}

extension BadgeDetailViewController: PanModalPresentable {
    var longFormHeight: PanModalHeight { return .contentHeight(412) }
    var anchorModalToLongForm: Bool { return false }
    var shouldRoundTopCorners: Bool { return true }
    var panScrollable: UIScrollView? {  return nil }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
