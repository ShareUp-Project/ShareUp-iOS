//
//  EditorTableViewCell.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/27.
//

import UIKit

class EditorTableViewCell: UITableViewCell {

    @IBOutlet weak var editorImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
