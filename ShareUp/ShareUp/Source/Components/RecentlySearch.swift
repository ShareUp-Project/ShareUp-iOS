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
    let recentlyLabel = UILabel().then {
        $0.font = UIFont(name: Font.nsM.rawValue, size: 16)
    }
    
    let recentlyTag = HashtagView().then {
        $0.tagBackgroundColor = .clear
        $0.tagTextColor = MainColor.gray04
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(recentlyTag)
        addSubview(recentlyLabel)
        
        recentlyTag.delegate = self

        setupRecentlyText()
    }
    
    private func setupRecentlyText() {
        recentlyLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        recentlyTag.snp.makeConstraints { make in
            make.top.equalTo(recentlyLabel.snp.top).offset(8)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        let tags = [HashTag(word: "this", isRemovable: true),
                    HashTag(word: "is", isRemovable: true),
                    HashTag(word: "another", isRemovable: true),
                    HashTag(word: "example", isRemovable: true)]
        recentlyTag.addTags(tags: tags)
    }
}

extension RecentlySearch: HashtagViewDelegate {
    func hashtagRemoved(hashtag: HashTag) {
        UserDefaults.standard.removeObject(forKey: hashtag.text)
    }
    
    func viewShouldResizeTo(size: CGSize) {
        print("resizing")
    }
}
