//
//  SpecialPatterns.swift
//  Connect6
//
//  Created by Christian on 2019/8/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import Foundation

struct ChessInfo {
    var x_coordinate: Int
    var y_coordinate: Int
    var value: Int
    
    init(x_coordinate: Int, y_coordinate: Int, value: Int) {
        self.x_coordinate = x_coordinate
        self.y_coordinate = y_coordinate
        self.value = value
    }
}

private let zero = Array(repeating: 0, count: 10)
private let returnNullArray = Array(repeating: -1, count: 5)

private let four_direction_array = [[[-5, 0], [-4, 0], [-3, 0], [-2, 0], [-1, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0]],
                                     [[-5, 5], [-4, 4], [-3, 3], [-2, 2], [-1, 1], [1, -1], [2, -2], [3, -3], [4, -4], [5, -5]],
                                     [[0, 5], [0, 4], [0, 3], [0, 2], [0, 1], [0, -1], [0, -2], [0, -3], [0, -4], [0, -5]],
                                     [[5, 5], [4, 4], [3, 3], [2, 2], [1, 1], [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5]]]

class SpecialPatterns {
    private let certainPatternToCompare_ONE = [[[1,1,1,1,1,0,0,0,0,0], zero, zero, zero, [100]],
                                           [[0,1,1,1,1,1,0,0,0,0], zero, zero, zero, [100]],
                                           [[0,0,1,1,1,1,1,0,0,0], zero, zero, zero, [100]],
                                           [[0,0,0,1,1,1,1,1,0,0], zero, zero, zero, [100]],
                                           [[0,0,0,0,1,1,1,1,1,0], zero, zero, zero, [100]],
                                           [[0,0,0,0,0,1,1,1,1,1], zero, zero, zero, [100]],
                                           [[2,1,1,1,1,0,0,0,0,0], zero, zero, zero, [99]],
                                           [[1,2,1,1,1,0,0,0,0,0], zero, zero, zero, [99]],
                                           [[1,1,2,1,1,0,0,0,0,0], zero, zero, zero, [99]],
                                           [[1,1,1,2,1,0,0,0,0,0], zero, zero, zero, [99]],
                                           [[1,1,1,1,2,0,0,0,0,0], zero, zero, zero, [99]],
                                           [[0,2,1,1,1,1,0,0,0,0], zero, zero, zero, [99]],
                                           [[0,1,2,1,1,1,0,0,0,0], zero, zero, zero, [99]],
                                           [[0,1,1,2,1,1,0,0,0,0], zero, zero, zero, [99]],
                                           [[0,1,1,1,2,1,0,0,0,0], zero, zero, zero, [99]],
                                           [[0,1,1,1,1,2,0,0,0,0], zero, zero, zero, [99]],
                                           [[0,0,2,1,1,1,1,0,0,0], zero, zero, zero, [99]],
                                           [[0,0,1,2,1,1,1,0,0,0], zero, zero, zero, [99]],
                                           [[0,0,1,1,2,1,1,0,0,0], zero, zero, zero, [99]],
                                           [[0,0,1,1,1,2,1,0,0,0], zero, zero, zero, [99]],
                                           [[0,0,1,1,1,1,2,0,0,0], zero, zero, zero, [99]],
                                           [[0,0,0,2,1,1,1,1,0,0], zero, zero, zero, [99]],
                                           [[0,0,0,1,2,1,1,1,0,0], zero, zero, zero, [99]],
                                           [[0,0,0,1,1,2,1,1,0,0], zero, zero, zero, [99]],
                                           [[0,0,0,1,1,1,2,1,0,0], zero, zero, zero, [99]],
                                           [[0,0,0,1,1,1,1,2,0,0], zero, zero, zero, [99]],
                                           [[0,0,0,0,2,1,1,1,1,0], zero, zero, zero, [99]],
                                           [[0,0,0,0,1,2,1,1,1,0], zero, zero, zero, [99]],
                                           [[0,0,0,0,1,1,2,1,1,0], zero, zero, zero, [99]],
                                           [[0,0,0,0,1,1,1,2,1,0], zero, zero, zero, [99]],
                                           [[0,0,0,0,1,1,1,1,2,0], zero, zero, zero, [99]],
                                           [[0,0,0,0,0,2,1,1,1,1], zero, zero, zero, [99]],
                                           [[0,0,0,0,0,1,2,1,1,1], zero, zero, zero, [99]],
                                           [[0,0,0,0,0,1,1,2,1,1], zero, zero, zero, [99]],
                                           [[0,0,0,0,0,1,1,1,2,1], zero, zero, zero, [99]],
                                           [[0,0,0,0,0,1,1,1,1,2], zero, zero, zero, [99]],
                                           [[-1,-1,-1,-1,-1,0,0,0,0,0], zero, zero, zero, [98]],
                                           [[0,-1,-1,-1,-1,-1,0,0,0,0], zero, zero, zero, [98]],
                                           [[0,0,-1,-1,-1,-1,-1,0,0,0], zero, zero, zero, [98]],
                                           [[0,0,0,-1,-1,-1,-1,-1,0,0], zero, zero, zero, [98]],
                                           [[0,0,0,0,-1,-1,-1,-1,-1,0], zero, zero, zero, [98]],
                                           [[0,0,0,0,0,-1,-1,-1,-1,-1], zero, zero, zero, [98]],
                                           [[2,-1,-1,-1,-1,0,0,0,0,0], zero, zero, zero, [97]],
                                           [[-1,2,-1,-1,-1,0,0,0,0,0], zero, zero, zero, [97]],
                                           [[-1,-1,2,-1,-1,0,0,0,0,0], zero, zero, zero, [97]],
                                           [[-1,-1,-1,2,-1,0,0,0,0,0], zero, zero, zero, [97]],
                                           [[-1,-1,-1,-1,2,0,0,0,0,0], zero, zero, zero, [97]],
                                           [[0,2,-1,-1,-1,-1,0,0,0,0], zero, zero, zero, [97]],
                                           [[0,-1,2,-1,-1,-1,0,0,0,0], zero, zero, zero, [97]],
                                           [[0,-1,-1,2,-1,-1,0,0,0,0], zero, zero, zero, [97]],
                                           [[0,-1,-1,-1,2,-1,0,0,0,0], zero, zero, zero, [97]],
                                           [[0,-1,-1,-1,-1,2,0,0,0,0], zero, zero, zero, [97]],
                                           [[0,0,2,-1,-1,-1,-1,0,0,0], zero, zero, zero, [97]],
                                           [[0,0,-1,2,-1,-1,-1,0,0,0], zero, zero, zero, [97]],
                                           [[0,0,-1,-1,2,-1,-1,0,0,0], zero, zero, zero, [97]],
                                           [[0,0,-1,-1,-1,2,-1,0,0,0], zero, zero, zero, [97]],
                                           [[0,0,-1,-1,-1,-1,2,0,0,0], zero, zero, zero, [97]],
                                           [[0,0,0,2,-1,-1,-1,-1,0,0], zero, zero, zero, [97]],
                                           [[0,0,0,-1,2,-1,-1,-1,0,0], zero, zero, zero, [97]],
                                           [[0,0,0,-1,-1,2,-1,-1,0,0], zero, zero, zero, [97]],
                                           [[0,0,0,-1,-1,-1,2,-1,0,0], zero, zero, zero, [97]],
                                           [[0,0,0,-1,-1,-1,-1,2,0,0], zero, zero, zero, [97]],
                                           [[0,0,0,0,2,-1,-1,-1,-1,0], zero, zero, zero, [97]],
                                           [[0,0,0,0,-1,2,-1,-1,-1,0], zero, zero, zero, [97]],
                                           [[0,0,0,0,-1,-1,2,-1,-1,0], zero, zero, zero, [97]],
                                           [[0,0,0,0,-1,-1,-1,2,-1,0], zero, zero, zero, [97]],
                                           [[0,0,0,0,-1,-1,-1,-1,2,0], zero, zero, zero, [97]],
                                           [[0,0,0,0,0,2,-1,-1,-1,-1], zero, zero, zero, [97]],
                                           [[0,0,0,0,0,-1,2,-1,-1,-1], zero, zero, zero, [97]],
                                           [[0,0,0,0,0,-1,-1,2,-1,-1], zero, zero, zero, [97]],
                                           [[0,0,0,0,0,-1,-1,-1,2,-1], zero, zero, zero, [97]],
                                           [[0,0,0,0,0,-1,-1,-1,-1,2], zero, zero, zero, [97]]]
    
