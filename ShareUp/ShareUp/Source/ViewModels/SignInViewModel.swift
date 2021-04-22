//
//  SignInViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/30.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let setAutoLogin: Driver<Void>
        let phone: Driver<String>
        let password: Driver<String>
        let isAuto: Driver<Bool>
        let doneTap: Driver<Void>
    }
    
    struct Output {
        let result: Signal<String>
        let isEnable: Driver<Bool>
        let auto: Signal<String>
    }
    
    func transform(_ input: Input) -> Output {
        let api = AuthService()
        let autoResult = PublishSubject<String>()
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(input.phone, input.password, input.isAuto)
        let isEnable = info.map { !$0.0.isEmpty && !$0.1.isEmpty }
        
        input.setAutoLogin.asObservable().subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            if UserDefaults.standard.bool(forKey: "isAutoLogin") && !(TokenManager.currentToken?.refreshToken.isEmpty ?? false){
                api.autoLogin().subscribe(onNext: { response in
                    print(response)
                    switch response {
                    case .ok:
                        autoResult.onCompleted()
                    case .unauthorized:
                        autoResult.onNext("자동 로그인을 사용할 수 없습니다.")
                    default:
                        autoResult.onNext("오류로 자동 로그인이 작동하지 않습니다.")
                    }
                }).disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
        
        input.doneTap.asObservable().withLatestFrom(info).subscribe(onNext: {[weak self] phone, pw, isAuto in
            if isAuto { UserDefaults.standard.set(isAuto, forKey: "isAutoLogin" ) }
            guard let self = self else { return }
            api.signIn(phone, pw).subscribe(onNext: { response in
                print(response)
                switch response {
                case .ok:
                    result.onCompleted()
                case .notFound:
                    result.onNext("전화번호 또는 비밀번호가 일치하지 않습니다.")
                default:
                    result.onNext("오류로 로그인이 작동하지 않습니다.")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(result: result.asSignal(onErrorJustReturn: "로그인 실패"), isEnable: isEnable.asDriver(), auto: autoResult.asSignal(onErrorJustReturn: ""))
    }
}
