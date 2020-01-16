//
//  ShowStategyViewController.swift
//  Connect6
//
//  Created by Christian on 2019/5/27.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

class ShowStategyViewController: UIViewController {
    
    
    @IBOutlet weak var showStrategyBoard: UIImageView!
    @IBOutlet weak var strategyNumb: UILabel!
    @IBOutlet weak var score_label: UILabel!
    
    // UserDefaults
    let CortexUD = UserDefaults.standard
    var showStrategyString = ""
    
    // Checkboard coefficient
    var checkboardArray = Array(repeating: Array(repeating: 0, count: 19), count: 19)
    let zero = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    let four_direction_array = [[[-5, 0], [-4, 0], [-3, 0], [-2, 0], [-1, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0]],
                                 [[-5, 5], [-4, 4], [-3, 3], [-2, 2], [-1, 1], [1, -1], [2, -2], [3, -3], [4, -4], [5, -5]],
                                 [[0, 5], [0, 4], [0, 3], [0, 2], [0, 1], [0, -1], [0, -2], [0, -3], [0, -4], [0, -5]],
                                 [[5, 5], [4, 4], [3, 3], [2, 2], [1, 1], [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5]]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let buffer = CortexUD.object(forKey: "cortex_string") {
            showStrategyString = buffer as! String
        } else {
            showStrategyString = ""
        }
        
        strategyNumb.text = showStrategyString
        
        let cortexArray = CreatePatternArray(pattern_string: showStrategyString)
        let cortexIdentity = CreateFourDirectionArray(cortex_array: cortexArray)

        showStrategyOnBoard(direction_array: cortexIdentity)
    }
    
    // Convert Pattern Info to array
    func CreatePatternArray(pattern_string: String) -> [Int] {
        var result_array = [Int]()
        var pattern_string_buffer = [String]()
        
        if (pattern_string.count > 0) {
            var data: String = ""
            for i in 0...(pattern_string.count / 40 - 1) {
                let lowerBound = pattern_string.index(pattern_string.startIndex, offsetBy: i * 40)
                let upperBound = pattern_string.index(pattern_string.startIndex, offsetBy: i * 40 + 40)
                data = String(pattern_string[lowerBound..<upperBound])
                pattern_string_buffer.append(data)
            }
        }
        
        for i in 0...pattern_string_buffer.count - 1 {
            var data: String = ""
            for j in 0...pattern_string_buffer[i].count / 8 - 1 {
                let lowerBound = pattern_string_buffer[i].index(pattern_string_buffer[i].startIndex, offsetBy: j * 8)
                let upperBound = pattern_string_buffer[i].index(pattern_string_buffer[i].startIndex, offsetBy: j * 8 + 8)
                data = String(pattern_string_buffer[i][lowerBound..<upperBound])
                result_array.append(Int(data)!)
            }
        }
        
        score_label.text = "Score: \(result_array[4])"
        
        return result_array
    }
    
    // Create 2-dimension array to show 4 direction array
    func CreateFourDirectionArray(cortex_array: [Int]) -> [[Int]] {
        var result_array = [[Int]]()
        
        for i in 0...3 {
            result_array.append(CreateBinaryArray(numb: cortex_array[i]))
        }
        
        print("direction_array = \(result_array)")
        
        return result_array
    }
    
    func CreateBinaryArray(numb: Int) -> [Int] {
        var blue = numb / 10000
        var green = numb % 10000
        var result_array = Array(repeating: 0, count: 10)
        var blue_temp_array = [Int]()
        var green_temp_array = [Int]()
        
        while blue != 0 {
            blue_temp_array.append(blue % 2)
            blue = blue / 2
        }
        
        while green != 0 {
            green_temp_array.append(green % 2)
            green = green / 2
        }
        
        print("b_string = \(blue_temp_array), g_string = \(green_temp_array)")
        
        var blue_leng = blue_temp_array.count - 1
        var green_leng = green_temp_array.count - 1
        
        while blue_leng >= 0 {
            if blue_temp_array[blue_leng] == 1 { result_array[blue_leng] = 1 }
            blue_leng -= 1
        }
        
        while green_leng >= 0 {
            if green_temp_array[green_leng] == 1 { result_array[green_leng] = -1 }
            green_leng -= 1
        }
        
        print("result_direction_array = \(result_array)")
        
        return result_array
    }
    
    // Drawing strategy on the screen
    func showStrategyOnBoard(direction_array: [[Int]]) {
        
        for i in 0...direction_array.count - 1 {
            if direction_array[i] != zero {
                for j in 0...9 {
                    if direction_array[i][j] == 1 {
                        checkToPlay(column: 9 + four_direction_array[i][j][1], row: 9 + four_direction_array[i][j][0], kind: 0)
                    } else if direction_array[i][j] == -1 {
                        checkToPlay(column: 9 + four_direction_array[i][j][1], row: 9 + four_direction_array[i][j][0], kind: 1)
                    }
                }
            }
        }
        
        TemporaryShow(column: 9, row: 9, kind: 0)
    }
    
    func checkToPlay(column: Int, row: Int, kind: Int) {
        let blue_images = UIImage(named: "blue_dot")!
        let green_image = UIImage(named: "green_dot")!
        let x = Double(showStrategyBoard.frame.size.width ) * Double(column) / 19
        let y = Double(showStrategyBoard.frame.size.height ) * Double(row) / 19
        let symbal_width = CGFloat(showStrategyBoard.frame.size.width) / 19.5
        let symbal_height = CGFloat(showStrategyBoard.frame.size.height) / 19.5
        
        if kind == 0 {
            let new_symbal = UIImageView(image: blue_images)
            new_symbal.frame = CGRect(x: CGFloat(x) + 20.2, y: CGFloat(y) + 261.4, width: symbal_width, height: symbal_height)
            self.view.addSubview(new_symbal)
        } else if kind == 1 {
            let new_symbal = UIImageView(image: green_image)
            new_symbal.frame = CGRect(x: CGFloat(x) + 20.2, y: CGFloat(y) + 261.4, width: symbal_width, height: symbal_height)
            self.view.addSubview(new_symbal)
        }
    }
    
    func TemporaryShow(column: Int, row: Int, kind: Int) {
        let blue_images = [UIImage(named: "blue_dot")!, UIImage(named: "blue_dot_1")!, UIImage(named: "blue_dot_2")!, UIImage(named: "blue_dot_3")!, UIImage(named: "blue_dot_4")!]
        let green_images = [UIImage(named: "green_dot")!, UIImage(named: "green_dot_1")!, UIImage(named: "green_dot_2")!, UIImage(named: "green_dot_3")!, UIImage(named: "green_dot_4")!]
        let images = (kind == 0) ? blue_images : green_images
        let x = Double(showStrategyBoard.frame.size.width ) * Double(column) / 19
        let y = Double(showStrategyBoard.frame.size.height ) * Double(row) / 19
        let symbal_width = CGFloat(showStrategyBoard.frame.size.width) / 19.5
        let symbal_height = CGFloat(showStrategyBoard.frame.size.height) / 19.5
        
        let animatedImage = UIImage.animatedImage(with: images, duration: 0.5)
        let new_prdiction_symbal = UIImageView(image: animatedImage)
        new_prdiction_symbal.frame = CGRect(x: CGFloat(x) + 20.2, y: CGFloat(y) + 261.4, width: symbal_width, height: symbal_height)
        self.view.addSubview(new_prdiction_symbal)
    }
}
