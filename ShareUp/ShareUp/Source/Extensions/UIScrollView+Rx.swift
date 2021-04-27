//
//  UIScrollView+Rx.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/27.
//

import UIKit
import RxSwift

extension UIScrollView {
    var reachedBottom: Observable<Void> {
        return rx.contentOffset
            .flatMap { [weak self] contentOffset -> Observable<Void> in
                guard let scrollView = self else {
                    return Observable.empty()
                }
                
                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
                
                return y > threshold ? Observable.just(()) : Observable.empty()
            }
    }
}
