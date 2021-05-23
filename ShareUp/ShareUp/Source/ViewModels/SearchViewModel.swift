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
        let loadWeeklyPost: Driver<Void>
        let loadPopularPostDetail: Driver<IndexPath>
    }

    struct Output {
        let result: Signal<String>
        let isRecentlyOn: Driver<Bool>
        let getCategoryPosts: Signal<[Post]>
        let getWeeklyPosts: Driver<[WeeklyPosts]>
        let detailIndexPath: Signal<String>
    }

    func transform(_ input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<String>()
        let getCategoryPosts = BehaviorRelay<[Post]>(value: [])
        let getDetailRow = PublishSubject<String>()
        let isRecentlyOn = input.searchContent.map { $0?.isEmpty ?? false }
        let getWeeklyPosts = BehaviorRelay<[WeeklyPosts]>(value: [])
        
        input.searchTap.asObservable().withLatestFrom(input.searchContent).subscribe(onNext: { [weak self] word in
            guard let self = self else { return }
            
            var savedSearches = UserDefaults.standard.array(forKey: "recentSearches") as! [String]
            if savedSearches.count == 10 { savedSearches.removeFirst() }
            var newSearches = [String]()
            newSearches = savedSearches
            newSearches.append(word!)
            UserDefaults.standard.set(newSearches, forKey: "recentSearches")
            UserDefaults.standard.synchronize()

            api.searchPosts(word!, 0).subscribe(onNext: { data, response in
                switch response {
                case .ok:
                    getCategoryPosts.accept(data!.data)
                default:
                    result.onNext("서버 오류")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        input.loadWeeklyPost.asObservable()
            .flatMap { _ in api.weeklyPost()}
            .subscribe(onNext: { data, response in
                switch response{
                case .ok:
                    getWeeklyPosts.accept(data!.data)
                default:
                    result.onNext("서버 오류")
                }
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
        
        input.loadPopularPostDetail.asObservable().subscribe(onNext: { indexPath in
            let value = getWeeklyPosts.value
            getDetailRow.onNext(String(value[indexPath.row].id))
        }).disposed(by: disposeBag)
        
        return Output(result: result.asSignal(onErrorJustReturn: ""), isRecentlyOn: isRecentlyOn.asDriver(), getCategoryPosts: getCategoryPosts.asSignal(onErrorJustReturn: []), getWeeklyPosts: getWeeklyPosts.asDriver(), detailIndexPath: getDetailRow.asSignal(onErrorJustReturn: ""))
    }
}
