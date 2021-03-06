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
    //MARK: UI
    @IBOutlet weak var currentBadgeImageView: UIImageView!
    @IBOutlet weak var currentBadgeNameLabel: UILabel!
    @IBOutlet weak var badgeCollectionView: UICollectionView!
    @IBOutlet weak var currentTouchArea: UIButton!
    
    //MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewModel = BadgeListViewModel()
    private let loadData = BehaviorRelay<Void>(value: ())
    private var getCategory = PublishRelay<String>()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 15
        flowLayout.itemSize = CGSize(width: view.frame.width/4, height: badgeCollectionView.frame.width/3)
        
        badgeCollectionView.collectionViewLayout = flowLayout
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "배지"
        navigationBackCustom()
        loadData.accept(())
    }
    
    //MARK: Bind
    private func bindViewModel() {
        let input = BadgeListViewModel.Input(loadData: loadData.asSignal(onErrorJustReturn: ()),
                                             selectBadge: badgeCollectionView.rx.itemSelected.asDriver(),
                                             selectCurrentBadge: getCategory.asDriver(onErrorJustReturn: ""),
                                             selectCurrent: currentTouchArea.rx.tap.asDriver())
        let output = viewModel.transform(input)
        
        output.loadData.asObservable().bind(to: badgeCollectionView.rx.items(cellIdentifier: "badgeCell", cellType: BadgeCollectionViewCell.self)) { row, data, cell in
            cell.configCell(data, indexPath: row)
        }.disposed(by: disposeBag)
        
        output.loadBadgeData.asObservable().bind {[unowned self] data in
            currentBadgeImageView.image = UIImage(named: data!.badgeCategory + "\(data!.badgeLevel)")
            currentBadgeNameLabel.text = Category(rawValue: data!.badgeCategory + "\(data!.badgeLevel)")?.toDescription()[0]
            getCategory.accept(data!.badgeCategory)
        }.disposed(by: disposeBag)
        
        output.detailIndexPath.asObservable().subscribe(onNext: { level in
            let vc = self.storyboard?.instantiateViewController(identifier: "badgeDetail") as! BadgeDetailViewController
            vc.category = ShareUpFilter.filterCategoryBadge(level[1])
            vc.level = level[0]
            self.presentPanModal(vc)
        }).disposed(by: disposeBag)
    }
}
