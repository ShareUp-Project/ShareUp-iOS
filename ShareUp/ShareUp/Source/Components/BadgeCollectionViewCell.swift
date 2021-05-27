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
            if data == 0 { badgeImageView.image = UIImage(named: "0") }
            else {
                badgeImageView.image = UIImage(named: "first")
            }
            badgeNameLabel.text = "삐약삐약"
        case 2:
            if data == 0 { badgeImageView.image = UIImage(named: "0") }
            else {
                badgeImageView.image = UIImage(named: "paper\(data)")
            }
            badgeNameLabel.text = "종이"
        case 3:
            if data == 0 { badgeImageView.image = UIImage(named: "0") }
            else {
                badgeImageView.image = UIImage(named: "vinyl\(data)")
            }
            badgeNameLabel.text = "비닐"
        case 4:
            if data == 0 { badgeImageView.image = UIImage(named: "0") }
            else {
                badgeImageView.image = UIImage(named: "can\(data)")
            }
            badgeNameLabel.text = "캔"
        case 5:
            if data == 0 { badgeImageView.image = UIImage(named: "0") }
            else {
                badgeImageView.image = UIImage(named: "plastic\(data)")
            }
            badgeNameLabel.text = "플라스틱"
        case 6:
            if data == 0 { badgeImageView.image = UIImage(named: "0") }
            else {
                badgeImageView.image = UIImage(named: "glass\(data)")
            }
            badgeNameLabel.text = "유리"
        case 7:
            if data == 0 { badgeImageView.image = UIImage(named: "0") }
            else {
                badgeImageView.image = UIImage(named: "styrofoam\(data)")
            }
            badgeNameLabel.text = "스티로폼"

        case 8:
            if data == 0 { badgeImageView.image = UIImage(named: "0") }
            else {
                badgeImageView.image = UIImage(named: "clothing\(data)")
            }
            badgeNameLabel.text = "옷"
        default:
            print("no more badge")
        }
    }
}
