//
//  AuthTextField.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AuthTextField: UITextField {
    
    private let maskButton = UIButton()
    private let disposeBag = DisposeBag()
    var rightViewSize = Int()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        controlTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        controlTextField()
    }
    
    private func controlTextField() {
        clipsToBounds = true
        endEditingTextField()
        font = UIFont(name: Font.nsM.rawValue, size: 16)
        rx.controlEvent(.allEditingEvents).subscribe(onNext: {[unowned self] _ in editingTextField() }).disposed(by: disposeBag)
        rx.controlEvent(.editingDidEnd).subscribe(onNext: {[unowned self] _ in endEditingTextField() }).disposed(by: disposeBag)

        rightView = maskButton
        rightViewMode = .always
        translatesAutoresizingMaskIntoConstraints = false
        rightView?.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func editingTextField() {
        layer.borderColor = MainColor.secondaryGreen.cgColor
        layer.borderWidth = 1
        backgroundColor = .white
    }

    private func endEditingTextField() {
        backgroundColor = MainColor.gray01
        layer.borderColor = MainColor.gray02.cgColor
        layer.borderWidth = 1
    }
}
