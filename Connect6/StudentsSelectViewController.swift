//
//  StudentsSelectViewController.swift
//  Connect6
//
//  Created by Christian on 2019/7/26.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

class StudentsSelectViewController: UIViewController {
    
    @IBOutlet weak var P1_full_ability: UIView!
    @IBOutlet weak var P1_current_ability: UIView!
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
    
    private let studentsInfoVC = StudentsInformationViewController()
    
    // UserDefaults
    private let CortexUD = UserDefaults.standard
    
    // Plaer select coefficient
    private var selectNumb = "P1"
    private var P1_image_numb = 0
    private var P2_image_numb = 0
    
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
        
        let P1_tap = UILongPressGestureRecognizer(target: self, action: #selector(selectPlayer1))
        P1_tap.minimumPressDuration = 0
        P1_icon.addGestureRecognizer(P1_tap)
        P1_icon.isUserInteractionEnabled = true
        
        let P2_tap = UILongPressGestureRecognizer(target: self, action: #selector(selectPlayer2))
        P2_tap.minimumPressDuration = 0
        P2_icon.addGestureRecognizer(P2_tap)
        P2_icon.isUserInteractionEnabled = true
        
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
    
    private func player_alpha(p1_alpha: CGFloat, p2_alpha: CGFloat) {
        P1_icon.alpha = p1_alpha
        P1_full_ability.alpha = p1_alpha
        P1_current_ability.alpha = p1_alpha
        P1_name.alpha = p1_alpha
        P2_icon.alpha = p2_alpha
        P2_full_ability.alpha = p2_alpha
        P2_current_ability.alpha = p2_alpha
        P2_name.alpha = p2_alpha
        selectNumb = (p1_alpha > p2_alpha) ? "P1" : "P2"
    }
    
    @objc private func selectPlayer1(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            player_alpha(p1_alpha: 1.0, p2_alpha: 0.3)
        }
    }
    
    @objc private func selectPlayer2(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            player_alpha(p1_alpha: 0.3, p2_alpha: 1.0)
        }
    }
    
    private func showPlayer(numb: Int) {
        if selectNumb == "P1" {
            if numb == -1 {
                P1_icon.image = User.image
                P1_name.text = User_name.text
            } else {
                P1_icon.image = Students[numb].image
                P1_name.text = Students_name[numb].text
            }
            P1_image_numb = numb
        } else {
            if numb == -1 {
                P2_icon.image = User.image
                P2_name.text = User_name.text
            } else {
                P2_icon.image = Students[numb].image
                P2_name.text = Students_name[numb].text
            }
            P2_image_numb = numb
        }
    }
    
    @objc private func Master(gesture: UITapGestureRecognizer) {
        showPlayer(numb: -1)
    }
    
    @objc private func Player1(gesture: UITapGestureRecognizer) {
        showPlayer(numb: 0)
    }
    
    @objc private func Player2(gesture: UITapGestureRecognizer) {
        showPlayer(numb: 1)
    }
    
    @objc private func Player3(gesture: UITapGestureRecognizer) {
        showPlayer(numb: 2)
    }
    
    @objc private func Player4(gesture: UITapGestureRecognizer) {
        showPlayer(numb: 3)
    }
    
    @objc private func Player5(gesture: UITapGestureRecognizer) {
        showPlayer(numb: 4)
    }
    
    @objc private func Player6(gesture: UITapGestureRecognizer) {
        showPlayer(numb: 5)
    }
    
    @objc private func Player7(gesture: UITapGestureRecognizer) {
        showPlayer(numb: 6)
    }
    
    @objc private func Player8(gesture: UITapGestureRecognizer) {
        showPlayer(numb: 7)
    }

    @objc private func startDetect(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            Start_btn.setImage(UIImage(named: "versus_start_on"), for: .normal)
        } else if gesture.state == .ended {
            performSegue(withIdentifier: "start_versus", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "start_versus" {
            let vc = segue.destination as! GameViewController
            if P1_image_numb != -1 { vc.P1_icon_img = Students[P1_image_numb].image }
            else { vc.P1_icon_img = UIImage(named: "User") }
            if P2_image_numb != -1 { vc.P2_icon_img = Students[P2_image_numb].image }
            else { vc.P2_icon_img = UIImage(named: "User") }
            vc.P1_name = P1_name.text
            vc.P2_name = P2_name.text
            vc.current_user = P2_image_numb + 1
            vc.current_opponent = P1_image_numb + 1
        }
    }
}
