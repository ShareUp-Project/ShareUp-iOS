//
//  ServiceType.swift
//  ShareUp
//
//  Created by 이가영 on 2021/06/08.
//

import Foundation
import RxSwift

typealias ReturnState = Observable<StatusRules>
typealias ReturnStateWithData = Observable<(Codable?, StatusRules)>
typealias WriteResult = Observable<(WritePost?, StatusRules)>
typealias PostResult = Observable<(Posts?, StatusRules)>
typealias ScrapResult = Observable<(Scrap?, StatusRules)>
typealias DetailResult = Observable<(Detail?, StatusRules)>
typealias NicknameResult = Observable<(Nickname?, StatusRules)>
typealias EditorResult = Observable<(Editor?, StatusRules)>
typealias WeeklyResult = Observable<(WeeklyPost?, StatusRules)>
typealias BadgeResult = Observable<(Badge?, StatusRules)>

protocol ServiceType {
    //Auth
    func signIn(_ phone: String, _ password: String) -> ReturnState
    func signUp(_ phone: String, _ password: String, nickname: String) -> ReturnState
    func phoneCertify(phone: String) -> ReturnState
    func nicknameCertify(nickname: String) -> ReturnState
    func passwordReset(_ phone: String,_ password: String) -> ReturnState
    func checkCode(_ phone: String, code: String) -> ReturnState
    func passwordCertify(phone: String) -> ReturnState
    func autoLogin() -> ReturnState
    
    //Post
    func writePost(_ title: String, _ content: String, _ category: String, _ tags: [String], _ images: [Data]) -> WriteResult
    func scrapPost(id: String) -> ReturnState
    func scrapDelete(id: String) -> ReturnState
    func removePost(id: String) -> ReturnState
    func weeklyPosts() -> WeeklyResult
    func getPosts(_ page: Int) -> PostResult
    func getScrapPosts(_ page: Int) -> ScrapResult
    func detailPost(id: String) -> DetailResult
    func searchPosts(tags: String, _ page: Int) -> PostResult
    func getCategorySearch(category: String, _ page: Int) -> PostResult

    //Profile
    func getNickname(id: String?) -> NicknameResult
    func getUserPosts(id: String, _ page: Int) -> PostResult
    func changeNickname(name: String) -> ReturnState
    func getBadgeList() -> BadgeResult
    func postBadge(category: String, level: Int) -> ReturnState
    
    //Editor
    func getEditorPosts(_ page: Int) -> EditorResult
}

