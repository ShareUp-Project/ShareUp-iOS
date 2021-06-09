//
//  ProfileViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/30.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let otherProfileId: Driver<String>
        let loadProfile: Signal<Void>
        let loadMoreProfile: Signal<Void>
        let loadDetail: Signal<IndexPath>
        let postScrap: Signal<Int>
    }
    
    struct Output {
        let myNickname: Driver<Nickname?>
        let myPosts: Driver<[Post]>
        let detailIndexPath: Driver<String>
        let scrapResult: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<String>()
        let nickname = PublishRelay<Nickname?>()
        let getMyPost = BehaviorRelay<[Post]>(value: [])
        let getDetailRow = PublishSubject<String>()
        let scrapResult = PublishRelay<Void>()
        let scrapInfo = Signal.combineLatest(input.postScrap, getMyPost.asSignal(onErrorJustReturn: []))
        var pagination = 0
        
        input.loadProfile.asObservable()
            .withLatestFrom(input.otherProfileId)
            .flatMap { id in api.getNickname(id: id) }
            .subscribe(onNext: { data, response in
                print(response)
                switch response {
                case .ok:
                    nickname.accept(data!)
                default:
                    result.onNext("getNickname server error")
                }
            }).disposed(by: disposeBag)
        
        input.loadProfile.asObservable()
            .withLatestFrom(input.otherProfileId)
            .flatMap { id in api.getUserPosts(id: id, 0)}
            .subscribe(onNext: { data, response in
                switch response {
                case .ok:
                    getMyPost.accept(data!.data)
                default:
                    result.onNext("getUserPosts server error")
                }
            }).disposed(by: disposeBag)
        
        input.loadMoreProfile.asObservable()
            .map { pagination += 1}
            .withLatestFrom(input.otherProfileId)
            .flatMap { id in api.getUserPosts(id: id, pagination)}
            .subscribe(onNext: { data, response in
                print(response)
                switch response {
                case .ok:
                    for i in data!.data {
                        getMyPost.add(element: i)
                    }
                default:
                    result.onNext("서버 오류")
                }
            }).disposed(by: disposeBag)
        
        input.loadDetail.asObservable()
            .subscribe(onNext: { indexPath in
                let value = getMyPost.value
                getDetailRow.onNext(String(value[indexPath.row].id))
            }).disposed(by: disposeBag)
        
        input.postScrap.asObservable()
            .withLatestFrom(scrapInfo)
            .subscribe(onNext: {[weak self] row, data in
                guard let self = self else { return }
                let postId = data[row].id
                if !data[row].isScrap {
                    api.scrapPost(id: postId).subscribe(onNext: { response in
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
                    api.scrapDelete(id: postId).subscribe(onNext: { response in
                        switch response {
                        case .ok:
                            scrapResult.accept(())
                        default:
                            result.onNext("서버 오류")
                        }
                    }).disposed(by: self.disposeBag)
                }
            })
        return Output(myNickname: nickname.asDriver(onErrorJustReturn: nil), myPosts: getMyPost.asDriver(onErrorJustReturn: []), detailIndexPath: getDetailRow.asDriver(onErrorJustReturn: ""), scrapResult: scrapResult.asDriver(onErrorJustReturn: ()))
    }
}
