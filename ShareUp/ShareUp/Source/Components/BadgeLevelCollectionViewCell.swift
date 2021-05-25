//
//  BadgeLevelCollectionViewCell.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/18.
//

import UIKit
import CollectionViewPagingLayout

final class BadgeLevelCollectionViewCell: UICollectionViewCell, ScaleTransformView {
    
    @IBOutlet weak var badgeImageView: UIImageView!

    var scaleOptions = ScaleTransformViewOptions(minScale: 0.4, scaleRatio: 0.4, translationRatio: CGPoint(x: 0.2, y: 0.2), maxTranslationRatio: CGPoint(x: 2, y: 0), keepVerticalSpacingEqual: true, scaleCurve: .linear, translationCurve: .linear, shadowEnabled: true, rotation3d: .none, translation3d: .none)
    
}