//
//  StudentsSelectDataViewController.swift
//  Connect6
//
//  Created by Christian on 2019/7/30.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

class StudentsSelectDataViewController: UIViewController {

    @IBOutlet weak var User: UIImageView!
    @IBOutlet weak var User_name: UILabel!
    @IBOutlet var Students: [UIImageView]!
    @IBOutlet var Students_name: [UILabel]!
    
    // UserDefaults
    let CoretexUD = UserDefaults.standard
    var currentStudent = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
    
    @objc func Master(gesture: UITapGestureRecognizer) {
        currentStudent = 0
        performSegue(withIdentifier: "getData", sender: self)
    }
    
    @objc func Player1(gesture: UITapGestureRecognizer) {
        currentStudent = 1
        performSegue(withIdentifier: "getData", sender: self)
    }
    
    @objc func Player2(gesture: UITapGestureRecognizer) {
        currentStudent = 2
        performSegue(withIdentifier: "getData", sender: self)
    }
    
    @objc func Player3(gesture: UITapGestureRecognizer) {
        currentStudent = 3
        performSegue(withIdentifier: "getData", sender: self)
    }
    
    @objc func Player4(gesture: UITapGestureRecognizer) {
        currentStudent = 4
        performSegue(withIdentifier: "getData", sender: self)
    }
    
    @objc func Player5(gesture: UITapGestureRecognizer) {
        currentStudent = 5
        performSegue(withIdentifier: "getData", sender: self)
    }
    
    @objc func Player6(gesture: UITapGestureRecognizer) {
        currentStudent = 6
        performSegue(withIdentifier: "getData", sender: self)
    }
    
    @objc func Player7(gesture: UITapGestureRecognizer) {
        currentStudent = 7
        performSegue(withIdentifier: "getData", sender: self)
    }
    
    @objc func Player8(gesture: UITapGestureRecognizer) {
        currentStudent = 8
        performSegue(withIdentifier: "getData", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getData" {
            CoretexUD.set(currentStudent, forKey: "currentStudent")
            CoretexUD.synchronize()
        }
    }
}
