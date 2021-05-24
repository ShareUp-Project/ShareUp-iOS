//
//  BadgeViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/18.
//

import UIKit
import PanModal
import RxSwift
import RxCocoa

final class BadgeViewController: UIViewController {

    @IBOutlet weak var currentBadgeImageView: UIImageView!
    @IBOutlet weak var currentBadgeNameLabel: UILabel!
    @IBOutlet weak var badgeCollectionView: UICollectionView!
    @IBOutlet weak var currentTouchArea: UIButton!
    
    private let disposeBag = DisposeBag()
    private let viewModel = BadgeListViewModel()
    private let loadData = BehaviorRelay<Void>(value: ())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 15
        flowLayout.itemSize = CGSize(width: 120, height: 132)
        
        badgeCollectionView.collectionViewLayout = flowLayout
        currentTouchArea.rx.tap.subscribe(onNext: { _ in
            let vc = self.storyboard?.instantiateViewController(identifier: "badgeDetail") as! BadgeDetailViewController
            self.presentPanModal(vc)
        }).disposed(by: disposeBag)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = BadgeListViewModel.Input(loadData: loadData.asSignal(onErrorJustReturn: ()),
                                             selectBadge: badgeCollectionView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input)
        
        output.loadData.asObservable().bind(to: badgeCollectionView.rx.items(cellIdentifier: "badgeCell", cellType: BadgeCollectionViewCell.self)) { row, data, cell in
            cell.configCell(data, indexPath: row)
        }.disposed(by: disposeBag)
        
        output.detailIndexPath.asObservable().subscribe(onNext: { level in
            let vc = self.storyboard?.instantiateViewController(identifier: "badgeDetail") as! BadgeDetailViewController
            vc.category = "paper"
            vc.level = level
            
        }).disposed(by: disposeBag)
    }

}