    private let certainPatternToCompare_TWO = [[[0,2,1,1,1,2,0,0,0,0], [0,2,1,1,1,2,0,0,0,0], zero, zero, [95]],
                                               [[0,2,1,1,1,2,0,0,0,0], [0,0,2,1,1,1,2,0,0,0], zero, zero, [95]],
                                               [[0,2,1,1,1,2,0,0,0,0], [0,0,0,2,1,1,1,2,0,0], zero, zero, [95]],
                                               [[0,2,1,1,1,2,0,0,0,0], [0,0,0,0,2,1,1,1,2,0], zero, zero, [95]],
                                               [[0,2,1,1,1,2,0,0,0,0], [0,1,1,1,2,2,0,0,0,0], zero, zero, [95]],
                                               [[0,2,1,1,1,2,0,0,0,0], [0,0,0,0,2,2,1,1,1,0], zero, zero, [95]],
                                               [[0,0,2,1,1,1,2,0,0,0], [0,2,1,1,1,2,0,0,0,0], zero, zero, [95]],
                                               [[0,0,2,1,1,1,2,0,0,0], [0,0,2,1,1,1,2,0,0,0], zero, zero, [95]],
                                               [[0,0,2,1,1,1,2,0,0,0], [0,0,0,2,1,1,1,2,0,0], zero, zero, [95]],
                                               [[0,0,2,1,1,1,2,0,0,0], [0,0,0,0,2,1,1,1,2,0], zero, zero, [95]],
                                               [[0,0,2,1,1,1,2,0,0,0], [0,1,1,1,2,2,0,0,0,0], zero, zero, [95]],
                                               [[0,0,2,1,1,1,2,0,0,0], [0,0,0,0,2,2,1,1,1,0], zero, zero, [95]],
                                               [[0,0,0,2,1,1,1,2,0,0], [0,2,1,1,1,2,0,0,0,0], zero, zero, [95]],
                                               [[0,0,0,2,1,1,1,2,0,0], [0,0,2,1,1,1,2,0,0,0], zero, zero, [95]],
                                               [[0,0,0,2,1,1,1,2,0,0], [0,0,0,2,1,1,1,2,0,0], zero, zero, [95]],
                                               [[0,0,0,2,1,1,1,2,0,0], [0,0,0,0,2,1,1,1,2,0], zero, zero, [95]],
                                               [[0,0,0,2,1,1,1,2,0,0], [0,1,1,1,2,2,0,0,0,0], zero, zero, [95]],
                                               [[0,0,0,2,1,1,1,2,0,0], [0,0,0,0,2,2,1,1,1,0], zero, zero, [95]],
                                               [[0,0,0,0,2,1,1,1,2,0], [0,2,1,1,1,2,0,0,0,0], zero, zero, [95]],
                                               [[0,0,0,0,2,1,1,1,2,0], [0,0,2,1,1,1,2,0,0,0], zero, zero, [95]],
                                               [[0,0,0,0,2,1,1,1,2,0], [0,0,0,2,1,1,1,2,0,0], zero, zero, [95]],
                                               [[0,0,0,0,2,1,1,1,2,0], [0,0,0,0,2,1,1,1,2,0], zero, zero, [95]],
                                               [[0,0,0,0,2,1,1,1,2,0], [0,1,1,1,2,2,0,0,0,0], zero, zero, [95]],
                                               [[0,0,0,0,2,1,1,1,2,0], [0,0,0,0,2,2,1,1,1,0], zero, zero, [95]],
                                               [[0,1,1,1,2,2,0,0,0,0], [0,2,1,1,1,2,0,0,0,0], zero, zero, [95]],
                                               [[0,1,1,1,2,2,0,0,0,0], [0,0,2,1,1,1,2,0,0,0], zero, zero, [95]],
                                               [[0,1,1,1,2,2,0,0,0,0], [0,0,0,2,1,1,1,2,0,0], zero, zero, [95]],
                                               [[0,1,1,1,2,2,0,0,0,0], [0,0,0,0,2,1,1,1,2,0], zero, zero, [95]],
                                               [[0,0,0,0,2,2,1,1,1,0], [0,2,1,1,1,2,0,0,0,0], zero, zero, [95]],
                                               [[0,0,0,0,2,2,1,1,1,0], [0,0,2,1,1,1,2,0,0,0], zero, zero, [95]],
                                               [[0,0,0,0,2,2,1,1,1,0], [0,0,0,2,1,1,1,2,0,0], zero, zero, [95]],
                                               [[0,0,0,0,2,2,1,1,1,0], [0,0,0,0,2,1,1,1,2,0], zero, zero, [95]],
                                               // below are special case for 2-line partterns
                                               [[2,1,1,1,2,2,0,0,0,0], [0,1,1,1,2,2,0,0,0,0], zero, zero, [95]],
                                               [[2,1,1,1,2,2,0,0,0,0], [0,0,0,0,2,2,1,1,1,0], zero, zero, [95]],
                                               [[0,0,0,0,2,2,1,1,1,2], [0,1,1,1,2,2,0,0,0,0], zero, zero, [95]],
                                               [[0,0,0,0,2,2,1,1,1,2], [0,0,0,0,2,2,1,1,1,0], zero, zero, [95]],
                                               [[0,1,1,1,2,2,0,0,0,0], [2,1,1,1,2,2,0,0,0,0], zero, zero, [95]],
                                               [[0,0,0,0,2,2,1,1,1,0], [2,1,1,1,2,2,0,0,0,0], zero, zero, [95]],
                                               [[0,1,1,1,2,2,0,0,0,0], [0,0,0,0,2,2,1,1,1,2], zero, zero, [95]],
                                               [[0,0,0,0,2,2,1,1,1,0], [0,0,0,0,2,2,1,1,1,2], zero, zero, [95]],]
    
