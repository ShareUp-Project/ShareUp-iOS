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
        
        var tags = [HashTag]()
        
        for i in UserDefaults.standard.stringArray(forKey: "recentSearches") ?? [String]() {
            tags.append(HashTag(word: i, isRemovable: true))
        }
        
        recentlyTag.addTags(tags: tags)
    }
}

extension RecentlySearch: HashtagViewDelegate, UICollectionViewDelegate {
    func hashtagRemoved(hashtag: HashTag) {
        var removedSearches = UserDefaults.standard.array(forKey: "recentSearches") as! [String]
        hashtag.text.removeFirst()
        removedSearches.remove(at: removedSearches.firstIndex(of: hashtag.text) ?? 0)
        UserDefaults.standard.set(removedSearches, forKey: "recentSearches")
        UserDefaults.standard.synchronize()
    }
    
    func viewShouldResizeTo(size: CGSize) {
        print("resizing")
    }
    
}
