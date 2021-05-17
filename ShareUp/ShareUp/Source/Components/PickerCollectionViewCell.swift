//
//  PickerCollectionViewCell.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/14.
//

import UIKit
import RxSwift

final class PickerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pickerImageView: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
