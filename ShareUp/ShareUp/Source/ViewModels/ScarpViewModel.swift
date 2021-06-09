//
//  ScarpViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/12.
//

import Foundation
import RxSwift
import RxCocoa

final class ScarpViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input{
        let getScarpPosts: Signal<Void>
        let loadDetail: Signal<IndexPath>
        let deleteScarp: Signal<Int>
        let getMoreScrapPosts: Signal<Void>
        let getOtherProfile: Signal<Int>
    }
    
    struct Output{
        let getScarpPosts: Driver<[ScrapPost]>
        let detailIndexPath: Signal<String>
        let scrapResult: Driver<Void>
        let result: Signal<String>
        let profileIndexPath: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<String>()
        let getScarpData = BehaviorRelay<[ScrapPost]>(value: [])
        let getDetailRow = PublishSubject<String>()
        let scrapResult = PublishRelay<Void>()
        let scrapInfo = Signal.combineLatest(input.deleteScarp, getScarpData.asSignal(onErrorJustReturn: []))
        let profileIndexPath = PublishSubject<String>()
        var pagination = 0
        
        input.getScarpPosts.asObservable()
            .flatMap { _ in api.getScrapPosts(0) }
            .subscribe(onNext: { data, response in
                switch response {
                case .ok:
                    getScarpData.accept(data!.data)
                default:
                    result.onNext("서버 오류")
                }
            }).disposed(by: disposeBag)
        
        input.getMoreScrapPosts.asObservable()
            .map { pagination += 1 }
            .flatMap { _ in api.getScrapPosts(pagination)}
            .subscribe(onNext: { data, response in
                switch response {
                case .ok:
                    for i in data!.data {
                        getScarpData.add(element: i)
                    }
                default:
                    result.onNext("서버 오류")
                }
            }).disposed(by: disposeBag)
        
        input.loadDetail.asObservable()
            .subscribe(onNext: { indexPath in
                let value = getScarpData.value
                getDetailRow.onNext(String(value[indexPath.row].id))
            }).disposed(by: disposeBag)
        
        input.deleteScarp.asObservable()
            .withLatestFrom(scrapInfo)
            .flatMap { row, data in api.scrapDelete(id: data[row].id)}
            .subscribe(onNext: { response in
                print(response)
                switch response {
                case .ok:
                    scrapResult.accept(())
                case .notFound:
                    result.onNext("")
                default:
                    result.onNext("")
                }
            }).disposed(by: disposeBag)
        
        input.getOtherProfile.asObservable()
            .subscribe(onNext: { row in
                let value = getScarpData.value
                profileIndexPath.onNext(String(value[row].user.id))
            }).disposed(by: disposeBag)
        
        return Output(getScarpPosts: getScarpData.asDriver(onErrorJustReturn: []),
                      detailIndexPath: getDetailRow.asSignal(onErrorJustReturn: ""),
                      scrapResult: scrapResult.asDriver(onErrorJustReturn: ()),
                      result: result.asSignal(onErrorJustReturn: ""), profileIndexPath: profileIndexPath.asDriver(onErrorJustReturn: ""))
    }
}