    private let CortexUd = UserDefaults.standard
    
    func createChessInfoScanArray(currentBoard: [[Int]], center_y: Int, center_x: Int) -> [[ChessInfo]] {
        var scanArray = Array(repeating: Array(repeating: ChessInfo(x_coordinate: -1, y_coordinate: -1, value: -2), count: 11), count: 11)
        
        for i in 0...10 {
            for j in 0...10 {
                let temp_y = center_y - 5 + i
                let temp_x = center_x - 5 + j
                // player = 1, opponent = -1, empty = 0, outOfBound = -2
                 if temp_y < 19, temp_y > -1, temp_x < 19, temp_x > -1 {
                    scanArray[i][j].value = currentBoard[temp_y][temp_x]
                    scanArray[i][j].x_coordinate = temp_x
                    scanArray[i][j].y_coordinate = temp_y
                }
            }
        }
        
        return scanArray
    }
    
    func createDirectionArray(currentChessInfoBoard: [[ChessInfo]]) -> [[ChessInfo]] {
        var final_direction_array = [[ChessInfo]]()
        var temp_direction_array = Array(repeating: ChessInfo(x_coordinate: -1, y_coordinate: -1, value: -2), count: 10)
        
        for i in 0...3 {
            for j in 0...9 {
                temp_direction_array[j].value = currentChessInfoBoard[four_direction_array[i][j][0] + 5][four_direction_array[i][j][1] + 5].value
                temp_direction_array[j].x_coordinate = currentChessInfoBoard[four_direction_array[i][j][0] + 5][four_direction_array[i][j][1] + 5].x_coordinate
                temp_direction_array[j].y_coordinate = currentChessInfoBoard[four_direction_array[i][j][0] + 5][four_direction_array[i][j][1] + 5].y_coordinate
            }
            final_direction_array.append(temp_direction_array)
            temp_direction_array = Array(repeating: ChessInfo(x_coordinate: -1, y_coordinate: -1, value: -2), count: 10)
        }
        
        return final_direction_array
    }
    
