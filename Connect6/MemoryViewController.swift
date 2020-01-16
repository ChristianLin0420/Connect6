//
//  MemoryViewController.swift
//  Connect6
//
//  Created by Christian on 2019/5/27.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit
import CoreData

class MemoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Patterns info(pattern array, pattern point, pattern rank)
    var pattern_arrays: [NSManagedObject] = []
    var students1_pattern_arrays: [NSManagedObject] = []
    var students2_pattern_arrays: [NSManagedObject] = []
    var students3_pattern_arrays: [NSManagedObject] = []
    var students4_pattern_arrays: [NSManagedObject] = []
    var students5_pattern_arrays: [NSManagedObject] = []
    var students6_pattern_arrays: [NSManagedObject] = []
    var students7_pattern_arrays: [NSManagedObject] = []
    var students8_pattern_arrays: [NSManagedObject] = []
    
    // UserDefaults
    let CortexUD = UserDefaults.standard
    var students_numb = 0
    var showHowManyDirection = 0
    var ShowArray = [String]()

    let students_name = ["Christian", "Julia", "Ivy", "Tzuyu", "David", "Jarvis", "Yoona", "Friday", "Curry"]
    
    @IBOutlet weak var Strategy: UILabel!
    @IBOutlet weak var CortexTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let buffer = CortexUD.object(forKey: "HowMany") {
            showHowManyDirection = buffer as! Int
        } else {
            showHowManyDirection = 1
        }
        
        print("students_numb = \(students_numb)")
        Strategy.text = "\(students_name[students_numb])'s strategy"
        
        CortexTableView.backgroundColor = UIColor.black
        CortexTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        ShowArray = getDefaultsString(numb: showHowManyDirection - 1)
    }
    
    func getDefaultsString(numb: Int) -> [String] {
        var result = [String]()
        let StringArray = [["UDString_1", "UDString_2", "UDString_3", "UDString_4"],
                           ["Students1UD_1", "Students1UD_2", "Students1UD_3", "Students1UD_4"],
                           ["Students2UD_1", "Students2UD_2", "Students2UD_3", "Students2UD_4"],
                           ["Students3UD_1", "Students3UD_2", "Students3UD_3", "Students3UD_4"],
                           ["Students4UD_1", "Students4UD_2", "Students4UD_3", "Students4UD_4"],
                           ["Students5UD_1", "Students5UD_2", "Students5UD_3", "Students5UD_4"],
                           ["Students6UD_1", "Students6UD_2", "Students6UD_3", "Students6UD_4"],
                           ["Students7UD_1", "Students7UD_2", "Students7UD_3", "Students7UD_4"],
                           ["Students8UD_1", "Students8UD_2", "Students8UD_3", "Students8UD_4"]]
        
        if let buffer = CortexUD.object(forKey: StringArray[students_numb][numb]) {
            result = buffer as! [String]
        } else {
            result = [""]
        }
        
        return result
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("pattern_array = \(ShowArray.count)")
        return ShowArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pattern = ShowArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = pattern
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    // Watch pattern information
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pattern = ShowArray[indexPath.row]

        CortexUD.set(pattern, forKey: "cortex_string")
        CortexUD.synchronize()
        
        performSegue(withIdentifier: "ShowStrategy", sender: self) 
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselect")
    }
}
