//
//  String.swift
//  ShareUp
//
//  Created by 이가영 on 2021/06/01.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func getHashtags() -> [String] {
        var words = components(separatedBy: "#")
        var hashTags = [String]()
        let shouldRemoveFirstWord = !words[0].hasPrefix("#")
        if shouldRemoveFirstWord {
            words.removeFirst()
        }
        
        for word in words{
            let trimmedWord = word.trim()
            let firstWord = word.components(separatedBy: [" ", "\n"])
            let hashtag = firstWord[0]
            hashTags.append(String(hashtag))
        }
        return hashTags
    }
}
