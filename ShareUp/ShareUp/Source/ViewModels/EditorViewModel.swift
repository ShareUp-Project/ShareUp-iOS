//
//  EditorViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/03.
//

import Foundation
import RxSwift
import RxCocoa

final class EditorViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input{
        let loadData: Driver<Void>
        let loadMoreData: Driver<Void>
        let loadDetail: Driver<IndexPath>
    }
    
    struct Output{
        let getEditorPosts: Driver<[EditorPost]>
        let getDetailValue: Signal<EditorPost>
    }
    
    func transform(_ input: Input) -> Output {
        let api = AuthService()
        let result = PublishSubject<String>()
        let getEditorPosts = BehaviorRelay<[EditorPost]>(value: [])
        let getDetailValue = PublishRelay<EditorPost>()
        var pagination: Int = 0
        
        input.loadData.asObservable()
            .flatMap { _ in api.getEditorPosts(0)}
            .subscribe(onNext: { data, response in
                print(response)
                switch response{
                case .ok:
                    getEditorPosts.accept(data!.data)
                default:
                    result.onNext("server error")
                }
            }).disposed(by: disposeBag)
        
        input.loadMoreData.asObservable()
            .map { pagination += 1 }
            .flatMap { _ in api.getEditorPosts(pagination)}
            .subscribe(onNext: { data, response in
                switch response {
                case .ok:
                    for i in data!.data {
                        getEditorPosts.add(element: i)
                    }
                default:
                    result.onNext("server error")
                }
            }).disposed(by: disposeBag)
        
        input.loadDetail.asObservable()
            .subscribe(onNext: { indexPath in
                let value = getEditorPosts.value
                getDetailValue.accept(EditorPost(id: value[indexPath.row].id, title: value[indexPath.row].title, content: value[indexPath.row].content, image: value[indexPath.row].image))
            }).disposed(by: disposeBag)
        
        return Output(getEditorPosts: getEditorPosts.asDriver(), getDetailValue: getDetailValue.asSignal())
    }
}
