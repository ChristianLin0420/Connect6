//
//  Cortex.swift
//  Connect6
//
//  Created by Christian on 2019/5/28.
//  Copyright © 2019 Christian. All rights reserved.
//

import CoreData
import UIKit
import Foundation

class Cortex {
    let direction_pattern_array = [[-95, -76, -57, -38, -19],
                                   [-90, -72, -54, -36, -18],
                                   [5, 4, 3, 2, 1],
                                   [100, 80, 60, 40, 20],
                                   [95, 76, 57, 38, 19],
                                   [90, 72, 54, 36, 18],
                                   [-5, -4, -3, -2, -1],
                                   [-100, -80, -60, -40, -20]]
    
    let eight_direction_array = [[[-5, 0], [-4, 0], [-3, 0], [-2, 0], [-1, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0]],
                                 [[-5, 5], [-4, 4], [-3, 3], [-2, 2], [-1, 1], [1, -1], [2, -2], [3, -3], [4, -4], [5, -5]],
                                 [[0, 5], [0, 4], [0, 3], [0, 2], [0, 1], [0, -1], [0, -2], [0, -3], [0, -4], [0, -5]],
                                 [[5, 5], [4, 4], [3, 3], [2, 2], [1, 1], [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5]],
                                 [[5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0]],
                                 [[5, -5], [4, -4], [3, -3], [2, -2], [1, -1], [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5]],
                                 [[0, -5], [0, -4], [0, -3], [0, -2], [0, -1], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5]],
                                 [[-5, -5], [-4, -4], [-3, -3], [-2, -2], [-1, -1], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]]]
    
    let ruleCortex = [[310000, 0, 0, 0, 100200],
                        [620000, 0, 0, 0, 100200],
                        [1240000, 0, 0, 0, 100200],
                        [9920000, 0, 0, 0, 100200],
                        [4960000, 0, 0, 0, 100200],
                        [2480000, 0, 0, 0, 100200],
                        [310000, 310000, 0, 0, 100200],
                        [310000, 310000, 310000, 0, 100200],
                        [310000, 310000, 310000, 310000, 100200]]
    
    let StringArray = [["UDString_1", "UDString_2", "UDString_3", "UDString_4"],
                       ["Students1UD_1", "Students1UD_2", "Students1UD_3", "Students1UD_4"],
                       ["Students2UD_1", "Students2UD_2", "Students2UD_3", "Students2UD_4"],
                       ["Students3UD_1", "Students3UD_2", "Students3UD_3", "Students3UD_4"],
                       ["Students4UD_1", "Students4UD_2", "Students4UD_3", "Students4UD_4"],
                       ["Students5UD_1", "Students5UD_2", "Students5UD_3", "Students5UD_4"],
                       ["Students6UD_1", "Students6UD_2", "Students6UD_3", "Students6UD_4"],
                       ["Students7UD_1", "Students7UD_2", "Students7UD_3", "Students7UD_4"],
                       ["Students8UD_1", "Students8UD_2", "Students8UD_3", "Students8UD_4"]]
    
    let cortexArrayCollection = [["cortex_array_all", "cortex_array_one", "cortex_array_two", "cortex_array_three", "cortex_array_four"],
                                 ["ST1_cortex_array_all", "ST1_cortex_array_one", "ST1_cortex_array_two", "ST1_cortex_array_three", "ST1_cortex_array_four"],
                                 ["ST2_cortex_array_all", "ST2_cortex_array_one", "ST2_cortex_array_two", "ST2_cortex_array_three", "ST2_cortex_array_four"],
                                 ["ST3_cortex_array_all", "ST3_cortex_array_one", "ST3_cortex_array_two", "ST3_cortex_array_three", "ST3_cortex_array_four"],
                                 ["ST4_cortex_array_all", "ST4_cortex_array_one", "ST4_cortex_array_two", "ST4_cortex_array_three", "ST4_cortex_array_four"],
                                 ["ST5_cortex_array_all", "ST5_cortex_array_one", "ST5_cortex_array_two", "ST5_cortex_array_three", "ST5_cortex_array_four"],
                                 ["ST6_cortex_array_all", "ST6_cortex_array_one", "ST6_cortex_array_two", "ST6_cortex_array_three", "ST6_cortex_array_four"],
                                 ["ST7_cortex_array_all", "ST7_cortex_array_one", "ST7_cortex_array_two", "ST7_cortex_array_three", "ST7_cortex_array_four"],
                                 ["ST8_cortex_array_all", "ST8_cortex_array_one", "ST8_cortex_array_two", "ST8_cortex_array_three", "ST8_cortex_array_four"] ]
    
    let cortex_amountCollection = ["cortex_amount", "ST1cortex_amount", "ST2cortex_amount", "ST3cortex_amount", "ST4cortex_amount", "ST5cortex_amount", "ST6cortex_amount", "ST7cortex_amount", "ST8cortex_amount"]
    
    let EntityCollection = ["Master", "Student_1", "Student_2", "Student_3", "Student_4", "Student_5", "Student_6", "Student_7", "Student_8"]
    
    let default_max_score = 100000
    let zero = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    // Coredata coefficient
    var CortexUD = UserDefaults.standard
    var combi_array = [[Int]]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let MemoryVC = MemoryViewController()
    
    func convertCurrentToStoreformString(Int_array: [Int]) -> String {
        var result_string = ""
        
        print("result_string before = \(Int_array)")
        
        for i in 0...Int_array.count - 1 {
            var buffer_temp: String = ""
            
            if (Int_array[i] < 10 && Int_array[i] >= 0) { buffer_temp = String(format:"0000000%1d",Int_array[i]) }
            else if (Int_array[i] >= 10 && Int_array[i] < 100) { buffer_temp = String(format:"000000%2d",Int_array[i]) }
            else if (Int_array[i] >= 100 && Int_array[i] < 1000) { buffer_temp = String(format:"00000%3d",Int_array[i]) }
            else if (Int_array[i] >= 1000 && Int_array[i] < 10000) { buffer_temp = String(format:"0000%4d",Int_array[i]) }
            else if (Int_array[i] >= 10000 && Int_array[i] < 100000) { buffer_temp = String(format:"000%5d",Int_array[i]) }
            else if (Int_array[i] >= 100000 && Int_array[i] < 1000000) { buffer_temp = String(format:"00%6d",Int_array[i]) }
            else if (Int_array[i] >= 1000000 && Int_array[i] < 10000000) { buffer_temp = String(format:"0%7d",Int_array[i]) }
            else if (Int_array[i] >= 10000000 && Int_array[i] < 100000000) { buffer_temp = String(format:"%8d",Int_array[i]) }
            
            result_string = result_string + buffer_temp
        }
        
        return result_string
    }
    
    // Create 11 X 11 array
    func createScanArray(currentBoard: [[Int]], center_y: Int, center_x: Int) -> [[Int]] {
        var scanArray = Array(repeating: Array(repeating: 0, count: 11), count: 11)
        for i in 0...10 {
            for j in 0...10 {
                let temp_y = center_y - 5 + i
                let temp_x = center_x - 5 + j
                // player = 1, opponent = -1, else = 0
                if temp_y < 19, temp_y > -1, temp_x < 19, temp_x > -1 { scanArray[i][j] = currentBoard[temp_y][temp_x] }
                else { scanArray[i][j] = -2 }
            }
        }
        
        return scanArray
    }
    
    // Create eight direction array
    func createDirectionArray(currentBoard: [[Int]]) -> [[Int]] {
        var final_direction_array = [[Int]]()
        var temp_direction_array = Array(repeating: 0, count: 10)
        
        for i in 0...7 {
            for j in 0...9 {
                temp_direction_array[j] = currentBoard[eight_direction_array[i][j][0] + 5][eight_direction_array[i][j][1] + 5]
            }
            final_direction_array.append(temp_direction_array)
            temp_direction_array = Array(repeating: 0, count: 10)
        }
        
        return final_direction_array
    }
    
    // four-direction array as input, cortex_array is one of the cortex in the memory
    func recordValid(surrounding_binary_array: [[Int]], valid_cortex_array: [[[Int]]]) -> (Bool, Int, Int) {
        var isValid = false
        var compared_pattern_number = -2
        var score = 0
        var non_zero = 0
        var countTopValue = 0
        
        for array in valid_cortex_array {
            if array[4][0] > default_max_score { countTopValue += 1 }
            else { break }
        }
        
        for i in surrounding_binary_array {
            if i != zero { non_zero += 1 }
        }
        
        if valid_cortex_array.count != 0 {
            for i in 0...valid_cortex_array.count - 1 {
                var valid_numb = 0
                for cmp in 0...non_zero - 1 {
                    var temp_valid = true
                    for j in 0...9 {
                        if temp_valid {
                            if valid_cortex_array[i][cmp][j] != 0 { //&& surrounding_binary_array[cmp][j] != 0 {
                                if surrounding_binary_array[cmp][j] != valid_cortex_array[i][cmp][j] { temp_valid = false }
                            } else if valid_cortex_array[i][cmp][j] == 0, i >= countTopValue {
                                if surrounding_binary_array[cmp][j] != 0 { temp_valid = false }
                            }
                        } else {
                            break
                        }
                    }
                    
                    if !temp_valid { break }
                    else { valid_numb += 1 }
                }
                
                if valid_numb == non_zero {
                    isValid = true
                    compared_pattern_number = i
                    score = valid_cortex_array[i][4][0]
                    return (isValid, compared_pattern_number, score)
                }
            }
        }
        
        // considering the situation of X..0...X
        if non_zero > 0 {
            for cmp in 0...non_zero - 1 {
                var first_x = -1
                var second_x = 10
                
                for i in stride(from: 4, to: 0, by: -1) {
                    if surrounding_binary_array[cmp][i] == 2 {
                        first_x = i
                        break
                    }
                }
                
                for i in 5...9 {
                    if surrounding_binary_array[cmp][i] == 2 {
                        second_x = i
                        break
                    }
                }
                
                if second_x - first_x >= 6 {
                    return (true, -1, -1)
                } else if cmp == non_zero - 1 {
                    return (false, -2, 0)
                }
            }
        }
        
        return (false, -2, score)
    }
    
    func detectValid(surrounding_binary_array: [Int]) -> Bool {
        var first_x = -1
        var second_x = 10
        
        for i in stride(from: 4, to: 0, by: -1) {
            if surrounding_binary_array[i] == 2 {
                first_x = i
                break
            }
        }
        
        for i in 5...9 {
            if surrounding_binary_array[i] == 2 {
                second_x = i
                break
            }
        }
        
        if second_x - first_x >= 6 { return true }
        return false
    }
    
    func createIdentity(temp_array: [Int]) -> Int {
        var blue_value = 0
        var green_value = 0
        var temp_value = 1
        
        for i in 0...9 {
            if temp_array[i] == 1 { blue_value += temp_value }
            else if temp_array[i] == 2 { green_value += temp_value }
            temp_value *= 2
        }
        
        return blue_value * 10000 + green_value
    }
    
    func combos(array: [Int], k: Int) -> [[Int]] {
        if k == 0 { return [[]] }
        if array.isEmpty { return [] }
        
        let head = array[0]
        
        var combo = [[Int]]()
        let subcombos = combos(array: array, k: k - 1)
        for subcombo in subcombos {
            var sub = subcombo
            sub.insert(head, at: 0)
            combo.append(sub)
        }
        
        var temp = array
        temp.remove(at: 0)
        combo += combos(array: temp, k: k)
        
        return combo
    }
    
    func getDefaultsArray(numb: Int, person: Int) -> [[[Int]]] {
        var result = [[[Int]]]()
        
        if let buffer = CortexUD.object(forKey: cortexArrayCollection[person][numb]) { result = buffer as! [[[Int]]] }
        else { result = [[[0]]] }
        
        return result
    }
    
    func getDefaultsString(numb: Int, person: Int) -> [String] {
        var result = [String]()
        
        if numb < 0 { return [""] }
        
        if let buffer = CortexUD.object(forKey: StringArray[person][numb]) { result = buffer as! [String] }
        else { result = [""] }
        
        return result
    }
    
    func ReloadMemory(index: Int) {
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
                    
                    print(temp_count)
                    
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
    
    func createDirectionCombination(direction_element: [[Int]]) -> [[[Int]]] {
        var combination_array = [[[Int]]]()
        
        if let buffer = CortexUD.object(forKey: "combi") {
            combi_array = buffer as! [[Int]]
        } else {
            combi_array = [[0]]
        }
        
        for com in combi_array {
            var temp = [[Int]]()
            for i in com {
                for k in direction_element[i] {
                    if k == 1 || k == -1 { // check whether it's a zero
                        temp.append(direction_element[i])
                        break
                    }
                }
            }
            if temp.count == com.count { combination_array.append(temp) }
        }
        
        return combination_array
    }
    
    func _CortexDetect(currentBoard: [[Int]], person: Int) -> (Int, Int) {
        var final_x = 0
        var final_y = 0
        var highest_score = 0
        var valid_pattern_point = [[Int]]()
                
        for i in 0...18 {
            for j in 0...18 {
                if currentBoard[i][j] == 0 {
                    let scanArray = createScanArray(currentBoard: currentBoard, center_y: i, center_x: j)
                    let directionArray = createDirectionArray(currentBoard: scanArray)
                    let combination_array = createDirectionCombination(direction_element: directionArray)

                    for identity in combination_array {
                        var nonzero = 0
                        for array in identity {
                            if array != zero { nonzero += 1 }
                        }
                        let cortex_array = getDefaultsArray(numb: nonzero, person: person)
                        let (valid, _, temp_score) = recordValid(surrounding_binary_array: identity, valid_cortex_array: cortex_array)

                        if valid == true && temp_score > highest_score {
                            valid_pattern_point.removeAll()
                            let valid_coordination = [i, j]
                            valid_pattern_point.append(valid_coordination)
                            highest_score = temp_score
                        } else if valid, temp_score == highest_score {
                            let valid_coordination = [i, j]
                            valid_pattern_point.append(valid_coordination)
                        }
                    }
                }
            }
        }
        
        if valid_pattern_point.count > 0 {
            let final_decision = valid_pattern_point.randomElement()
            
            final_y = (final_decision?[0])!
            final_x = (final_decision?[1])!
            
            return (final_y, final_x)
        }
        
        return (-1, -1)
    }
    
    // Change the similar pattern's score
    func changeScore(corresponding_numb: Int, operant: String, DirAmount: Int, DirCorresponding_num: Int, person: Int) {
        let dirArray = cortexArrayCollection[person]
        var pattern_string = [String]()
        var pattern_int_buffer = [Int]()
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest_cortex = NSFetchRequest<NSFetchRequestResult>(entityName: EntityCollection[person])
        
        do {
            let result = try managedContext.fetch(fetchRequest_cortex) as! [NSManagedObject]
            let pattern = result[corresponding_numb].value(forKey: "cortex_array") as! String
            
            if (pattern.count > 0) {
                var data: String = ""
                for i in 0...(pattern.count / 40 - 1) {
                    let lowerBound = pattern.index(pattern.startIndex, offsetBy: i * 40)
                    let upperBound = pattern.index(pattern.startIndex, offsetBy: i * 40 + 40)
                    data = String(pattern[lowerBound..<upperBound])
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
        } catch {
            print("fetch dat failed while changing score")
        }
        
        var temp_valid = getDefaultsArray(numb: 0, person: person)
        var dir_valid = getDefaultsArray(numb: DirAmount, person: person)
        
        if operant == "A" {
            if pattern_int_buffer[4] < default_max_score {
                pattern_int_buffer[4] += 1
                temp_valid[corresponding_numb][4][0] += 1
                dir_valid[DirCorresponding_num][4][0] += 1
            }
        } else if operant == "S" {
            if pattern_int_buffer[4] > 0 && pattern_int_buffer[4] < default_max_score {
                pattern_int_buffer[4] -= 1
                temp_valid[corresponding_numb][4][0] -= 1
                dir_valid[DirCorresponding_num][4][0] -= 1
            }
        }
        
        CortexUD.set(temp_valid, forKey: dirArray[0])
        CortexUD.set(dir_valid, forKey: dirArray[DirAmount])
        CortexUD.synchronize()
        
        let new_cortex_array = convertCurrentToStoreformString(Int_array: pattern_int_buffer)
        
        do {
            let result_cortex = try managedContext.fetch(fetchRequest_cortex) as? [NSManagedObject]
            result_cortex![corresponding_numb].setValue(new_cortex_array, forKey: "cortex_array")
        } catch {
            print("replace new score action failed!!!")
        }
        
        do {
            try managedContext.save()
        } catch {
            print("new score action failed!!")
        }
    }
    
    func searchDataBase(surrounding_array: [[Int]], valid_pattern_array: [[[Int]]]) -> Int {
        var countTopValue = 0

        for array in valid_pattern_array {
            if array[4][0] > default_max_score {
                countTopValue += 1
            }
        }
        
        for i in 0...valid_pattern_array.count - 1 {
            var valid_numb = 0
            let check_numb = surrounding_array.count
            for cmp in 0...surrounding_array.count - 1 {
                var temp_valid = true
                for j in 0...9 {
                    if temp_valid {
                        if valid_pattern_array[i][cmp][j] != 0 { // surrounding_array[cmp][j] != 0 {
                            if surrounding_array[cmp][j] != valid_pattern_array[i][cmp][j] { temp_valid = false }
                        } else if valid_pattern_array[i][cmp][j] == 0, i >= countTopValue {
                            if surrounding_array[cmp][j] != 0 { temp_valid = false }
                        }
                    }
                }
                
                if !temp_valid { break }
                else { valid_numb += 1 }
            }
            
            if valid_numb == check_numb { return i }
        }
        
        return -1
    }
        
    func createAllSequence(temp_array: [[Int]], sequence: [Int], score_operation: String, person: Int) -> [Int] {
        let dirArray = cortexArrayCollection[person]
        var temp_result = [[Int]]()
        var result = [Int]()
        var cortex_array = getDefaultsArray(numb: 0, person: person)
        var dir_cortex_array = getDefaultsArray(numb: sequence.count, person: person)
        
        for i in sequence { temp_result.append(temp_array[i]) }
        
        
        let compare_result = searchDataBase(surrounding_array: temp_result, valid_pattern_array: cortex_array)
        let Dir_compare_result = searchDataBase(surrounding_array: temp_result, valid_pattern_array: dir_cortex_array)
        
        if compare_result > -1 {
            print("change score --> \(score_operation)")
            changeScore(corresponding_numb: compare_result, operant: score_operation, DirAmount: sequence.count, DirCorresponding_num: Dir_compare_result, person: person)
            return []
        } else if compare_result == -1 {
            if score_operation == "S" { return [] }
            let pattern_count = temp_result.count
            
            if pattern_count < 4 {
                for _ in 0...3 - pattern_count {
                    temp_result.append(zero)
                }
            }
            
            temp_result.append([1])
            cortex_array.append(temp_result)
            dir_cortex_array.append(temp_result)
            
            CortexUD.set(cortex_array, forKey: dirArray[0])
            CortexUD.set(dir_cortex_array, forKey: dirArray[sequence.count])
            CortexUD.synchronize()
            
            for pattern in temp_result {
                var unvalid = 0
                for i in pattern {
                    if i == 0 || i == -2 { unvalid += 1 }
                }
                if pattern != zero && unvalid > 0 {
                    var add = 1
                    var blue_point = 0
                    var green_point = 0
                    
                    for i in 0...9 {
                        if pattern[i] == 1 { blue_point += add }
                        else if pattern[i] == -1 { green_point += add }
                        add *= 2
                    }
                    
                    result.append(blue_point * 10000 + green_point)
                } else if pattern != zero && pattern.count == 1 {
                    result.append(1)
                } else {
                    result.append(0)
                }
            }
            
            return result
        }
        
        return []
    }
    
    func saveValidPattern(valid_array: [[Int]], score_operation: String, person: Int) {
        let store_one = [[0]]
        let store_two = [[0], [1], [0, 1]]
        let store_three = [[0], [1], [2], [0, 1], [0, 2], [1, 2], [0, 1, 2]]
        let store_four = [[0], [1], [2], [3], [0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3], [0, 1, 2], [0, 1, 3], [0, 2, 3], [1, 2, 3], [0, 1, 2, 3]]
        
        let valid_amount = valid_array.count
        var store_sequence = [[Int]]()

        if valid_amount == 1 {
            store_sequence = store_one
            for seq in store_sequence {
                let ans = createAllSequence(temp_array: valid_array, sequence: seq, score_operation: score_operation, person: person)
                if ans != [] { instantSaveToCoreData(save_array: ans, person: person) }
            }
        } else if valid_amount == 2 {
            store_sequence = store_two
            for seq in store_sequence {
                let ans = createAllSequence(temp_array: valid_array, sequence: seq, score_operation: score_operation, person: person)
                if ans != [] { instantSaveToCoreData(save_array: ans, person: person) }
            }
        } else if valid_amount == 3 {
            store_sequence = store_three
            for seq in store_sequence {
                let ans = createAllSequence(temp_array: valid_array, sequence: seq, score_operation: score_operation, person: person)
                if ans != [] { instantSaveToCoreData(save_array: ans, person: person) }
            }
        } else if valid_amount == 4 {
            store_sequence = store_four
            for seq in store_sequence {
                let ans = createAllSequence(temp_array: valid_array, sequence: seq, score_operation: score_operation, person: person)
                if ans != [] { instantSaveToCoreData(save_array: ans, person: person) }
            }
        }
    }
    
    func instantSaveToCoreData(save_array: [Int], person: Int) {
        var saveWhere = 0
        for i in 0...3 {
            if save_array[i] != 0 { saveWhere += 1 }
        }
        
        let stringToSave = convertCurrentToStoreformString(Int_array: save_array)
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: EntityCollection[person], in: managedContext)!
        let pattern_info = NSManagedObject(entity: entity, insertInto: managedContext)
        var stringArray = getDefaultsString(numb: saveWhere - 1, person: person) // receiving old data and add new one in to it
        stringArray.append(stringToSave)
        
        
        switch saveWhere {
        case 1:
            CortexUD.set(stringArray, forKey: StringArray[person][0])
            CortexUD.synchronize()
        case 2:
            CortexUD.set(stringArray, forKey: StringArray[person][1])
            CortexUD.synchronize()
        case 3:
            CortexUD.set(stringArray, forKey: StringArray[person][2])
            CortexUD.synchronize()
        case 4:
            CortexUD.set(stringArray, forKey: StringArray[person][3])
            CortexUD.synchronize()
        default:
            break
        }
        
        CortexUD.set(1, forKey: cortex_amountCollection[person])
        CortexUD.synchronize()
        
        pattern_info.setValue(stringToSave, forKey: "cortex_array")
        
        do {
            try managedContext.save()
            switch person {
                case 0: MemoryVC.pattern_arrays.append(pattern_info)
                case 1: MemoryVC.students1_pattern_arrays.append(pattern_info)
                case 2: MemoryVC.students2_pattern_arrays.append(pattern_info)
                case 3: MemoryVC.students3_pattern_arrays.append(pattern_info)
                case 4: MemoryVC.students4_pattern_arrays.append(pattern_info)
                case 5: MemoryVC.students5_pattern_arrays.append(pattern_info)
                case 6: MemoryVC.students6_pattern_arrays.append(pattern_info)
                case 7: MemoryVC.students7_pattern_arrays.append(pattern_info)
                case 8: MemoryVC.students8_pattern_arrays.append(pattern_info)
                default: break
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func CleanCoreData(index: Int) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityCollection[index])
        
        do {
            let results = try managedContext.fetch(request) as! [NSManagedObject]
            
            for i in 0...results.count - 1 {
                managedContext.delete(results[i])
            }
            
            try managedContext.save()
        } catch {
            print("delete request if failed!")
        }
        
        let pattern_int = [[[Int]]]()
        let string_array = [String]()
        
        CortexUD.setValue(pattern_int, forKey: cortexArrayCollection[index][0])
        CortexUD.setValue(pattern_int, forKey: cortexArrayCollection[index][1])
        CortexUD.setValue(pattern_int, forKey: cortexArrayCollection[index][2])
        CortexUD.setValue(pattern_int, forKey: cortexArrayCollection[index][3])
        CortexUD.setValue(pattern_int, forKey: cortexArrayCollection[index][4])
        CortexUD.set(0, forKey: cortex_amountCollection[index])
        CortexUD.set(string_array, forKey: StringArray[index][0])
        CortexUD.set(string_array, forKey: StringArray[index][1])
        CortexUD.set(string_array, forKey: StringArray[index][2])
        CortexUD.set(string_array, forKey: StringArray[index][3])
        CortexUD.synchronize()
        
        for rule in ruleCortex {
            instantSaveToCoreData(save_array: rule, person: index)
        }
        
        DispatchQueue.main.async {
            self.ReloadMemory(index: index)
        }
    }
    
    func detectWinning(currentBoard: [[Int]]) -> (Int, [[Int]]) {
        for row in 0...18 {
            for column in 0...18 {
                if currentBoard[row][column] != 0 {
                    let zero = [0, 0, 0, 0, 0]
                    var final_direction_array = [zero, zero, zero, zero, zero, zero, zero, zero]
                    var state_array = [Int]()
                    
                    for i in 0...7 {
                        for j in 0...4 {
                            final_direction_array[i][j] = direction_pattern_array[i][j] + column + row * 19
                        }
                    }
                    
                    for i in 0...7 {
                        if final_direction_array[i][0] < 0 || final_direction_array[i][4] < 0 || final_direction_array[i][0] > 360 || final_direction_array[i][4] > 360 {
                            state_array.append(0)
                        } else {
                            var buffer = 1
                            if (currentBoard[row][column] != 1 && currentBoard[row][column] != 0) { buffer = -1 }
                            for j in 0...4 {
                                buffer *= 10
                                buffer += currentBoard[final_direction_array[i][j] / 19][final_direction_array[i][j] % 19]
                            }
                            state_array.append(buffer)
                        }
                    }
                    
                    for i in 0...7 {
                        if state_array[i] == 111111, currentBoard[row][column] == 1 {
                            var temp_array = [[Int]]()
                            temp_array.append([row, column])
                            for j in 0...4 { temp_array.append([final_direction_array[i][4 - j] / 19, final_direction_array[i][4 - j] % 19]) }
                            return (1, temp_array)
                        } else if state_array[i] == -111111, currentBoard[row][column] == -1 {
                            var temp_array = [[Int]]()
                            temp_array.append([row, column])
                            for j in 0...4 { temp_array.append([final_direction_array[i][4 - j] / 19, final_direction_array[i][4 - j] % 19]) }
                            return (-1, temp_array)
                        }
                    }
                }
            }
        }
        return (0, [[]])
    }
}
