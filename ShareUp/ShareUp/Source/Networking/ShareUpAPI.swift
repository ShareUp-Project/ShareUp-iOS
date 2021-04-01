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
}

extension ShareUpAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.209.98.119/api")!
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/user"
        case .phoneCertify:
            return "/phone"
        case .nicknameCheck:
            return "/user/nickname"
        case .passwordReset:
            return "/user/password"
        case .signIn:
            return "/auth"
        case .checkCode:
            return "/phone/check"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .nicknameCheck, .signIn, .signUp, .phoneCertify, .checkCode:
            return .post
        case .passwordReset:
            return .put
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return nil
        }
    }
}
