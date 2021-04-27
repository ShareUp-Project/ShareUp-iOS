//
//  ShareUpAPI.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/29.
//

import Foundation
import Moya

enum ShareUpAPI {
    case signUp(_ phoneNum: String, _ nickname: String, _ password: String)
    case phoneCertify(_ phoneNum: String)
    case nicknameCheck(_ nickname: String)
    case passwordReset(_ phoneNum: String, _ password: String)
    case signIn(_ phoneNum: String, _ password: String)
    case checkCode(_ phone: String, _ code: String)
    case certifyPassword(_ phoneNum: String)
    case autoLogin
    
    case getPosts(_ page: Int)
    case wirtePost(_ content: String, _ category: String, _ tags: [String], _ images: [Data], _ title: String)
    case scrapPost(_ id: String)
    case detailPost(_ id: String)
    case getScrapPost(_ page: Int)
    case removePost(_ id: String)
    case scrapDelete(_ id: String)
    case searchPosts(_ tags: String, _ page: Int)
}

extension ShareUpAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://52.79.143.242/api")!
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
            return "/phone/password"
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .nicknameCheck, .signIn, .signUp, .phoneCertify, .checkCode, .certifyPassword, .wirtePost, .scrapPost, .searchPosts:
            return .post
        case .passwordReset:
            return .put
        case .autoLogin, .getPosts, .getScrapPost, .detailPost:
            return .get
        case .removePost, .scrapDelete:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
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
            print(multipartFormData)
            return .uploadMultipart(multipartFormData)
        case .getPosts(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .getScrapPost(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .searchPosts(let tags, let page):
            return .requestParameters(parameters: ["tags" : tags, "page": page], encoding: URLEncoding.queryString)
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
}
