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

final class Service {
    
    let provider = MoyaProvider<ShareUpAPI>()
    
    func signIn(_ phone: String,_ password: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.signIn(phone, password))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(Tokens.self)
            .map { token -> (StatusRules) in
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
            .map(Tokens.self)
            .map { token -> (StatusRules) in
                print(token)
                if StoregaeManager.shared.create(token) { return (.ok) }
                return .fail
            }.catchError { [unowned self] in return .just(setNetworkError($0))
            }
    }
    
    func writePost(_ content: String, _ category: String, _ tags: [String], _ images: [Data], _ title: String) -> Observable<(WritePost?, StatusRules)> {
        return provider.rx.request(.wirtePost(content, category, tags, images, title))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(WritePost.self)
            .map { return ($0, .ok) }
            .catchError { errer in
                print(errer)
               return .just((nil, .fail))
            }
    }
    
    func scrapPost(_ id: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.scrapPost(id))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { [unowned self] in return .just(setNetworkError($0))}
    }
    
    func scrapDelete(_ id: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.scrapDelete(id))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { [unowned self] in return .just(setNetworkError($0))}
    }
    
    func removePost(_ id: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.removePost(id))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok) }
            .catchError { [unowned self] in return .just(setNetworkError($0))}
    }
    
    func getPosts(_ page: Int) -> Observable<(Posts?, StatusRules)> {
        return provider.rx.request(.getPosts(page))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(Posts.self)
            .map { return ($0, .ok) }
            .catchError { errer in
                print(errer)
               return .just((nil, .fail))
            }
    }
    
    func getScrapPosts(_ page: Int) -> Observable<(Scrap?, StatusRules)> {
        return provider.rx.request(.getScrapPost(page))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(Scrap.self)
            .map { return ($0, .ok) }
            .catchError { error in
                print(error)
                return .just((nil, .fail))}
    }
    
    func detailPost(_ id: String) -> Observable<(Detail?, StatusRules)> {
        return provider.rx.request(.detailPost(id))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(Detail.self)
            .map { return ($0, .ok) }
            .catchError { errer in
                print(errer)
               return .just((nil, .fail))
            }
    }
    
    func searchPosts(_ tags: String, _ page: Int) -> Observable<(Posts?, StatusRules)> {
        return provider.rx.request(.searchPosts(tags, page))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map (Posts.self)
            .map { return ($0, .ok)}
            .catchError { error in
                print(self.setNetworkError(error))
                return .just((nil, .fail))
            }
    }
    
    func getNickname(_ id: String?) -> Observable<(Nickname?, StatusRules)> {
        return provider.rx.request(.getNickname(id ?? ""))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map (Nickname.self)
            .map { return ($0, .ok)}
            .catchError { error in
                print(self.setNetworkError(error))
                return .just((nil, .fail))
            }
    }
    
    func getUserPosts(_ id: String, _ page: Int) -> Observable<(Posts?, StatusRules)> {
        return provider.rx.request(.getUserPosts(id, page))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map (Posts.self)
            .map { return ($0, .ok)}
            .catchError { error in
                print(self.setNetworkError(error))
                return .just((nil, .fail))
            }
    }
    
    func getCategorySearch(_ page: Int, _ category: String) -> Observable<(Posts?, StatusRules)> {
        return provider.rx.request(.getCategorySearch(page, category))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map (Posts.self)
            .map { return ($0, .ok)}
            .catchError { error in
                print(self.setNetworkError(error))
                return .just((nil, .fail))
            }
    }
    
    func getEditorPosts(_ page: Int) -> Observable<(Editor?, StatusRules)> {
        return provider.rx.request(.getEditorPosts(page))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map (Editor.self)
            .map { return ($0, .ok) }
            .catchError { error in
                print(self.setNetworkError(error))
                return .just((nil, .fail))
            }
    }
    
    func changeNickname(_ name: String) -> Observable<(StatusRules)> {
        return provider.rx.request(.changeNickname(name))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok)}
            .catchError { [unowned self] in return .just(setNetworkError($0))}
    }
    
    func weeklyPost() -> Observable<(WeeklyPost?, StatusRules)> {
        return provider.rx.request(.weeklyPost)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(WeeklyPost.self)
            .map { return ($0, .ok)}
            .catchError { error in
                return .just((nil, .fail))
            }
    }
    
    func getBadgeList() -> Observable<(Badge?, StatusRules)> {
        return provider.rx.request(.getBadgeList)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(Badge.self)
            .map { return ($0, .ok)}
            .catchError { error in
                print(error)
                print(error.localizedDescription)
                return .just((nil, self.setNetworkError(error)))
            }
    }
    
    func postBadge(_ category: String, _ level: Int) -> Observable<StatusRules> {
        return provider.rx.request(.postBadge(category, level))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ -> StatusRules in return (.ok)}
            .catchError { [unowned self] in return .just(setNetworkError($0))}
    }
    
    func setNetworkError(_ error: Error) -> StatusRules {
        print(error)
        print(error.localizedDescription)
        guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fail) }
        return (StatusRules(rawValue: status) ?? .fail)
    }
}
