//
//  ChangeNameViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/07.
//

import Foundation
import RxSwift
import RxCocoa

final class ChangeNameViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    struct Input {
        let nickname: Driver<String>
        let doneTap: Driver<Void>
    }

    struct Output {
        let duplicateCheck: Signal<String>
        let result: Signal<String>
    }

    func transform(_ input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<String>()
        let duplicate = PublishSubject<String>()
        
        input.doneTap.asObservable()
            .withLatestFrom(input.nickname)
            .flatMap { name in api.changeNickname(name: name)}
            .subscribe(onNext: { response in
                switch response {
                case .ok:
                    duplicate.onCompleted()
                case .conflict:
                    duplicate.onNext("중복")
                default:
                    duplicate.onNext("글자형식 오류")
                }
            }).disposed(by: disposeBag)
        
        return Output(duplicateCheck: duplicate.asSignal(onErrorJustReturn: ""), result: result.asSignal(onErrorJustReturn: ""))
    }
}
