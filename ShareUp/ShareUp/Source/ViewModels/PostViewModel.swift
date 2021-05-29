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

final class PostViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let postTap: Driver<Void>
        let isImage: Driver<[Data]>
        let isTitle: Driver<String>
        let isContent: Driver<String>
        let isCategory: Driver<String>
    }
    
    struct Output {
        let result: Driver<BadgeInfo?>
        let isEnable: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let hashtag = input.isContent.map { $0.getHashtags() }
        let filterCategory = input.isCategory.map { ShareUpFilter.filterCategory($0) }
        let api = Service()
        let result = PublishSubject<BadgeInfo?>()
        let info = Driver.combineLatest(input.isImage, filterCategory, input.isTitle, input.isContent, hashtag.asDriver())
        let isEnable = info.map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty && !$0.3.isEmpty }
        
        input.postTap.asObservable()
            .withLatestFrom(info)
            .flatMap { images, category, title, content, hashtag in api.writePost(content, category, hashtag, images, title)}
            .subscribe(onNext: { data, response in
                print(response)
                switch response {
                case .ok:
                    result.onNext(data!.badgeInfo)
                default:
                    print("글 쓰기를 다시 시도해보세요.")
                }
            }).disposed(by: disposeBag)
        
        return Output(result: result.asDriver(onErrorJustReturn: nil), isEnable: isEnable.asDriver(onErrorJustReturn: false))
    }
}
