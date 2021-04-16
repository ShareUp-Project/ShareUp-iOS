//
//  PostViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/13.
//

import UIKit
import BSImagePicker
import RxSwift
import Photos
import RxCocoa

class PostViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraBoxView: UIView!
    @IBOutlet weak var numOfPictureLabel: UILabel!
    @IBOutlet weak var pickerCollectionView: UICollectionView!
    @IBOutlet var categoryButton: [UIButton]!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!

    private var selectAsset = [PHAsset]()
    private var navigationButton = PublishRelay<Void>()
    private let viewModel = PostViewModel()
    private let disposeBag = DisposeBag()
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Add", style: .plain, target: self, action: nil)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = rightButton
        title = "Asdf"
        
        titleTextView.text = "이곳을 눌러 제목을 입력하세요."
        titleTextView.textColor = UIColor.lightGray
        contentTextView.text = "쉐어업에 공유할 업사이클 이야기를 작성해주세요. 태그는 본문에 원하는 #태그를 입력하면 자동으로 태그됩니다."
        contentTextView.textColor = UIColor.lightGray
        
        cameraBoxView.layer.borderColor = MainColor.gray02.cgColor
        managerTrait()
        
    }
    
    private func managerTrait() {
        cameraButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            let imagePicker = ImagePickerController()
            imagePicker.settings.selection.max = 8
            imagePicker.settings.theme.selectionStyle = .numbered
            imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
            imagePicker.settings.selection.unselectOnReachingMax = true
            
            presentImagePicker(imagePicker, select: { (asset) in
            }, deselect: { (asset) in
            }, cancel: { (assets) in
            }, finish: { (assets) in
                for i in 0..<assets.count
                {
                    self.selectAsset.append(assets[i])
                }
                pickerCollectionView.reloadData()
                numOfPictureLabel.text = String(selectAsset.count)
            }, completion: {
                pickerCollectionView.reloadData()
            })
        }).disposed(by: disposeBag)
    }
    
    @objc func postTapped() {
        navigationButton.accept(())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let viewController : CategoryViewController = segue.destination as! CategoryViewController
            viewController.delegate = self
        }
    }

}

extension PostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty && textView == titleTextView{
            textView.text = "이곳을 눌러 제목을 입력하세요."
            textView.textColor = UIColor.lightGray
        }else if textView.text.isEmpty && textView == contentTextView {
            textView.text = "쉐어업에 공유할 업사이클 이야기를 작성해주세요. 태그는 본문에 원하는 #태그를 입력하면 자동으로 태그됩니다."
            textView.textColor = UIColor.lightGray
        }
    }
}

extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectAsset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickerCell", for: indexPath) as! PickerCollectionViewCell
        
        cell.pickerImageView.image = getUIImage(asset: selectAsset[indexPath.row])
        cell.removeButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            selectAsset.remove(at: indexPath.row)
            pickerCollectionView.reloadData()
        }).disposed(by: cell.disposeBag)
        
        return cell
    }
}
