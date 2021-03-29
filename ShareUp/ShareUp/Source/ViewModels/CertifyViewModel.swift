//
//  CertifyViewModel.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/29.
//

import Foundation
import RxSwift
import RxCocoa

//class CertifyViewModel: ViewModelType {
//    private let disposeBag = DisposeBag()
//
//    struct Input {
//        let phoneNum: Driver<String>
//        let phoneRequest: Driver<Void>
//        let phoneCertify: Driver<String>
//    }
//    
//    struct Output {
//        let phoneCertify: Driver<String>
//    }
//
//    func transform(_ input: Input) -> Output {
//        let result = PublishSubject<String>()
//        let api = AuthService()
//
//        input.phoneNum.asObservable().withLatestFrom(input.phoneNum).subscribe(onNext: {[weak self] phone in
//            guard let self = self else { return }
//            api.phoneCertify(phone).subscribe(onNext: { response in
//                switch response {
//                case .ok:
//                    result.onCompleted()
//                case .notFound:
//                    result.onNext("아이디 또는 비밀번호가 잘못되었습니다.")
//                default:
//                    result.onNext("오류로 로그인이 작동하지 않습니다.")
//                }
//            }).disposed(by: self.disposeBag)
//        }).disposed(by: disposeBag)
//
//        return Output(phoneCertify: <#T##Driver<String>#>)
//    }
//}
