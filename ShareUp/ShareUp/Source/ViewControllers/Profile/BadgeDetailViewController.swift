//
//  BadgeDetailViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/18.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal
import CollectionViewPagingLayout

final class BadgeDetailViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var badgeLevelCollectionView: UICollectionView!
    @IBOutlet weak var badgeNameLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var badgeCountLabel: UILabel!
    @IBOutlet weak var badgeSetButton: UIButton!
    
    //MARK: Properties
    var category = String()
    var level = Int()
    private let layout = CollectionViewPagingLayout()
    private var badgeAcheive = [String](repeating: "0", count: 3)
    private let viewModel = BadgeDetailViewModel()
    private let disposeBag = DisposeBag()
    private var currentLevel = BehaviorRelay<Int>(value: 0)
    private var currentName = PublishRelay<String>()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<level {
            badgeAcheive[i] = (category + "\(i+1)")
        }
        
        layout.numberOfVisibleItems = 3
        badgeLevelCollectionView.collectionViewLayout = layout
        badgeLevelCollectionView.isPagingEnabled = true
        badgeLevelCollectionView.indicatorStyle = .white
        
        
        layout.delegate = self
        badgeLevelCollectionView.dataSource = self
        badgeLevelCollectionView.delegate = self
        currentName.accept(category)
        bindViewModel()
    }
    
    //MARK: Bind
    private func bindViewModel() {
        let input = BadgeDetailViewModel.Input(category: .just(category),
                                               level: currentLevel.asDriver(),
                                               postBadge: badgeSetButton.rx.tap.asDriver())
        let output = viewModel.transform(input)
        
        output.result.emit(onCompleted: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}

//MARK: Extension
extension BadgeDetailViewController: CollectionViewPagingLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if category == "default" || category == "first" {
            return 1
        }else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badgeDetailCell", for: indexPath) as! BadgeLevelCollectionViewCell
        
        if category == "default" || category == "first" {
            cell.badgeImageView.image = UIImage(named: cell.badgeImage(category)[indexPath.row])
            let info = Category(rawValue: category)?.toDescription()
            badgeNameLabel.text = info?[0]
            badgeLabel.text = info?[1]
        }else {
            cell.badgeImageView.image = UIImage(named: badgeAcheive[indexPath.row])
        }
        
        return cell
    }
    
    func onCurrentPageChanged(layout: CollectionViewPagingLayout, currentPage: Int) {
        let info = Category(rawValue: badgeAcheive[currentPage])?.toDescription()
        badgeNameLabel.text = info?[0]
        badgeLabel.text = info?[1]
        badgeCountLabel.text = info?[2]
        currentLevel.accept(currentPage+1)
        
        badgeSetButton.isEnabled = badgeAcheive[currentPage] == "0" ? false : true
        badgeSetButton.setTitle(badgeSetButton.isEnabled ? "배지 설정" : "잠금", for: .normal)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if category == "default" || category == "first" {
            let info = Category(rawValue: category)?.toDescription()
            badgeNameLabel.text = info?[0]
            badgeLabel.text = info?[1]
        }else {
            let info = Category(rawValue: badgeAcheive[0])?.toDescription()
            badgeNameLabel.text = info?[0]
            badgeLabel.text = info?[1]
            badgeCountLabel.text = info?[2]
            
            badgeSetButton.isEnabled = badgeAcheive[0] == "0" ? false : true
            badgeSetButton.setTitle(badgeSetButton.isEnabled ? "배지 설정" : "잠금", for: .normal)
            
            currentLevel.accept(1)
        }
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
