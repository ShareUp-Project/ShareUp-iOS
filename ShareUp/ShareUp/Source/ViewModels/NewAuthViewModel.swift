//
//  NewAuthViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/01.
//

import Foundation
import RxSwift
import RxCocoa

final class NewAuthViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let phoneNum: Driver<String>
        let newPassword: Driver<String>
        let againPassword: Driver<String>
        let resetTap: Driver<Void>
    }
    
    struct Output {
        let result: Signal<String>
        let isEquals: Driver<Bool>
        let errorIsHidden: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<String>()
        let checkInfo = Driver.combineLatest(input.newPassword, input.againPassword)
        let resetInfo = Driver.combineLatest(input.phoneNum, input.newPassword, input.againPassword)
        let isEquals = checkInfo.map { !$0.1.isEmpty && !$0.0.isEmpty && $0.0 == $0.1 ? true : false }
        let errorIsHidden = checkInfo.map { ShareUpFilter.checkPassword($0.1) }

        input.resetTap.asObservable()
            .withLatestFrom(resetInfo)
            .flatMap { phone, newPassword, password in api.passwordReset(phone, password)}
            .subscribe(onNext: { response in
                switch response {
                case .ok:
                    result.onCompleted()
                case .notFound:
                    result.onNext("전화번호에 해당하는 유저가 없습니다.")
                default:
                    result.onNext("비밀번호가 일치하지 않습니다.")
                }
            }).disposed(by: disposeBag)
        
        return Output(result: result.asSignal(onErrorJustReturn: ""),  isEquals: isEquals.asDriver(), errorIsHidden: errorIsHidden.asDriver())
    }
}
