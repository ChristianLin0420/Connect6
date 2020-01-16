//
//  ViewController.swift
//  Connect6
//
//  Created by Christian on 2019/5/25.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // Start game interface animation image
    @IBOutlet weak var Playing_btn: UIButton!
    @IBOutlet weak var Trainning_btn: UIButton!
    @IBOutlet weak var Setting_btn: UIButton!
    @IBOutlet weak var Introduction_btn: UIButton!
    @IBOutlet weak var start_animation: UIImageView!
    @IBOutlet weak var set_start_icon: UIImageView!
    @IBOutlet weak var Memory_btn: UIButton!
    
    // start animation images
    private let start_images = ["icon1", "icon2", "icon3", "icon4", "icon5","icon6",
                        "icon7", "icon8", "icon9", "icon10", "icon11","icon12",
                        "icon13", "icon14", "icon15", "icon16", "icon17", "icon18",
                        "icon19", "icon20", "icon21", "icon22", "icon23", "icon24"]
    
    // UserDefaults and Coredata
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let Connect6_UD = UserDefaults.standard
    
    // animation coefficient
    private var animated_dot_count = 0
    
    // Timer
    private var showAnimationTimer = Timer()

    // file info
    private let CortexData = Cortex()
    private let MemoryVC = MemoryViewController()
    
    // UserDefaults to store how many patterns stored in Coredata
    private var CortexUD = UserDefaults.standard
    private var cortex_patterns_array_amount = 0
    private let zero = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    private let cortexArrayCollection = [["cortex_array_all", "cortex_array_one", "cortex_array_two", "cortex_array_three", "cortex_array_four"],
                                 ["ST1_cortex_array_all", "ST1_cortex_array_one", "ST1_cortex_array_two", "ST1_cortex_array_three", "ST1_cortex_array_four"],
                                 ["ST2_cortex_array_all", "ST2_cortex_array_one", "ST2_cortex_array_two", "ST2_cortex_array_three", "ST2_cortex_array_four"],
                                 ["ST3_cortex_array_all", "ST3_cortex_array_one", "ST3_cortex_array_two", "ST3_cortex_array_three", "ST3_cortex_array_four"],
                                 ["ST4_cortex_array_all", "ST4_cortex_array_one", "ST4_cortex_array_two", "ST4_cortex_array_three", "ST4_cortex_array_four"],
                                 ["ST5_cortex_array_all", "ST5_cortex_array_one", "ST5_cortex_array_two", "ST5_cortex_array_three", "ST5_cortex_array_four"],
                                 ["ST6_cortex_array_all", "ST6_cortex_array_one", "ST6_cortex_array_two", "ST6_cortex_array_three", "ST6_cortex_array_four"],
                                 ["ST7_cortex_array_all", "ST7_cortex_array_one", "ST7_cortex_array_two", "ST7_cortex_array_three", "ST7_cortex_array_four"],
                                 ["ST8_cortex_array_all", "ST8_cortex_array_one", "ST8_cortex_array_two", "ST8_cortex_array_three", "ST8_cortex_array_four"] ]
    private let EntityCollection = ["Master", "Student_1", "Student_2", "Student_3", "Student_4", "Student_5", "Student_6", "Student_7", "Student_8"]
    private let cortex_amountCollection = ["cortex_amount", "ST1cortex_amount", "ST2cortex_amount", "ST3cortex_amount", "ST4cortex_amount", "ST5cortex_amount", "ST6cortex_amount", "ST7cortex_amount", "ST8cortex_amount"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("It's just a TEST!!!")
        
        combinationArrayCreation()
        
        //random_array = animation_collection.shuffled()
        showAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { (timer) in self.showStartView()}
        
        for index in 0...8 {
            let NameUD = ["Master_name", "Player1_name", "Player2_name", "Player3_name", "Player4_name", "Player5_name", "Player6_name", "Player7_name", "Player8_name"]
            let Name = ["Christian", "Julia", "Ivy", "Tzuyu", "David", "Jarvis", "Yoona", "Friday", "Curry"]
            
            CortexUD.set(Name[index], forKey: NameUD[index])
            CortexUD.synchronize()
        }
        
        for index in 0...8 {
            let pattern_int = [[[Int]]]()
            let pattern_int_1 = [[[Int]]]()
            let pattern_int_2 = [[[Int]]]()
            let pattern_int_3 = [[[Int]]]()
            let pattern_int_4 = [[[Int]]]()

            CortexUD.setValue(pattern_int, forKey: cortexArrayCollection[index][0])
            CortexUD.setValue(pattern_int_1, forKey: cortexArrayCollection[index][1])
            CortexUD.setValue(pattern_int_2, forKey: cortexArrayCollection[index][2])
            CortexUD.setValue(pattern_int_3, forKey: cortexArrayCollection[index][3])
            CortexUD.setValue(pattern_int_4, forKey: cortexArrayCollection[index][4])
            CortexUD.synchronize()

            //get the current state of replay_or_replace
            if let buffer = CortexUD.object(forKey: cortex_amountCollection[index]) {
                cortex_patterns_array_amount = buffer as! Int
            } else {
                cortex_patterns_array_amount = 0
            }

            if cortex_patterns_array_amount == 0 {
                for rule in CortexData.ruleCortex {
                    print("enter ruleCortex implementation")
                    CortexData.instantSaveToCoreData(save_array: rule, person: index)
                }
            }
        }
        
        // Preload memory from core data
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            self.ReloadOldData()
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.ReadMemory()
        }
        
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
    
    @objc private func versus_tap(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            self.start_animation.isHidden = true
            self.set_start_icon.isHidden = false
            Playing_btn.setImage(UIImage(named: "versus_select"), for: .normal)
        } else if gesture.state == .ended {
            performSegue(withIdentifier: "versus_identity", sender: self)
        }
    }
    
    @objc private func trainning_tap(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            self.start_animation.isHidden = true
            self.set_start_icon.isHidden = false
            Trainning_btn.setImage(UIImage(named: "trainning_select"), for: .normal)
        } else if gesture.state == .ended {
            performSegue(withIdentifier: "trainning_identity", sender: self)
        }
    }
    
    @objc private func memory_tap(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            self.start_animation.isHidden = true
            self.set_start_icon.isHidden = false
            Memory_btn.setImage(UIImage(named: "memory_select"), for: .normal)
        } else if gesture.state == .ended {
            performSegue(withIdentifier: "memory_identity", sender: self)
        }
    }
    
    @objc private func setting_tap(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            self.start_animation.isHidden = true
            self.set_start_icon.isHidden = false
            Setting_btn.setImage(UIImage(named: "setting_select"), for: .normal)
        } else if gesture.state == .ended {
            performSegue(withIdentifier: "setting_identity", sender: self)
        }
    }
    
    @objc private func introduction_tap(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            self.start_animation.isHidden = true
            self.set_start_icon.isHidden = false
            Introduction_btn.setImage(UIImage(named: "information_on"), for: .normal)
        } else if gesture.state == .ended {
            performSegue(withIdentifier: "introduction_identity", sender: self)
        }
    }
    
    private func combinationArrayCreation() {
        var result_combi = [[Int]]()
        
        for i in 1...4 {
            for j in CortexData.combos(array: [0, 1, 2, 3], k: i) {
                switch i {
                case 1:
                    result_combi.append(j)
                case 2:
                    if j[0] != j[1] { result_combi.append(j) }
                case 3:
                    if j[0] != j[1] && j[1] != j[2] { result_combi.append(j) }
                case 4:
                    if j[0] != j[1] && j[1] != j[2] && j[2] != j[3] { result_combi.append(j) }
                default:
                    break
                }
            }
        }
        
        CortexUD.set(result_combi, forKey: "combi")
        CortexUD.synchronize()
    }
    
    private func showStartView() {
        if animated_dot_count == 25 {
            UIView.animate(withDuration: 1.0, animations: {
                self.start_animation.frame = CGRect(x: self.view.frame.width * CGFloat(0.16), y: self.view.frame.height * CGFloat(0.107), width: self.start_animation.frame.width, height: self.start_animation.frame.height)
            }, completion: nil)
            UIView.animate(withDuration: 0.8, delay: 0.6, options: .curveEaseOut, animations: { self.Playing_btn.alpha = 1 }, completion: nil)
            UIView.animate(withDuration: 0.8, delay: 1.0, options: .curveEaseOut, animations: { self.Trainning_btn.alpha = 1 }, completion: nil)
            UIView.animate(withDuration: 0.8, delay: 1.4, options: .curveEaseOut, animations: { self.Introduction_btn.alpha = 1 }, completion: nil)
            UIView.animate(withDuration: 0.8, delay: 1.8, options: .curveEaseOut, animations: { self.Setting_btn.alpha = 1 }, completion: nil)
            showAnimationTimer.invalidate()
        }
        if animated_dot_count < 24 { start_animation.image = UIImage(named: start_images[animated_dot_count]) }
        animated_dot_count += 1
    }
    
    private func ReloadOldData() {
        
        print("entering ReloadOldData!!!!!!!")
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntityCollection[0])
        let fetchRequest_1 = NSFetchRequest<NSManagedObject>(entityName: EntityCollection[1])
        let fetchRequest_2 = NSFetchRequest<NSManagedObject>(entityName: EntityCollection[2])
        let fetchRequest_3 = NSFetchRequest<NSManagedObject>(entityName: EntityCollection[3])
        let fetchRequest_4 = NSFetchRequest<NSManagedObject>(entityName: EntityCollection[4])
        let fetchRequest_5 = NSFetchRequest<NSManagedObject>(entityName: EntityCollection[5])
        let fetchRequest_6 = NSFetchRequest<NSManagedObject>(entityName: EntityCollection[6])
        let fetchRequest_7 = NSFetchRequest<NSManagedObject>(entityName: EntityCollection[7])
        let fetchRequest_8 = NSFetchRequest<NSManagedObject>(entityName: EntityCollection[8])
        
        do {
            MemoryVC.pattern_arrays = try managedContext.fetch(fetchRequest)  /// Something interesting in this part
            MemoryVC.students1_pattern_arrays = try managedContext.fetch(fetchRequest_1)
            MemoryVC.students2_pattern_arrays = try managedContext.fetch(fetchRequest_2)
            MemoryVC.students3_pattern_arrays = try managedContext.fetch(fetchRequest_3)
            MemoryVC.students4_pattern_arrays = try managedContext.fetch(fetchRequest_4)
            MemoryVC.students5_pattern_arrays = try managedContext.fetch(fetchRequest_5)
            MemoryVC.students6_pattern_arrays = try managedContext.fetch(fetchRequest_6)
            MemoryVC.students7_pattern_arrays = try managedContext.fetch(fetchRequest_7)
            MemoryVC.students8_pattern_arrays = try managedContext.fetch(fetchRequest_8)
        } catch {
            print("Reload data failed!!!")
        }
    }
    
    private func ReadMemory() {
        print("entering ReadMemory!!!!!!!")
        
        for index in 0...8 {
            let patternArrayCollection = [MemoryVC.pattern_arrays,
                                          MemoryVC.students1_pattern_arrays,
                                          MemoryVC.students2_pattern_arrays,
                                          MemoryVC.students3_pattern_arrays,
                                          MemoryVC.students4_pattern_arrays,
                                          MemoryVC.students5_pattern_arrays,
                                          MemoryVC.students6_pattern_arrays,
                                          MemoryVC.students7_pattern_arrays,
                                          MemoryVC.students8_pattern_arrays]
            
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityCollection[index])
            
            var pattern_string = [String]()
            var pattern_int = [[[Int]]]()
            var pattern_int_1 = [[[Int]]]()
            var pattern_int_2 = [[[Int]]]()
            var pattern_int_3 = [[[Int]]]()
            var pattern_int_4 = [[[Int]]]()
            var pattern_int_buffer = [Int]()
            
            print("EntityCollection: \(EntityCollection[index]))")
            print(patternArrayCollection[index].count)
            
            if patternArrayCollection[index].count != 0 {
                for index in 0...patternArrayCollection[index].count - 1 {
                    do {
                        let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
                        let patterns = result[index].value(forKey: "cortex_array") as! String
                        
                        if (patterns.count > 0) {
                            var data: String = ""
                            for i in 0...(patterns.count / 40 - 1) {
                                let lowerBound = patterns.index(patterns.startIndex, offsetBy: i * 40)
                                let upperBound = patterns.index(patterns.startIndex, offsetBy: i * 40 + 40)
                                data = String(patterns[lowerBound..<upperBound])
                                pattern_string.append(data)
                            }
                        }
                        
                        for i in 0...pattern_string.count - 1 {
                            var data: String = ""
                            for j in 0...pattern_string[i].count / 8 - 1 {
                                let lowerBound = pattern_string[i].index(pattern_string[i].startIndex, offsetBy: j * 8)
                                let upperBound = pattern_string[i].index(pattern_string[i].startIndex, offsetBy: j * 8 + 8)
                                data = String(pattern_string[i][lowerBound..<upperBound])
                                pattern_int_buffer.append(Int(data)!)
                            }
                        }
                        
                        var final_int_array = [[Int]]()
                        
                        for i in 0...3 {
                            var temp_int_array = Array(repeating: 0, count: 10)
                            var blue_part = pattern_int_buffer[i] / 10000
                            var green_part = pattern_int_buffer[i] % 10000
                            
                            for j in 0...9 {
                                temp_int_array[j] = (blue_part % 2 == 0) ? 0 : 1
                                blue_part = blue_part / 2
                            }
                            
                            for j in 0...9 {
                                if temp_int_array[j] == 0 {
                                    temp_int_array[j] = (green_part % 2 == 0) ? 0 : -1
                                    green_part = green_part / 2
                                }
                            }
                            
                            final_int_array.append(temp_int_array)
                        }
                        
                        final_int_array.append([pattern_int_buffer[4]])
                        
                        var temp_count = -1
                        
                        for array in final_int_array {
                            if array != zero { temp_count += 1 }
                        }
                        
                        //print(temp_count)
                        
                        pattern_int.append(final_int_array)
                        
                        switch temp_count {
                        case 1:
                            pattern_int_1.append(final_int_array)
                        case 2:
                            pattern_int_2.append(final_int_array)
                        case 3:
                            pattern_int_3.append(final_int_array)
                        case 4:
                            pattern_int_4.append(final_int_array)
                        default:
                            break
                        }
                        
                        pattern_string.removeAll()
                        pattern_int_buffer.removeAll()
                    } catch {
                        print(error)
                    }
                }
            }
            
            CortexUD.setValue(pattern_int, forKey: cortexArrayCollection[index][0])
            CortexUD.setValue(pattern_int_1, forKey: cortexArrayCollection[index][1])
            CortexUD.setValue(pattern_int_2, forKey: cortexArrayCollection[index][2])
            CortexUD.setValue(pattern_int_3, forKey: cortexArrayCollection[index][3])
            CortexUD.setValue(pattern_int_4, forKey: cortexArrayCollection[index][4])
            CortexUD.synchronize()
        }
    }
    
    @IBAction func versus_btn(_ sender: UIButton) {
        sender.setImage(UIImage(named: "versus_select"), for: .normal)
        performSegue(withIdentifier: "versus_identity", sender: self)
    }
    
    @IBAction func traninnin_btn(_ sender: UIButton) {
        Trainning_btn.setImage(UIImage(named: "trainning_select"), for: .normal)
        performSegue(withIdentifier: "trainning_identity", sender: self)
    }
    
    @IBAction func memory_btn(_ sender: UIButton) {
        Setting_btn.setImage(UIImage(named: "memory_select"), for: .normal)
        performSegue(withIdentifier: "memory_identity", sender: self)
    }
    
    @IBAction func introduction_btn(_ sender: UIButton) {
        Introduction_btn.setImage(UIImage(named: "setting_select"), for: .normal)
        performSegue(withIdentifier: "setting_identity", sender: self)
    }
}

