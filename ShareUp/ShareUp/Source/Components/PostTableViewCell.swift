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
import RxSwift
import RxCocoa

final class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileTouchArea: UIButton!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var nicknameButton: UIButton!
    @IBOutlet weak var scrapButton: UIButton!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hashtagLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var scrapsLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var scrapLabel: UILabel!
    
    private let animationView = AnimationView(name: "bookmark-animation").then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    let animationPost = PublishRelay<Void>()
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(animationView)
        
        animationView.snp.makeConstraints { (make) in
            make.center.equalTo(shareImageView)
            make.width.equalTo(240)
            make.height.equalTo(128)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        shareImageView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(_ data: Post) {
        badgeImageView.image = UIImage(named: data.user.badgeCategory + "\(data.user.badgeLevel)")
        nicknameButton.setTitle(data.user.nickname, for: .normal)
        scrapButton.isSelected = data.isScrap
        shareImageView.kf.setImage(with: URL(string: "https://shareup-bucket.s3.ap-northeast-2.amazonaws.com/" + data.images[0]))
        titleLabel.text = data.title
        hashtagLabel.text = ""
        for i in 0..<data.hashtags.count { hashtagLabel.text! += "#\(data.hashtags[i]) " }
        viewsLabel.text = String(data.views)
        scrapsLabel.text = String(data.scraps)
    }
    
    func scrapConfigCell(_ data: ScrapPost) {
        badgeImageView.image = UIImage(named: data.user.badgeCategory + "\(data.user.badgeLevel)")
        nicknameButton.setTitle(data.user.nickname, for: .normal)
        scrapButton.isSelected = true
        shareImageView.kf.setImage(with: URL(string: "https://shareup-bucket.s3.ap-northeast-2.amazonaws.com/" + data.images[0])!)
        titleLabel.text = data.title
        hashtagLabel.text = ""
        for i in 0..<data.hashtags.count { hashtagLabel.text! += "#\(data.hashtags[i]) " }
        viewsLabel.text = String(data.views)
        scrapsLabel.text = String(data.scraps)
    }
    
    func doubleTapped() {
        animationPost.accept(())
        animationView.isHidden = false
        animationView.play()
        animationView.play { _ in self.animationView.isHidden = true }
    }
}

