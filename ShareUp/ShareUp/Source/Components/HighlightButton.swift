//
//  HighlightButton.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/31.
//

import UIKit

class HighlightedButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? MainColor.secondaryGreen : MainColor.primaryGreen
        }
    }
    
}
