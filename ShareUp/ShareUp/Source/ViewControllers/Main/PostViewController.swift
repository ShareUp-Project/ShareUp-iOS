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
import SPAlert

final class PostViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraTouchArea: UIButton!
    @IBOutlet weak var cameraBoxView: UIView!
    @IBOutlet weak var numOfPictureLabel: UILabel!
    @IBOutlet weak var pickerCollectionView: UICollectionView!
    @IBOutlet var categoryButton: [UIButton]!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    //MARK: Properties
    private var categoryTraking = BehaviorRelay<String>(value: "")
    private let viewModel = PostViewModel()
    private let disposeBag = DisposeBag()
    private let multipleImages = PublishRelay<[Data]>()
    private var selectMultiImage = [PHAsset]() {
        willSet {
            if selectMultiImage.count != 0 { numOfPictureLabel.textColor = MainColor.primaryGreen }
        }
    }
    
    lazy var postButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
        button.tintColor = MainColor.primaryGreen
        button.isEnabled = false
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.delegate = self
        
        managerTrait()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = "글쓰기"
        tabBarController?.navigationItem.rightBarButtonItem = postButton
        tabBarController?.navigationItem.leftBarButtonItems = []
    }
    
    //MARK: Bind
    private func bindViewModel() {
        let input = PostViewModel.Input(postTap: postButton.rx.tap.asDriver(),
                                        isImage: multipleImages.asDriver(onErrorJustReturn: []),
                                        isTitle: titleTextView.rx.text.orEmpty.asDriver(),
                                        isContent: contentTextView.rx.text.orEmpty.asDriver(),
                                        isCategory: categoryTraking.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input)
        
        output.result.asObservable().subscribe(onNext: {[unowned self] data in
            if let response = data?.category {
                print("badge")
                view.endEditing(true)
                let badge = response == "first" ? response : response + String((data!.level)!)
                let alertView = SPAlertView(title: "배지 획득", message: "\(String(describing: Category(rawValue: badge)!.toDescription()[0])) 배지를 획득했습니다.", preset: .done)
                alertView.present(duration: 2.0, haptic: .success) {
                    pushViewController("main")
                }
            } else {
                pushViewController("main")
            }
        }).disposed(by: disposeBag)
        
        output.stopIndicator.emit(onNext: { message in
            self.loadingView.stopAnimating()
            self.postButton.isEnabled = true
        }).disposed(by: disposeBag)
        
        output.isEnable.drive(postButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func keyboardHeight() -> Observable<CGFloat> {
        return Observable
                .from([
                    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                                .map { notification -> CGFloat in
                                    (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                                },
                    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                                .map { _ -> CGFloat in
                                    0
                                }
                ])
                .merge()
    }
    
    //MARK: Rx Action
    private func managerTrait() {
        cameraTouchArea.rx.tap.subscribe(onNext: {[unowned self] _ in
            let imagePicker = ImagePickerController()
            imagePicker.settings.selection.max = 8
            imagePicker.settings.theme.selectionStyle = .numbered
            imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
            imagePicker.settings.selection.unselectOnReachingMax = true
            selectMultiImage.removeAll()
            presentImagePicker(imagePicker, select: { (asset) in
            }, deselect: { (asset) in
            }, cancel: { (assets) in
            }, finish: { (assets) in
                for i in 0..<assets.count {
                    self.selectMultiImage.append(assets[i])
                }
                pickerCollectionView.reloadData()
                multipleImages.accept(getData(selectMultiImage))
                numOfPictureLabel.text = String(selectMultiImage.count)
            }, completion: {
                pickerCollectionView.reloadData()
            })
        }).disposed(by: disposeBag)
        
        cameraBoxView.layer.borderColor = MainColor.gray03.cgColor
        
        postButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            loadingView.isHidden = false
            postButton.isEnabled = false
            loadingView.startAnimating()
        }).disposed(by: disposeBag)
        
        keyboardHeight().observeOn(MainScheduler.instance)
            .subscribe(onNext: { keyboardHeight in
                if keyboardHeight > 0 {
                    self.contentTextView.isScrollEnabled = true
                } else {
                    self.contentTextView.isScrollEnabled = false
                }
            }).disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let viewController : CategoryViewController = segue.destination as! CategoryViewController
            viewController.delegate = self
        }
    }
}

//MARK: Extension
extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectMultiImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickerCell", for: indexPath) as! PickerCollectionViewCell
        
        cell.pickerImageView.image = selectMultiImage[indexPath.row].getUIImage()
        cell.removeButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            selectMultiImage.remove(at: indexPath.row)
            pickerCollectionView.reloadData()
            numOfPictureLabel.text = String(selectMultiImage.count)
        }).disposed(by: cell.disposeBag)
        
        return cell
    }
}

extension PostViewController: DismissSendData {
    func dismissData(_ data: String) {
        categoryButton[0].setTitle(" " + data, for: .normal)
        categoryTraking.accept(data)
    }
}

extension PostViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if textView == contentTextView {
            return changedText.count <= 500
        }else if textView == titleTextView {
            return changedText.count <= 50
        }
        
        return false
    }
}
