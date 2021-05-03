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
        let loadDetail: Driver<IndexPath>
        let searchContent: Driver<String?>
        let searchCategory: Driver<String>
    }

    struct Output {
        let result: Signal<String>
        let getSearchPosts: Driver<[Post]>
        let isRecentlyOn: Driver<Bool>
        let getCategoryPosts: Driver<[Post]>
        let detailIndexPath: Signal<String>
    }

    func transform(_ input: Input) -> Output {
        let api = AuthService()
        let result = PublishSubject<String>()
        let getSearchData = BehaviorRelay<[Post]>(value: [])
        let getCategoryPosts = BehaviorRelay<[Post]>(value: [])
        let getDetailRow = PublishSubject<String>()
        let isRecentlyOn = input.searchContent.map { $0?.isEmpty ?? false }
            
        input.searchTap.asObservable().withLatestFrom(input.searchContent).subscribe(onNext: { [weak self] word in
            guard let self = self else { return }
            api.searchPosts(word!, 0).subscribe(onNext: { data, response in
                print(data)
                switch response {
                case .ok:
                    getSearchData.accept(data!.data)
                default:
                    result.onNext("서버 오류")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.searchCategory.asObservable()
            .flatMap { category in api.getCategorySearch(0, category)}
            .subscribe(onNext: { data, response in
                print(response)
                switch response {
                case .ok:
                    getCategoryPosts.accept(data!.data)
                default:
                    result.onNext("server error")
                }
            }).disposed(by: disposeBag)
        
        input.loadDetail.asObservable().subscribe(onNext: { indexPath in
            let value = getCategoryPosts.value
            getDetailRow.onNext(String(value[indexPath.row].id))
        }).disposed(by: disposeBag)
        
        return Output(result: result.asSignal(onErrorJustReturn: ""), getSearchPosts: getSearchData.asDriver(), isRecentlyOn: isRecentlyOn.asDriver(), getCategoryPosts: getCategoryPosts.asDriver(onErrorJustReturn: []), detailIndexPath: getDetailRow.asSignal(onErrorJustReturn: ""))
    }
}
