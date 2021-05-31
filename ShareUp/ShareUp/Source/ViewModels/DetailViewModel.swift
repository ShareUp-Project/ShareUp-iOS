//
//  DetailViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/12.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let getDetail: Signal<Void>
        let detailPostId: String
        let postScrap: Driver<Void>
        let deletePost: Driver<Void>
        let getOtherProfile: Signal<Void>
    }
    
    struct Output {
        let getDetail: Driver<DetailPost?>
        let scrapResult: Driver<Void>
        let result: Signal<String>
        let profileResult: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<String>()
        let getDetailData = BehaviorRelay<DetailPost?>(value: nil)
        let scrapResult = PublishRelay<Void>()
        let profileIndexPath = PublishSubject<String>()

        input.getDetail.asObservable()
            .flatMap { api.detailPost(input.detailPostId) }
            .subscribe(onNext: { data, response in
                switch response {
                case .ok:
                    getDetailData.accept(data!.response)
                default:
                    result.onNext("서버 오류")
                }
            }).disposed(by: self.disposeBag)
        
        input.postScrap.asObservable().withLatestFrom(getDetailData).subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            let postId = data?.id
            if !data!.isScrap {
                api.scrapPost(postId!).subscribe(onNext: { response in
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
                api.scrapDelete(postId!).subscribe(onNext: { response in
                    switch response {
                    case .ok:
                        scrapResult.accept(())
                    default:
                        result.onNext("서버 오류")
                    }
                }).disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
        
        input.deletePost.asObservable()
            .flatMap { _ in api.removePost(input.detailPostId)}
            .subscribe(onNext: { response in
                switch response {
                case .ok:
                    result.onCompleted()
                default:
                    result.onNext("포스트 삭제 서버 오류")
                }
        }).disposed(by: disposeBag)
        
        input.getOtherProfile.asObservable()
            .subscribe(onNext: { _ in
                let value = getDetailData.value
                profileIndexPath.onNext(String(value!.id))
            }).disposed(by: disposeBag)
        
        return Output(getDetail: getDetailData.asDriver(), scrapResult: scrapResult.asDriver(onErrorJustReturn: ()), result: result.asSignal(onErrorJustReturn: ""), profileResult: profileIndexPath.asDriver(onErrorJustReturn: ""))
    }
}
