//
//  AuthAPI.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/29.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class AuthService {
    
    let provider = MoyaProvider<ShareUpAPI>()
    
    func signIn(_ phone: String,_ password: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.signIn(phone, password))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(Tokens.self)
            .map { token -> (StatusRules) in
                print(token)
                if StoregaeManager.shared.create(token) { return (.ok) }
                return .fail
            }.catchError { [unowned self] in return .just(setNetworkError($0)) }
    }
    
    func signUp(_ phone: String, nickname: String, password: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.signUp(phone, nickname, password))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { [unowned self] in return .just(setNetworkError($0))}
    }
    
    func phoneCertify(_ phone: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.phoneCertify(phone))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok)}
            .catchError { [unowned self] in return .just(setNetworkError($0))}
    }
    
    func nicknameCheck(_ nickname: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.nicknameCheck(nickname))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok)}
            .catchError { [unowned self] in return .just(setNetworkError($0))}
    }
    
    func passwordReset(_ phone: String, _ password: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.passwordReset(phone, password))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok)}
            .catchError { [unowned self] in return .just(setNetworkError($0))}
    }
    
    func checkCode(phone: String, _ code: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.checkCode(phone, code))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { [unowned self] in return .just(setNetworkError($0))}
    }
    
    func certifyPassword(_ phone: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.certifyPassword(phone))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok)}
            .catchError { [unowned self] in return .just(setNetworkError($0))}
    }
    
    func autoLogin() -> Observable<(StatusRules)> {
        return provider.rx.request(.autoLogin)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { [unowned self] in return .just(setNetworkError($0))}
    }
    
    func setNetworkError(_ error: Error) -> StatusRules {
        print(error)
        print(error.localizedDescription)
        guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fail) }
        return (StatusRules(rawValue: status) ?? .fail)
    }
    
}
