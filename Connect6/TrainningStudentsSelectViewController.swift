//
//  TrainningStudentsSelectViewController.swift
//  Connect6
//
//  Created by Christian on 2019/7/28.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

class TrainningStudentsSelectViewController: UIViewController {

    let studentsInfoVC = StudentsInformationViewController()
    
    @IBOutlet weak var P1_full_ability: UIView!
    @IBOutlet weak var P1_current_ability: UILabel!
    @IBOutlet weak var P1_icon: UIImageView!
    @IBOutlet weak var P1_name: UILabel!
    
    @IBOutlet weak var P2_full_ability: UIView!
    @IBOutlet weak var P2_current_ability: UILabel!
    @IBOutlet weak var P2_icon: UIImageView!
    @IBOutlet weak var P2_name: UILabel!
    
    @IBOutlet weak var User: UIImageView!
    @IBOutlet weak var User_name: UILabel!
    @IBOutlet var Students: [UIImageView]!
    @IBOutlet var Students_name: [UILabel]!
    
    @IBOutlet weak var Start_btn: UIButton!
    
    // UserDefaults
    let CortexUD = UserDefaults.standard
    
    // Plaer select coefficient
    var selectNumb = "P2"
    var P1_image_numb = 0
    var P2_image_numb = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bufferMasterName = CortexUD.object(forKey: "Master_name") {
            User_name.text = bufferMasterName as? String
        } else {
            User_name.text = "Default"
        }
        
        for i in 0...7 {
            if let bufferNmae = CortexUD.object(forKey: studentsInfoVC.PlayerNameUD[i]) {
                Students_name[i].text = bufferNmae as? String
            } else {
                Students_name[i].text = "XXXX"
            }
        }
        
        let master_tap = UILongPressGestureRecognizer(target: self, action: #selector(Master))
        master_tap.minimumPressDuration = 0
        User.addGestureRecognizer(master_tap)
        User.isUserInteractionEnabled = true
        
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
        
        let start_tap = UILongPressGestureRecognizer(target: self, action: #selector(startDetect))
        start_tap.minimumPressDuration = 0
        Start_btn.addGestureRecognizer(start_tap)
        Start_btn.isUserInteractionEnabled = true
        
        P1_current_ability.frame = CGRect(
            x: self.P1_full_ability.frame.minX,
            y: self.P1_full_ability.frame.minY,
            width: self.P1_full_ability.frame.width * 0.25,
            height: self.P1_full_ability.frame.height)
        
        P2_current_ability.frame = CGRect(
            x: self.P2_full_ability.frame.minX,
            y: self.P2_full_ability.frame.minY,
            width: self.P2_full_ability.frame.width * 0.36,
            height: self.P2_full_ability.frame.height)
        
        self.view.addSubview(P1_current_ability)
        self.view.addSubview(P2_current_ability)
    }
    
    func showStudent(numb: Int) {
        if numb == -1 {
            P2_icon.image = User.image
            P2_name.text = User_name.text
            P2_image_numb = -1
        } else {
            P2_icon.image = Students[numb].image
            P2_name.text = Students_name[numb].text
            P2_image_numb = numb
        }
    }
    
    @objc func Master(gesture: UITapGestureRecognizer) {
        showStudent(numb: -1)
    }
    
    @objc func Player1(gesture: UITapGestureRecognizer) {
        showStudent(numb: 0)
    }
    
    @objc func Player2(gesture: UITapGestureRecognizer) {
        showStudent(numb: 1)
    }
    
    @objc func Player3(gesture: UITapGestureRecognizer) {
        showStudent(numb: 2)
    }
    
    @objc func Player4(gesture: UITapGestureRecognizer) {
        showStudent(numb: 3)
    }
    
    @objc func Player5(gesture: UITapGestureRecognizer) {
        showStudent(numb: 4)
    }
    
    @objc func Player6(gesture: UITapGestureRecognizer) {
        showStudent(numb: 5)
    }
    
    @objc func Player7(gesture: UITapGestureRecognizer) {
        showStudent(numb: 6)
    }
    
    @objc func Player8(gesture: UITapGestureRecognizer) {
        showStudent(numb: 7)
    }
    
    @objc func startDetect(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            Start_btn.setImage(UIImage(named: "versus_start_on"), for: .normal)
        } else if gesture.state == .ended {
            performSegue(withIdentifier: "start_trainning", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "start_trainning" {
            let vc = segue.destination as! TrainningViewController
            vc.P1_icon_img = UIImage(named: "User")
            if P2_image_numb != -1 { vc.P2_icon_img = Students[P2_image_numb].image }
            else { vc.P2_icon_img = UIImage(named: "User") }
            vc.P1_name = P1_name.text
            vc.P2_name = P2_name.text
            vc.current_teacher = 0
            vc.current_student = P2_image_numb + 1
        }
    }
}
