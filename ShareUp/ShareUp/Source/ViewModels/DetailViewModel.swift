//
//  DetailViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/12.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let getDetail: Signal<Void>
        let detailPostId: String
        let postScrap: Driver<Void>
    }
    
    struct Output {
        let getDetail: PublishRelay<DetailPost>
        let scrapResult: Driver<Void>
        let result: Signal<String>
    }
    
    func transform(_ input: Input) -> Output {
        let result = PublishSubject<String>()
        let getDetailData = PublishRelay<DetailPost>()
        let scrapResult = PublishRelay<Void>()
        let api = AuthService()
        
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
            let postId = data.id
            if !data.isScrap {
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
        
        return Output(getDetail: getDetailData, scrapResult: scrapResult.asDriver(onErrorJustReturn: ()), result: result.asSignal(onErrorJustReturn: ""))
    }
}
