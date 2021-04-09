//
//  MainViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/08.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input{
        let getPosts: Completable
    }
    
    struct Output{
        let getPosts: Driver<[Post]>
    }
    
    func transform(_ input: Input) -> Output {
        let api = AuthService()
        let result = PublishSubject<String>()
        let getPostsData = PublishRelay<[Post]>()
        
        input.getPosts.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            api.getPosts(0).asObservable().subscribe(onNext: { data, response in
                switch response {
                case .ok:
                    getPostsData.accept(data!.data)
                default:
                    result.onNext("서버 오류")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(getPosts: getPostsData.asDriver(onErrorJustReturn: []))
    }
}
