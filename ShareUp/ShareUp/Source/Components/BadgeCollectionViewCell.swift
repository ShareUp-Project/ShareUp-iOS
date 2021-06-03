//
//  BadgeCollectionViewCell.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/18.
//

import UIKit

final class BadgeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var badgeNameLabel: UILabel!
    
    func configCell(_ data: Int, indexPath: Int) {
        switch indexPath {
        case 0:
            badgeImageView.image = UIImage(named: "default0")
            badgeNameLabel.text = "첫 걸음"
        case 1:
            badgeImageView.image = data == 0 ? UIImage(named: "0") : UIImage(named: "first0")
            badgeNameLabel.text = "삐약삐약"
        case 2:
            badgeImageView.image = data == 0 ? UIImage(named: "0") : UIImage(named: "paper\(data)")
            badgeNameLabel.text = "종이"
        case 3:
            badgeImageView.image = data == 0 ? UIImage(named: "0") : UIImage(named: "plastic\(data)")
            badgeNameLabel.text = "플라스틱"
        case 4:
            badgeImageView.image = data == 0 ? UIImage(named: "0") : UIImage(named: "glass\(data)")
            badgeNameLabel.text = "유리"
        case 5:
            badgeImageView.image = data == 0 ? UIImage(named: "0") : UIImage(named: "styrofoam\(data)")
            badgeNameLabel.text = "스티로폼"
        case 6:
            badgeImageView.image = data == 0 ? UIImage(named: "0") : UIImage(named: "vinyl\(data)")
            badgeNameLabel.text = "비닐"
        case 7:
            badgeImageView.image = data == 0 ? UIImage(named: "0") : UIImage(named: "can\(data)")
            badgeNameLabel.text = "캔"
        case 8:
            badgeImageView.image = data == 0 ? UIImage(named: "0") : UIImage(named: "clothing\(data)")
            badgeNameLabel.text = "의류"
        default:
            print("no more badge")
        }
    }
}