    func createDirectionCombination(directionElement: [[ChessInfo]]) -> [[[ChessInfo]]] {
        var FinalCombinationArray = [[[ChessInfo]]]()
        var combiArray = [[Int]]()
        
        if let buffer = CortexUd.object(forKey: "combi") {
            combiArray = buffer as! [[Int]]
        } else {
            combiArray = [[0]]
        }
        
        for combiSubArray in combiArray {
            var temp = [[ChessInfo]]()
            for i in combiSubArray {
                for k in directionElement[i] {
                    if k.value == 1 || k.value == -1 { // check whether it's a zero array
                        temp.append(directionElement[i])
                        break
                    }
                }
            }
            
            if temp.count == combiSubArray.count { FinalCombinationArray.append(temp) }
        }
        
        return FinalCombinationArray
    }
    
    func showBestSuggestion(surrounding_binary_array: [[ChessInfo]]) -> ([Int], [Int], String, Int) {
        var final_x = [Int]()
        var final_y = [Int]()
        var comparePattrnsArray = [[[Int]]]()
        
        let ArrayCountToCompare = surrounding_binary_array.count
        if ArrayCountToCompare > 2 { return (final_x, final_y, "empty", -1) } // temporally detect one line special case, others situation gonna figure out in following days
        
        switch ArrayCountToCompare {
        case 1: comparePattrnsArray = certainPatternToCompare_ONE; break
        case 2: comparePattrnsArray = certainPatternToCompare_TWO; break
        default: break
        }
        
        for array in comparePattrnsArray {
            var ContinueDetect = true
            var ArrayMatchCount = 0
            var currentCheckState = "empty"
            let score = array[4][0]
            
            for i in 0...ArrayCountToCompare - 1 {
                for j in 0...9 {
                    if array[i][j] == 1 || array[i][j] == -1 {
                        currentCheckState = (array[i][j] == 1) ? "Reminding" : "Warning"
                        if array[i][j] != surrounding_binary_array[i][j].value { ContinueDetect = false }
                        else {
                            final_x.append(surrounding_binary_array[i][j].x_coordinate)
                            final_y.append(surrounding_binary_array[i][j].y_coordinate)
                        }
                    } else if array[i][j] == 2 {
                        if surrounding_binary_array[i][j].value != 0 { ContinueDetect = false }
                    }
                    
                    if !ContinueDetect {
                        final_x.removeAll()
                        final_y.removeAll()
                        currentCheckState = "empty"
                        break
                    } else if ContinueDetect && j == 9 {
                        ArrayMatchCount += 1
                    }
                }
                
                if !ContinueDetect {
                    currentCheckState = "empty"
                    break
                } else if ContinueDetect && ArrayMatchCount == ArrayCountToCompare {
                    if final_x != returnNullArray && final_y != returnNullArray && currentCheckState != "empty" { return (final_x, final_y, currentCheckState, score) }
                }
            }
        }
        
        return (returnNullArray, returnNullArray, "empty", -1)
    }
    
