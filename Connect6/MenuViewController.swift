//
//  MenuViewController.swift
//  Connect6
//
//  Created by Christian on 2019/7/17.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var Playing_btn: UIButton!
    @IBOutlet weak var Trainning_btn: UIButton!
    @IBOutlet weak var Setting_btn: UIButton!
    @IBOutlet weak var Introduction_btn: UIButton!
    @IBOutlet weak var Memory_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add tap detector on CheckerBoard
        let tap_action = UILongPressGestureRecognizer(target: self, action: #selector(versus_tap))
        tap_action.minimumPressDuration = 0
        Playing_btn.addGestureRecognizer(tap_action)
        Playing_btn.isUserInteractionEnabled = true
        
        let tap_action_1 = UILongPressGestureRecognizer(target: self, action: #selector(trainning_tap))
        tap_action_1.minimumPressDuration = 0
        Trainning_btn.addGestureRecognizer(tap_action_1)
        Trainning_btn.isUserInteractionEnabled = true
        
        let tap_action_2 = UILongPressGestureRecognizer(target: self, action: #selector(setting_tap))
        tap_action_2.minimumPressDuration = 0
        Setting_btn.addGestureRecognizer(tap_action_2)
        Setting_btn.isUserInteractionEnabled = true
        
        let tap_action_3 = UILongPressGestureRecognizer(target: self, action: #selector(introduction_tap))
        tap_action_3.minimumPressDuration = 0
        Introduction_btn.addGestureRecognizer(tap_action_3)
        Introduction_btn.isUserInteractionEnabled = true
        
        let tap_action_4 = UILongPressGestureRecognizer(target: self, action: #selector(memory_tap))
        tap_action_4.minimumPressDuration = 0
        Memory_btn.addGestureRecognizer(tap_action_4)
        Memory_btn.isUserInteractionEnabled = true
    }
    
    @objc func versus_tap(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            Playing_btn.setImage(UIImage(named: "versus_select"), for: .normal)
        } else if gesture.state == .ended {
            performSegue(withIdentifier: "versus_identity", sender: self)
        }
    }
    
    @objc func trainning_tap(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            Trainning_btn.setImage(UIImage(named: "trainning_select"), for: .normal)
        } else if gesture.state == .ended {
            performSegue(withIdentifier: "trainning_identity", sender: self)
        }
    }
    
    @objc func memory_tap(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            Memory_btn.setImage(UIImage(named: "memory_select"), for: .normal)
        } else if gesture.state == .ended {
            performSegue(withIdentifier: "memory_identity", sender: self)
        }
    }
    
    @objc func setting_tap(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            Setting_btn.setImage(UIImage(named: "setting_select"), for: .normal)
        } else if gesture.state == .ended {
            performSegue(withIdentifier: "setting_identity", sender: self)
        }
    }
    
    @objc func introduction_tap(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            Introduction_btn.setImage(UIImage(named: "information_on"), for: .normal)
        } else if gesture.state == .ended {
            performSegue(withIdentifier: "introduction_identity", sender: self)
        }
    }
}
