//
//  CertifyViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/29.
//

import Foundation
import RxSwift
import RxCocoa

class CertifyViewModel: ViewModelType {
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
        let api = AuthService()

        input.phoneRequest.asObservable().withLatestFrom(input.phoneNum).subscribe(onNext: {[weak self] phone in
            guard let self = self else { return }
            api.phoneCertify(phone).subscribe(onNext: { response in
                print(response)
                switch response {
                case .ok:
                    waitAuthCode.onCompleted()
                case .conflict:
                    waitAuthCode.onNext("이미 가입된 전화번호입니다.")
                default:
                    waitAuthCode.onNext("인증이 제대로 진행되지 않았습니다.")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        input.certifyButton.asObservable().withLatestFrom(info).subscribe(onNext: {[weak self] code, phone in
            guard let self = self else { return }
            api.checkCode(phone: phone, code).subscribe(onNext: { response in
                print(response)
                switch response {
                case .ok:
                    result.onCompleted()
                case .unauthorized:
                    result.onNext("인증번호가 올바르지 않습니다.")
                default:
                    result.onNext("인증이 제대로 진행되지 않았습니다.")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(wait: waitAuthCode.asSignal(onErrorJustReturn: ""), result: result.asSignal(onErrorJustReturn: "") )
    }
}
