//
//  CategoryButton.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/28.
//

import UIKit
import SnapKit
import Then
import Hashtags

final class RecentlySearch: UIView {
    private let recentlyLabel = UILabel().then {
        $0.font = UIFont(name: Font.nsM.rawValue, size: 16)
    }
    
    private let recentlyTag = HashtagView().then {
        $0.tagBackgroundColor = .clear
        $0.tagTextColor = MainColor.gray03
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("load")
        setupRecentlyText()
    }
    
    private func setupRecentlyText() {
        recentlyTag.delegate = self
        addSubview(recentlyTag)
        addSubview(recentlyLabel)
        
        recentlyLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(24)
            make.leading.equalTo(snp.leading).offset(16)
        }
        
        recentlyTag.snp.makeConstraints { make in
            make.top.equalTo(recentlyLabel.snp.bottom).offset(8)
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.bottom.equalTo(snp.bottom)
        }
        
        let tags = [HashTag(word: "this"),
                    HashTag(word: "is", isRemovable: false),
                    HashTag(word: "another", isRemovable: true),
                    HashTag(word: "example", isRemovable: true)]
        recentlyTag.addTags(tags: tags)
    }
}

extension RecentlySearch: HashtagViewDelegate {
    func hashtagRemoved(hashtag: HashTag) {
        print("removed")
    }
    
    func viewShouldResizeTo(size: CGSize) {
        print("resizing")
    }
}
