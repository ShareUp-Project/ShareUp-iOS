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
            badgeImageView.image = UIImage(named: "first\(data)")
        case 1:
            badgeImageView.image = UIImage(named: "paper\(data)")
        case 2:
            badgeImageView.image = UIImage(named: "plastic\(data)")
        case 3:
            badgeImageView.image = UIImage(named: "glass\(data)")
        case 4:
            badgeImageView.image = UIImage(named: "styrofoam\(data)")
        case 5:
            badgeImageView.image = UIImage(named: "vinyl\(data)")
        case 6:
            badgeImageView.image = UIImage(named: "can\(data)")
        case 7:
            badgeImageView.image = UIImage(named: "clothing\(data)")
        default:
            print("no more badge")
        }
    }
}
