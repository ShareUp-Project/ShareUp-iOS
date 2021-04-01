//
//  SignUpViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/01.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    struct Input {
        let phone: Driver<String>
        let nickname: Driver<String>
        let password: Driver<String>
        let doneTap: Driver<Void>
    }

    struct Output {
        let duplicateCheck: Signal<String>
        let result: Signal<String>
    }

    func transform(_ input: Input) -> Output {
        let api = AuthService()
        let result = PublishSubject<String>()
        let duplicate = PublishSubject<String>()
        let info = Driver.combineLatest(input.phone, input.nickname, input.password)

        input.doneTap.asObservable().withLatestFrom(info).subscribe(onNext: { [weak self] phone, nickname, password in
            guard let self = self else { return }
            api.nicknameCheck(nickname).subscribe(onNext: { response in
                print(response)
                switch response {
                case .ok:
                    duplicate.onCompleted()
                case .conflict:
                    duplicate.onNext("중복")
                default:
                    duplicate.onNext("에러")
                }
            }).disposed(by: self.disposeBag)
            
            api.signUp(phone, nickname: nickname, password: password).subscribe(onNext: { response in
                print(response)
                switch response {
                case .ok:
                    result.onCompleted()
                case .conflict:
                    result.onNext("중복된 닉네임입니다.")
                default:
                    result.onNext("오류로 회원가입이 작동하지 않습니다.")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(duplicateCheck: duplicate.asSignal(onErrorJustReturn: ""), result: result.asSignal(onErrorJustReturn: ""))
    }
}
