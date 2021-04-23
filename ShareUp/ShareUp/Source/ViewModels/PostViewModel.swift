//
//  PostViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/15.
//

import Foundation
import RxSwift
import RxCocoa
import Photos

class PostViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let postTap: Driver<Void>
        let isImage: Driver<[Data]>
        let isTitle: Driver<String>
        let isContent: Driver<String>
        let isCategory: Driver<String>
    }
    
    struct Output {
        let result: Signal<String>
        let isEnable: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let hashtag = input.isContent.map { $0.getHashtags() }
        let filterCategory = input.isCategory.map { ShareUpFilter.filterCategory($0) }
        let api = AuthService()
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(input.isImage, filterCategory, input.isTitle, input.isContent, hashtag.asDriver())
        let isEnable = info.map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty && !$0.3.isEmpty }
    
        input.postTap.asObservable().withLatestFrom(info).subscribe(onNext: { [weak self] images, category, title, content, hashtag in
            guard let self = self else { return }
            api.writePost(content, category, hashtag ?? [" "], images, title).subscribe(onNext: { response in
                switch response {
                case .ok:
                    result.onCompleted()
                default:
                    result.onNext("서버 오류")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(result: result.asSignal(onErrorJustReturn: ""), isEnable: isEnable.asDriver(onErrorJustReturn: false))
    }
}
