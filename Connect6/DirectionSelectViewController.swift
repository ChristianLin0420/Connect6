//
//  DirectionSelectViewController.swift
//  Connect6
//
//  Created by Christian on 2019/7/2.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

class DirectionSelectViewController: UIViewController {
    
    // UserDefaults
    let CoretexUD = UserDefaults.standard
    
    var currentData = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let buffer = CoretexUD.object(forKey: "currentStudent") {
            currentData = buffer as! Int
        } else {
            currentData = 0
        }
        

        print("currentData = \(currentData)")
    }
    
    @IBAction func OneDirection(_ sender: Any) {
        CoretexUD.set(1, forKey: "HowMany")
        CoretexUD.synchronize()
        performSegue(withIdentifier: "ShowDirectionStrategy", sender: self)
    }
    
    @IBAction func TwoDirection(_ sender: Any) {
        CoretexUD.set(2, forKey: "HowMany")
        CoretexUD.synchronize()
        performSegue(withIdentifier: "ShowDirectionStrategy", sender: self)
    }
    
    @IBAction func ThreeDirection(_ sender: Any) {
        CoretexUD.set(3, forKey: "HowMany")
        CoretexUD.synchronize()
        performSegue(withIdentifier: "ShowDirectionStrategy", sender: self)
    }
    
    @IBAction func FourDirection(_ sender: Any) {
        CoretexUD.set(4, forKey: "HowMany")
        CoretexUD.synchronize()
        performSegue(withIdentifier: "ShowDirectionStrategy", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDirectionStrategy" {
            let vc = segue.destination as! MemoryViewController
            vc.students_numb = currentData
        }
    }
}
