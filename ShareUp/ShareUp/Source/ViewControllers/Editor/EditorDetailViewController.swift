//
//  EditorDetailViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/04.
//

import UIKit

final class EditorDetailViewController: UIViewController {

    @IBOutlet weak var editorImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var editorDetailData: EditorPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 180, right: 15)

        scrollView.delegate = self
        
        bind()
        
        navigationBackCustom()
        title = "에디터"
    }

    private func bind() {
        if let image = editorDetailData?.image {
            addGradientMask(targetView: editorImageView, 0.5)
            editorImageView.kf.setImage(with: URL(string: "https://shareup-bucket.s3.ap-northeast-2.amazonaws.com/" + image))
        } else {
            addGradientMask(targetView: editorImageView, 0.1)
            editorImageView.backgroundColor = MainColor.defaultGreen
        }
        titleLabel.text = editorDetailData!.title
        contentTextView.text = editorDetailData!.content
    }

    func addGradientMask(targetView: UIView, _ alpha: Double){
        let gradientMask = CAGradientLayer()

        gradientMask.frame = targetView.bounds
        gradientMask.colors = [UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0 / 255.0, alpha: 0.0).cgColor, UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0 / 255.0, alpha: CGFloat(alpha)).cgColor]
        
        gradientMask.locations = [0.0, 1.0]
        targetView.layer.insertSublayer(gradientMask, at: 0)
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
