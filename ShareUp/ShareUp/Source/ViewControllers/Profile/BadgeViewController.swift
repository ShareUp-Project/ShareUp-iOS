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

        badgeCollectionView.delegate = self
        badgeCollectionView.dataSource = self
        
        currentTouchArea.rx.tap.subscribe(onNext: { _ in
            let vc = self.storyboard?.instantiateViewController(identifier: "badgeDetail") as! BadgeDetailViewController
            self.presentPanModal(vc)
        }).disposed(by: disposeBag)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = BadgeListViewModel.Input(loadData: loadData.asSignal(onErrorJustReturn: ()))
        let output = viewModel.transform(input)
        
        output.loadData.asObservable().bind(to: badgeCollectionView.rx.items(cellIdentifier: "badgeCell", cellType: BadgeCollectionViewCell.self)) { row, data, cell in
            cell.configCell(data, indexPath: row)
        }.disposed(by: disposeBag)
    }

}

extension BadgeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badgeCell", for: indexPath) as! BadgeCollectionViewCell
        
        cell.badgeImageView.image = UIImage(named: "selectEditor")
        cell.badgeNameLabel.text = "배지이름"
        
        return cell
    }
}
