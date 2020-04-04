//
//  StudentsInformationViewController.swift
//  Connect6
//
//  Created by Christian on 2019/7/26.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

class StudentsInformationViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var Info_icon: UIImageView!
    @IBOutlet weak var Info_name: UITextField!
    @IBOutlet weak var Info_createDate: UILabel!
    @IBOutlet weak var Info_learnPatternCount: UILabel!
    
    @IBOutlet weak var User_icon: UIImageView!
    @IBOutlet weak var User_name: UILabel!
    @IBOutlet var Students: [UIImageView]!
    @IBOutlet var Students_name: [UILabel]!
    
    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var ConfirmBtn: UIButton!
    @IBOutlet weak var CancelBtn: UIButton!
    
    // UserDefaults
    let CortexUD = UserDefaults.standard
    
    let CortexProcess = Cortex()
    
    let UserNameUD = "Master_name"
    let UserCreateDateUD = "Master_CreateDate"
    let UserAbilityUD = "Master_Ability"
    
    let PlayerNameUD = ["Player1_name", "Player2_name", "Player3_name", "Player4_name", "Player5_name", "Player6_name", "Player7_name", "Player8_name"]
    let PlayerCreateDateUD = ["Player1_CreateDate", "Player2_CreateDate", "Player3_CreateDate", "Player4_CreateDate", "Player5_CreateDate", "Player6_CreateDate", "Player7_CreateDate", "Player8_CreateDate"]
    let PlayerAbilityUD = ["Player1_Ability", "Player2_Ability", "Player3_Ability", "Player4_Ability", "Player5_Abiliyt", "Player6_Ability", "Player7_Ability", "Player8_Ability"]
    
    var MasterCreateDate = "2019 . 7 . 26"
    var MasterAbility = 30
    var Players_CreateDate = Array(repeating: "2019 . 7 . 26", count: 8)
    var Players_Ability = Array(repeating: 30, count: 8)
    
    var currentEditPlayer = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Info_name.delegate = self
        
        let master_tap = UILongPressGestureRecognizer(target: self, action: #selector(Master))
        master_tap.minimumPressDuration = 0
        User_icon.addGestureRecognizer(master_tap)
        User_icon.isUserInteractionEnabled = true
        
        reloadAllUDInfo()
        
        // tap gesture for all students and master
        let opponent_1_tap = UILongPressGestureRecognizer(target: self, action: #selector(Player1))
        let opponent_2_tap = UILongPressGestureRecognizer(target: self, action: #selector(Player2))
        let opponent_3_tap = UILongPressGestureRecognizer(target: self, action: #selector(Player3))
        let opponent_4_tap = UILongPressGestureRecognizer(target: self, action: #selector(Player4))
        let opponent_5_tap = UILongPressGestureRecognizer(target: self, action: #selector(Player5))
        let opponent_6_tap = UILongPressGestureRecognizer(target: self, action: #selector(Player6))
        let opponent_7_tap = UILongPressGestureRecognizer(target: self, action: #selector(Player7))
        let opponent_8_tap = UILongPressGestureRecognizer(target: self, action: #selector(Player8))
        
        let opponent_tap_collection = [opponent_1_tap, opponent_2_tap, opponent_3_tap, opponent_4_tap, opponent_5_tap, opponent_6_tap, opponent_7_tap, opponent_8_tap]
        
        for i in 0...7 {
            opponent_tap_collection[i].minimumPressDuration = 0
            Students[i].addGestureRecognizer(opponent_tap_collection[i])
            Students[i].isUserInteractionEnabled = true
        }
        
        PopUpView.layer.cornerRadius = 15
    }
    
    func reloadAllUDInfo() {
        // Master Info UserDefaults
        if let bufferUserName = CortexUD.object(forKey: "Master_name") {
            User_name.text = bufferUserName as? String
        } else {
            User_name.text = "Default"
        }
        
        if let bufferCreateDate = CortexUD.object(forKey: "Master_CreateDate") {
            MasterCreateDate = bufferCreateDate as! String
        } else {
            MasterCreateDate = "2019 . 7 . 26"
        }
        
        if let bufferAbility = CortexUD.object(forKey: "Master_Ability") {
            MasterAbility = bufferAbility as! Int
        } else {
            MasterAbility = 30
        }
        
        // Students Info UserDefaults
        for i in 0...7 {
            if let bufferName = CortexUD.object(forKey: PlayerNameUD[i]) {
                Students_name[i].text = bufferName as? String
            } else {
                Students_name[i].text = "XXXX"
            }
            
            if let buffercreateDate = CortexUD.object(forKey: PlayerCreateDateUD[i]) {
                Players_CreateDate[i] = buffercreateDate as! String
            } else {
                Players_CreateDate[i] = "2019 . 7 . 26"
            }
            
            if let buffercreateDate = CortexUD.object(forKey: PlayerAbilityUD[i]) {
                Players_Ability[i] = buffercreateDate as! Int
            } else {
                Players_Ability[i] = 30
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if currentEditPlayer == -1 {
            CortexUD.set(Info_name.text, forKey: UserNameUD)
            CortexUD.synchronize()
        } else {
            CortexUD.set(Info_name.text, forKey: PlayerNameUD[currentEditPlayer])
            CortexUD.synchronize()
        }
        reloadAllUDInfo()
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.endEditing(true)
        })
    }
    
    func showInfo(numb: Int) {
        currentEditPlayer = numb
        if numb == -1 {
            Info_icon.image = User_icon.image
            Info_name.text = User_name.text
            Info_createDate.text = MasterCreateDate
        } else {
            Info_icon.image = Students[numb].image
            Info_name.text = Students_name[numb].text
            Info_createDate.text = Players_CreateDate[numb]
        }
    }
    
    @objc func Master(gesture: UITapGestureRecognizer) {
        showInfo(numb: -1)
    }
    
    @objc func Player1(gesture: UITapGestureRecognizer) {
        showInfo(numb: 0)
    }
    
    @objc func Player2(gesture: UITapGestureRecognizer) {
        showInfo(numb: 1)
    }
    
    @objc func Player3(gesture: UITapGestureRecognizer) {
        showInfo(numb: 2)
    }
    
    @objc func Player4(gesture: UITapGestureRecognizer) {
        showInfo(numb: 3)
    }
    
    @objc func Player5(gesture: UITapGestureRecognizer) {
        showInfo(numb: 4)
    }
    
    @objc func Player6(gesture: UITapGestureRecognizer) {
        showInfo(numb: 5)
    }
    
    @objc func Player7(gesture: UITapGestureRecognizer) {
        showInfo(numb: 6)
    }
    
    @objc func Player8(gesture: UITapGestureRecognizer) {
        showInfo(numb: 7)
    }
    
    @IBAction func DeleteMemory(_ sender: UIButton) {
        PopUpView.isHidden = false
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0.0,
            options: [],
            animations: {
                self.PopUpView.alpha = 1.0
            },
            completion: nil)
    }
    
    @IBAction func ConfirmCleanRecord(_ sender: UIButton) {
        print("delete \(currentEditPlayer + 1)")
        CortexProcess.CleanCoreData(index: currentEditPlayer + 1)
        PopUpView.alpha = 0.0
        PopUpView.isHidden = true
    }
    
    @IBAction func CancelCleanReocrd(_ sender: UIButton) {
        PopUpView.alpha = 0.0
        PopUpView.isHidden = true
    }
}
