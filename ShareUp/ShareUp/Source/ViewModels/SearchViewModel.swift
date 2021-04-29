//
//  SearchViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/27.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    struct Input {
        let searchTap: Driver<Void>
        let searchContent: Driver<String?>
    }

    struct Output {
        let result: Signal<String>
        let getSearchPosts: Driver<[Post]>
        let isRecentlyOn: Driver<Bool>
    }

    func transform(_ input: Input) -> Output {
        let api = AuthService()
        let result = PublishSubject<String>()
        let getSearchData = BehaviorRelay<[Post]>(value: [])
        let isRecentlyOn = input.searchContent.map { !($0?.isEmpty ?? false) }
            
        input.searchTap.asObservable().withLatestFrom(input.searchContent).subscribe(onNext: { [weak self] word in
            guard let self = self else { return }
            api.searchPosts(word!, 0).subscribe(onNext: { data, response in
                switch response {
                case .ok:
                    getSearchData.accept(data!.data)
                default:
                    result.onNext("서버 오류")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(result: result.asSignal(onErrorJustReturn: ""), getSearchPosts: getSearchData.asDriver(), isRecentlyOn: isRecentlyOn.asDriver())
    }
}