    func SearchingSuggestionArray(originalArray: [[Int]]) -> ([Int], [Int], String) {
        var currentHighestScore = 0
        var currentReturnCoordinates_x = [Int]()
        var currentReturnCoordinates_y = [Int]()
        var currentSuggestionStatus = ""
        
        for i in 0...18 {
            for j in 0...18 {
                if originalArray[i][j] == 0 {
//                    print("i = \(i), j = \(j)")
                    let currentChessInfoScanArray = createChessInfoScanArray(currentBoard: originalArray, center_y: i, center_x: j)
                    let current4directionArray = createDirectionArray(currentChessInfoBoard: currentChessInfoScanArray)
                    let current4directionCombinationArray = createDirectionCombination(directionElement: current4directionArray)
                    
                    for SubCombinationArray in current4directionCombinationArray {
                        let (returnCoordinates_x, returnCoordinates_y, suggestionStatus, score) = showBestSuggestion(surrounding_binary_array: SubCombinationArray)
                        if suggestionStatus != "empty", currentHighestScore < score {
                            // record highest score pattern
                            currentHighestScore = score
                            currentReturnCoordinates_x = returnCoordinates_x
                            currentReturnCoordinates_y = returnCoordinates_y
                            currentSuggestionStatus = suggestionStatus
                        }
                    }
                }
            }
        }
        
        print("currentReturnCoordinates_x = \(currentReturnCoordinates_x)")
        print("currentReturnCoordinates_y = \(currentReturnCoordinates_y)")
        print("currentSuggestionStatus = \(currentSuggestionStatus)")
        if currentHighestScore > 0 { return (currentReturnCoordinates_x, currentReturnCoordinates_y, currentSuggestionStatus) }
        
        return (returnNullArray, returnNullArray, "empty")
    }
}
