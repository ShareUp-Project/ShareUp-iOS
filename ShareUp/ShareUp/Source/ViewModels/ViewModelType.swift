//
//  ViewModelType.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(_ input: Input) -> Output
}
