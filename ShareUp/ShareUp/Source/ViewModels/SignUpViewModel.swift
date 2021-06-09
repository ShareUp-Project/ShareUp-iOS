//
//  SignUpViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/01.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
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
        let errorIsHidden: Driver<Bool>
    }

    func transform(_ input: Input) -> Output {
        let api = Service()
        let result = PublishSubject<String>()
        let duplicate = PublishSubject<String>()
        let info = Driver.combineLatest(input.phone, input.nickname, input.password)
        let errorIsHidden = info.map { ShareUpFilter.checkPassword($0.2) }
        
        input.doneTap.asObservable()
            .withLatestFrom(input.nickname)
            .flatMap { nickname in api.nicknameCertify(nickname: nickname)}
            .subscribe(onNext: { response in
                print(response)
                switch response {
                case .ok:
                    duplicate.onCompleted()
                case .conflict:
                    duplicate.onNext("중복")
                default:
                    duplicate.onNext("에러")
                }
            }).disposed(by: disposeBag)
            
        input.doneTap.asObservable()
            .withLatestFrom(info)
            .flatMap { phone, nickname, password in api.signUp(phone, nickname, nickname: password)}
            .subscribe(onNext: { response in
                print(response)
                switch response {
                case .ok:
                    result.onCompleted()
                case .conflict:
                    result.onNext("중복된 닉네임입니다.")
                default:
                    result.onNext("비밀번호 형식이 올바르지 않습니다.")
                }
            }).disposed(by: disposeBag)
    
        return Output(duplicateCheck: duplicate.asSignal(onErrorJustReturn: ""), result: result.asSignal(onErrorJustReturn: ""), errorIsHidden: errorIsHidden.asDriver())
    }
}
