//
//  PostTableViewCell.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/05.
//

import UIKit
import Lottie
import SnapKit
import Then

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var nicknameButton: UIButton!
    @IBOutlet weak var scrapButton: UIButton!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hashtagLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var scrapsLabel: UILabel!
    private let animationView = AnimationView(name: "bookmark-animation").then {
        $0.contentMode = .scaleAspectFit
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(animationView)
        
        lottieGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(_ data: Post) {
        badgeImageView.kf.setImage(with: URL(string: "")!)
        nicknameButton.setTitle(data.title, for: .normal)
        scrapButton.isSelected = data.isScrap
        shareImageView.kf.setImage(with: URL(string: "")!)
        titleLabel.text = data.title
        for i in data.hashtags { hashtagLabel.text = i + " " }
        viewsLabel.text = String(data.views)
        scrapsLabel.text = String(data.scraps)
    }
    
    func lottieGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTouchesRequired = 2
        
        shareImageView.addGestureRecognizer(tap)
        
        animationView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(128)
        }
    }
    
    @objc func doubleTapped() {
        animationView.play()
    }
    
}
