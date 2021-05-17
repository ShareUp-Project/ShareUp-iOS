//
//  EditorTableViewCell.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/27.
//

import UIKit

final class EditorTableViewCell: UITableViewCell {

    @IBOutlet weak var editorImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configCell(_ data: EditorPost) {
        if let image = data.image {
            editorImageView.kf.setImage(with: URL(string: "https://shareup-bucket.s3.ap-northeast-2.amazonaws.com/" + image))
        }else {
            editorImageView.isHidden = true
        }
        mainLabel.text = data.title
        contentLabel.text = data.content
    }
}
