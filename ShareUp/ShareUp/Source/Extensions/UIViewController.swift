//
//  UIViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/28.
//

import UIKit
import Photos
import RxCocoa

extension UIViewController {
    func checkTimer(_ timer: Int) -> String {
        let seconds: Int = timer % 60
        let minutes: Int = (timer / 60) % 60
        return String(format: "%0d:%02d", minutes, seconds)
    }
    
    func pushViewController(_ identifier: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func presentViewController(_ identifier: String) {
        let vc = storyboard?.instantiateViewController(identifier: identifier)
        present(vc!, animated: true, completion: nil)
    }
    
    func navigationBarColor(_ color: UIColor) {
        let backButton: UIBarButtonItem = UIBarButtonItem()
        backButton.title = "뒤로"
        backButton.tintColor = MainColor.primaryGreen
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = color
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
    }
    
    func navigationBarHidden() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func navigationBackCustom() {
        let backButton = UIBarButtonItem()
        backButton.title = "뒤로"
        backButton.tintColor = MainColor.primaryGreen
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func getData(_ asset: [PHAsset]) -> [Data] {
        var imageData = [Data]()
        for i in asset {
            imageData.append((i.getUIImage()?.jpegData(compressionQuality: 0.2))!)
        }
        return imageData
    }
}

extension PHAsset{
    func getUIImage() -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: self, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func add(element: Element.Element) {
        var array = value
        array.append(element)
        accept(array)
    }
}
