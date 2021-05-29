//
//  FindAuthViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/01.
//

import Foundation
import RxSwift
import RxCocoa

final class FindAuthViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    struct Input {
        let phoneNum: Driver<String>
        let phoneRequest: Driver<Void>
        let phoneCertify: Driver<String>
        let certifyButton: Driver<Void>
    }

    struct Output {
        let wait: Signal<String>
        let result: Signal<String>
    }

    func transform(_ input: Input) -> Output {
        let result = PublishSubject<String>()
        let waitAuthCode = PublishSubject<String>()
        let info = Driver.combineLatest(input.phoneCertify, input.phoneNum)
        let api = Service()
        
        input.phoneRequest.asObservable()
            .withLatestFrom(input.phoneNum)
            .flatMap { phone in api.certifyPassword(phone)}
            .subscribe(onNext: { response in
                switch response {
                case .ok:
                    waitAuthCode.onCompleted()
                case .conflict:
                    waitAuthCode.onNext("이미 가입된 전화번호입니다.")
                default:
                    waitAuthCode.onNext("존재하지 않는 전화번호입니다.")
                }
            }).disposed(by: disposeBag)
        
        input.certifyButton.asObservable()
            .withLatestFrom(info)
            .flatMap { code, phone in api.checkCode(phone: phone, code)}
            .subscribe(onNext: { response in
                print(response)
                switch response {
                case .ok:
                    result.onCompleted()
                case .unauthorized:
                    result.onNext("인증번호가 올바르지 않습니다.")
                default:
                    result.onNext("인증번호가 올ㄹ바르지 않습니다.")
                }
            }).disposed(by: disposeBag)
        
        return Output(wait: waitAuthCode.asSignal(onErrorJustReturn: ""), result: result.asSignal(onErrorJustReturn: "") )
    }
}
