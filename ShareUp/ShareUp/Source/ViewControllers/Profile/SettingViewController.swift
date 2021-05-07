//
//  SettingViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/07.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!
    
    var settings = ["닉네임 수정", "배지", "비밀번호 변경", "정보", "로그아웃"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        settingTableView.separatorInset = .zero
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.selectionStyle = .none
        cell.textLabel?.text = settings[indexPath.row]
        
        if indexPath.row == settings.count-1 {
            cell.textLabel?.textColor = MainColor.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            pushViewController("changeNickname")
        case 1:
            print("badge")
        case 2:
            pushViewController("resetPassword")
        case 3:
            print("info")
        case 4:
            TokenManager.removeToken()
            UserDefaults.standard.removeObject(forKey: "isAuto")
        default:
            print("error")
        }
    }
}
