//
//  SettingViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/07.
//

import UIKit

final class SettingViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var settingTableView: UITableView!
    
    //MARK: Properties
    var settings = ["닉네임 수정", "배지", "비밀번호 변경", "정보", "로그아웃"]
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "설정"
        settingTableView.separatorInset = .zero
        navigationBackCustom()
    }
}

//MARK: Extension
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.selectionStyle = .none
        cell.textLabel?.text = settings[indexPath.row]
        cell.textLabel?.font = UIFont(name: Font.nsR.rawValue, size: 18)
        
        if indexPath.row == settings.count-1 {
            cell.textLabel?.textColor = MainColor.red
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            pushViewController("changeNickname")
        case 1:
            pushViewController("badge")
        case 2:
            pushViewController("resetPassword")
        case 3:
            print("info")
        case 4:
            let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) {[unowned self] action in
                TokenManager.removeToken()
                UserDefaults.standard.removeObject(forKey: "isAuto")
                pushViewController("first")
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(ok)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        default:
            print("error")
        }
    }
}
