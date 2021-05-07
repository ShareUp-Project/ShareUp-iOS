//
//  EditorDetailViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/04.
//

import UIKit

class EditorDetailViewController: UIViewController {

    @IBOutlet weak var editorImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var editorDetailData: EditorPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        bind()
    }
    
    private func bind() {
        if let image = editorDetailData?.image {
            editorImageView.kf.setImage(with: URL(string: "https://shareup-bucket.s3.ap-northeast-2.amazonaws.com/" + image))
        }else {
            editorImageView.isHidden = true
        }
        titleLabel.text = editorDetailData!.title
        contentTextView.text = editorDetailData!.content
    }

}

extension EditorDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        var eimageViewFrame = editorImageView.frame
        titleLabel.alpha = (240 - yPosition) / 200
        eimageViewFrame.origin.y = yPosition
        titleLabel.frame.origin.y = yPosition + 169
        editorImageView.frame = eimageViewFrame
    }
}
