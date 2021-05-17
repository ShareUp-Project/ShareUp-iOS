//
//  MainViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/08.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input{
        let getPosts: Signal<Void>
        let loadDetail: Signal<IndexPath>
        let postScrap: Signal<Int>
        let getMorePosts: Signal<Void>
    }
    
    struct Output{
        let getPosts: Driver<[Post]>
        let detailIndexPath: Signal<String>
        let scrapResult: Driver<Void>
        let result: Signal<String>
    }
    
    func transform(_ input: Input) -> Output {
        let api = AuthService()
        let result = PublishSubject<String>()
        let getPostsData = BehaviorRelay<[Post]>(value: [])
        let getDetailRow = PublishSubject<String>()
        let scrapResult = PublishRelay<Void>()
        let scrapInfo = Signal.combineLatest(input.postScrap, getPostsData.asSignal(onErrorJustReturn: []))
        var pagination = 0
        
        input.getPosts.asObservable()
            .flatMap { _ in api.getPosts(0) }
            .subscribe(onNext: { data, response in
                print(response)
                switch response {
                case .ok:
                    getPostsData.accept(data!.data)
                default:
                    result.onNext("서버 오류")
                }
            }).disposed(by: disposeBag)
        
        input.getMorePosts.asObservable()
            .map { pagination += 1 }
            .flatMap { _ in api.getPosts(pagination)}
            .subscribe(onNext: { data, response in
                print(response)
                switch response {
                case .ok:
                    for i in data!.data {
                        getPostsData.add(element: i)
                    }
                default:
                    result.onNext("서버 오류")
                }
            }).disposed(by: disposeBag)
        
        input.loadDetail.asObservable()
            .subscribe(onNext: { indexPath in
            let value = getPostsData.value
            getDetailRow.onNext(String(value[indexPath.row].id))
        }).disposed(by: disposeBag)
        
        input.postScrap.asObservable().withLatestFrom(scrapInfo).subscribe(onNext: {[weak self] row, data in
            guard let self = self else { return }
            let postId = data[row].id
            if !data[row].isScrap {
                api.scrapPost(postId).subscribe(onNext: { response in
                    switch response {
                     case .ok:
                        scrapResult.accept(())
                    case .conflict:
                        result.onNext("이미 스크랩 된 글")
                    default:
                        result.onNext("서버 오류")
                    }
                }).disposed(by: self.disposeBag)
            } else {
                api.scrapDelete(postId).subscribe(onNext: { response in
                    switch response {
                    case .ok:
                        scrapResult.accept(())
                    default:
                        result.onNext("서버 오류")
                    }
                }).disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
        
        return Output(getPosts: getPostsData.asDriver(onErrorJustReturn: []),
                      detailIndexPath: getDetailRow.asSignal(onErrorJustReturn: ""),
                      scrapResult: scrapResult.asDriver(onErrorJustReturn: ()),
                      result: result.asSignal(onErrorJustReturn: ""))
    }
}
