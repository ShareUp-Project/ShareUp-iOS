//
//  ShareUpAPI.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/29.
//

import Foundation
import Moya

enum ShareUpAPI {
    //Auth
    case signUp(_ phoneNum: String, _ nickname: String, _ password: String)
    case phoneCertify(_ phoneNum: String)
    case nicknameCheck(_ nickname: String)
    case passwordReset(_ phoneNum: String, _ password: String)
    case signIn(_ phoneNum: String, _ password: String)
    case checkCode(_ phone: String, _ code: String)
    case certifyPassword(_ phoneNum: String)
    case autoLogin
    
    //Post
    case getPosts(_ page: Int)
    case wirtePost(_ content: String, _ category: String, _ tags: [String], _ images: [Data], _ title: String)
    case scrapPost(_ id: String)
    case detailPost(_ id: String)
    case getScrapPost(_ page: Int)
    case removePost(_ id: String)
    case scrapDelete(_ id: String)
    case searchPosts(_ tags: String, _ page: Int)
    case weeklyPost

    //Profile
    case getNickname(_ id: String?)
    case getCategorySearch(_ page: Int, _ category: String)
    case getUserPosts(_ id: String?, _ page: Int)
    case getBadgeList
    case postBadge(_ category: String, _ level: Int)
    case changeNickname(_ name: String)
    
    //Editor
    case getEditorPosts(_ page: Int)
    
}

extension ShareUpAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://3.34.188.161/api")!
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/users"
        case .phoneCertify:
            return "/phones"
        case .nicknameCheck:
            return "/users/nickname"
        case .passwordReset:
            return "/users/password"
        case .signIn:
            return "/auth"
        case .checkCode:
            return "/phones/check"
        case .certifyPassword:
            return "/phones/password"
        case .autoLogin:
            return "/auth/refresh"
        case .getPosts:
            return "/posts"
        case .wirtePost:
            return "/posts"
        case .scrapPost(let id), .scrapDelete(let id):
            return "/posts/scraps/\(id)"
        case .detailPost(let id):
            return "/posts/\(id)"
        case .getScrapPost:
            return "/posts/scraps"
        case .removePost(let id):
            return "/posts/\(id)"
        case .searchPosts:
            return "/posts/search"
        case .getNickname(let id):
            return "/users/profile/\(id ?? "")"
        case .getUserPosts(let id, _):
            return "/posts/users/\(id ?? "")"
        case .getCategorySearch:
            return "/posts"
        case .getEditorPosts:
            return "/posts/editor"
        case .changeNickname:
            return "users/nickname"
        case .weeklyPost:
            return "/posts/weeks"
        case .getBadgeList:
            return "/users/badge"
        case .postBadge:
            return "/users/badge"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .nicknameCheck, .signIn, .signUp, .phoneCertify, .checkCode, .certifyPassword, .wirtePost, .scrapPost:
            return .post
        case .passwordReset, .changeNickname, .postBadge:
            return .put
        case .autoLogin, .getPosts, .getScrapPost, .detailPost, .searchPosts, .getNickname, .getUserPosts, .getEditorPosts, .getCategorySearch, .weeklyPost, .getBadgeList:
            return .get
        case .removePost, .scrapDelete:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let phoneNum, let password):
            return .requestParameters(parameters: ["phone": phoneNum, "password": password], encoding: JSONEncoding.prettyPrinted)
        case .signUp(let phoneNum, let nickname, let password):
            return .requestParameters(parameters: ["phone": phoneNum, "nickname": nickname, "password": password], encoding: JSONEncoding.prettyPrinted)
        case .phoneCertify(let phoneNum):
            return .requestParameters(parameters: ["phone": phoneNum], encoding: JSONEncoding.prettyPrinted)
        case .nicknameCheck(let nickename):
            return .requestParameters(parameters: ["nickname": nickename], encoding: JSONEncoding.prettyPrinted)
        case .passwordReset(let phoneNum, let password):
            return .requestParameters(parameters: ["password": password, "phone": phoneNum], encoding: JSONEncoding.prettyPrinted)
        case .checkCode(let phone , let code):
            return .requestParameters(parameters: ["phone": phone, "code" : code], encoding: JSONEncoding.prettyPrinted)
        case .certifyPassword(let phone):
            return .requestParameters(parameters: ["phone": phone], encoding: JSONEncoding.prettyPrinted)
        case .wirtePost(let content, let category, let tags, let images, let title):
            var multipartFormData = [MultipartFormData]()
            for index in images {
                multipartFormData.append(MultipartFormData(provider: .data(index), name: "images", fileName: "image.jpg", mimeType: "image/png"))
            }
            for i in tags {
                multipartFormData.append(MultipartFormData(provider: .data(i.data(using: .utf8)!), name: "tags", mimeType: "text/plain"))
            }
            multipartFormData.append(MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content", mimeType: "text/plain"))
            multipartFormData.append(MultipartFormData(provider: .data(category.data(using: .utf8)!), name: "category", mimeType: "text/plain"))
            multipartFormData.append(MultipartFormData(provider: .data(title.data(using: .utf8)!), name: "title", mimeType: "text/plain"))
            return .uploadMultipart(multipartFormData)
        case .getScrapPost(let page), .getUserPosts( _, let page), .getPosts(let page), .getEditorPosts(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .searchPosts(let tags, let page):
            return .requestParameters(parameters: ["word" : tags, "page": page], encoding: URLEncoding.queryString)
        case .getCategorySearch(let page, let category):
            return .requestParameters(parameters: ["page" : page, "category": category], encoding: URLEncoding.queryString)
        case .changeNickname(let name):
            return .requestParameters(parameters: ["nickname": name], encoding: JSONEncoding.prettyPrinted)
        case .postBadge(let category, let level):
            return .requestParameters(parameters: ["category": category, "level": level], encoding: JSONEncoding.prettyPrinted)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .autoLogin:
            guard let refresh = TokenManager.currentToken?.refreshToken else { return nil }
            return ["Authorization" : "Bearer " + refresh ]
        default:
            guard let token = TokenManager.currentToken?.accessToken else { return nil }
            return ["Authorization" : "Bearer " + token ]
        }
    }
    
    var sampleData: Data {
        return Data()
    }
}
                                                                            
