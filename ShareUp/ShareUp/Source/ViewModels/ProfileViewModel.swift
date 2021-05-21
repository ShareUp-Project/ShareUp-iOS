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
    }
    
    struct Output {
        let myNickname: Driver<String>
        let myPosts: Driver<[Post]>
    }
    
    func transform(_ input: Input) -> Output {
        let api = AuthService()
        let result = PublishSubject<String>()
        let nickname = PublishRelay<String>()
        let getMyPost = BehaviorRelay<[Post]>(value: [])
        var pagination = 0
        
        input.loadProfile.asObservable()
            .withLatestFrom(input.otherProfileId)
            .flatMap { id in api.getNickname(id)}
            .subscribe(onNext: { data, response in
                print(response)
                switch response {
                case .ok:
                    nickname.accept(data!.nickname)
                default:
                    result.onNext("getNickname server error")
                }
            }).disposed(by: disposeBag)
        
        input.loadProfile.asObservable()
            .withLatestFrom(input.otherProfileId)
            .flatMap { id in api.getUserPosts(id, 0)}
            .subscribe(onNext: { data, response in
                print("profile \(data!)")
                switch response {
                case .ok:
                    getMyPost.accept(data!.data)
                default:
                    result.onNext("getUserPosts server error")
                }
            }).disposed(by: disposeBag)
        
        input.loadMoreProfile.asObservable()
            .map { pagination += 1}
            .flatMap { _ in api.getUserPosts("", pagination)}
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
        
        return Output(myNickname: nickname.asDriver(onErrorJustReturn: ""), myPosts: getMyPost.asDriver(onErrorJustReturn: []))
    }
}
