//
//  BadgeListViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/23.
//

import Foundation
import RxSwift
import RxCocoa

final class BadgeListViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let loadData: Signal<Void>
        let selectBadge: Driver<IndexPath>
    }
    
    struct Output {
        let loadData: Driver<[Int]>
        let detailIndexPath: Driver<Int>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let getBadgeList = BehaviorRelay<[Int]>(value: [])
        let getDetailRow = PublishRelay<Int>()
        
        input.loadData.asObservable()
            .flatMap { _ in api.getBadgeList() }
            .subscribe(onNext: { data, response in
                switch response {
                case .ok:
                    var array = [Int]()
                    
                    array.append(data!.first)
                    array.append(data!.paper)
                    array.append(data!.plastic)
                    array.append(data!.glass)
                    array.append(data!.styrofoam)
                    array.append(data!.vinyl)
                    array.append(data!.can)
                    array.append(data!.clothing)
                    
                    getBadgeList.accept(array)
                default:
                    getBadgeList.accept([])
                }
            }).disposed(by: disposeBag)
        
        input.selectBadge.asObservable().subscribe(onNext: { indexPath in
            let value = getBadgeList.value
            getDetailRow.accept(value[indexPath.row])
        }).disposed(by: disposeBag)
        
        return Output(loadData: getBadgeList.asDriver(), detailIndexPath: getDetailRow.asDriver(onErrorJustReturn: 0))
    }
}
