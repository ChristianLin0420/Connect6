//
//  TrainningViewController.swift
//  Connect6
//
//  Created by Christian on 2019/5/27.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

struct restoreElement {
    var array = [[Int]]()
    var score_operation = ""
    var person = 0
}

class TrainningViewController: UIViewController {
    
    // File name
    private let CortexProcess = Cortex()
    private let SpecialPatternsProcess = SpecialPatterns()
    
    // UI elements
    @IBOutlet weak var TeachByUser: UIButton!
    @IBOutlet weak var LearnByOwn: UIButton!
    @IBOutlet weak var Check: UIButton!
    @IBOutlet weak var checkboard: UIImageView!
    @IBOutlet weak var next_round_btn: UIButton!
    @IBOutlet weak var start_btn: UIButton!
    @IBOutlet weak var train_icon: UIImageView!
    @IBOutlet weak var start_userTeach: UIButton!
    @IBOutlet weak var start_ownObserve: UIButton!
    @IBOutlet weak var start_background: UILabel!
    @IBOutlet weak var start_back: UIButton!
    @IBOutlet weak var back_btn: UIButton!
    @IBOutlet weak var auto_btn: UIButton!
    
    @IBOutlet weak var P1_icon: UIImageView!
    @IBOutlet weak var P2_icon: UIImageView!
    @IBOutlet weak var P1_current_name: UILabel!
    @IBOutlet weak var P2_current_name: UILabel!
    
    @IBOutlet weak var PopUpView: UIImageView!
    @IBOutlet weak var PopUpViewLabel: UILabel!
    @IBOutlet weak var PopUpViewBtn_decline: UIButton!
    @IBOutlet weak var PopUpViewBtn_confirm: UIButton!

    // winning coefficient
    private var continue_playing = true
    
    // Trainning mode
    private var Learn = false
    private var Teach = false
    private var student_predict_origin_x = 0
    private var student_predict_origin_y = 0
    private var student_predict_final_x = 0
    private var student_predict_final_y = 0
    private var student_predict_teach_origin_x = 0
    private var student_predict_teach_origin_y = 0
    private var student_predict_teach_final_x = 0
    private var student_predict_teach_final_y = 0
    
    // Temporary animation
    private var symbals = [UIImageView]()
    private var symbals_temporary = [UIImageView]()
    private var suggestion_symbals_collecion = [UIImageView]()
    
    // Playing Coefficient
    var current_player = 1
    private var round_number = 3
    private var current_x = 0
    private var current_y = 0
    private var tap = false
    private var auto = false
    
    // Playsers
    var P1_icon_img = UIImage(named: "User")
    var P1_name: String? = "Christian"
    var P2_icon_img = UIImage(named: "opponent_1")
    var P2_name: String? = "Julia"
    var current_teacher = 0
    var current_student = 0
    
    // Restore Array
    var restoreArray = [restoreElement]()
    
    // Checkerboard
    private var currentCheckerboard = Array(repeating: Array(repeating: 0, count: 19), count: 19)
    private var TeachingCheckerboard = Array(repeating: Array(repeating: 0, count: 19), count: 19)
    private var LearningCheckerboard = Array(repeating: Array(repeating: 0, count: 19), count: 19)
    private let zero = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    // Cortex array
    private let CortexUD = UserDefaults.standard
    private var cortex_array = [[[Int]]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("teacher = \(current_teacher)")
        print("student = \(current_student)")
        
        P1_icon.image = P1_icon_img
        P2_icon.image = P2_icon_img
        P1_current_name.text = P1_name
        P2_current_name.text = P2_name
        
        start_background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        start_back.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.11, height: self.view.frame.width * 0.11)
        start_back.center = CGPoint(x: self.view.frame.midX * 0.2, y: self.view.frame.midY * 0.13)
        
        train_icon.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.58, height: self.view.frame.width * 0.41)
        train_icon.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY * 0.46)
        
        start_userTeach.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.29, height: self.view.frame.width * 0.29)
        start_userTeach.center = CGPoint(x: self.view.frame.midX * 0.615, y: self.view.frame.midY * 1.05)
        
        start_ownObserve.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.29, height: self.view.frame.width * 0.29)
        start_ownObserve.center = CGPoint(x: self.view.frame.midX * 1.385, y: self.view.frame.midY * 1.05)
        
        start_btn.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.58, height: self.view.frame.width * 0.222)
        start_btn.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY * 1.64)

        self.view.addSubview(start_back)
        self.view.addSubview(train_icon)
        self.view.addSubview(start_userTeach)
        self.view.addSubview(start_ownObserve)
        self.view.addSubview(start_btn)
        
    }
    
    @objc func checkerBoard_tapGesture(gesture: UITapGestureRecognizer) {
        if tap {
            let cgpoint = gesture.location(in: checkboard)
            let checkerboard_width: Double = Double(checkboard!.frame.size.width)
            let checkerboard_height: Double = Double(checkboard!.frame.size.height)
            
            let touchX: Double = Double(cgpoint.x)
            let touchY: Double = Double(cgpoint.y)
            
            let oneThird_width: Double = Double(checkerboard_width / 19)
            let oneThird_height: Double = Double(checkerboard_height / 19)
            
            if gesture.state == .ended {
                let x_number = Int(touchX / oneThird_width)
                let y_number = Int(touchY / oneThird_height)
                
                if x_number < 19 && y_number < 19 { //&& predicting_state == false {
                    TemporaryShow(column: x_number, row: y_number, kind: current_player)
                }
                
                if Teach == true && Learn == false {
                    for symbal in symbals_temporary { symbal.removeFromSuperview() }
                    student_predict_final_x = x_number
                    student_predict_final_y = y_number
                    TemporaryShow(column: student_predict_final_x, row: student_predict_final_y, kind: current_player)
                } else if Teach == true && Learn == true {
                    
                }
            }
        }
    }
    
    func checkToPlay(column: Int, row: Int, kind: Int) {

        print("continue_playing = \(continue_playing)")
        
        if kind == 0 || kind == 1 {
            if continue_playing == false { return }
        }
        
        // clean all suggestion collections
        for image in suggestion_symbals_collecion {
            image.removeFromSuperview()
        }
        suggestion_symbals_collecion.removeAll()
        
        let blue_images = UIImage(named: "blue_dot")!
        let green_image = UIImage(named: "green_dot")!
        let x = Double(checkboard.frame.size.width ) * Double(column) / 19
        let y = Double(checkboard.frame.size.height ) * Double(row) / 19
        let symbal_width = CGFloat(checkboard.frame.size.width) / 19.5
        let symbal_height = CGFloat(checkboard.frame.size.height) / 19.5
        
        var check_exist = true
        if currentCheckerboard[row][column] != 0 { check_exist = false }
        
        print("check_exist = \(check_exist)")
        print("round_number = \(round_number)")
        
        if (check_exist), kind == 0 {
            continue_playing = false
            
            currentCheckerboard[row][column] = 1
            for image in symbals_temporary { image.removeFromSuperview() }
            let new_symbal = UIImageView(image: blue_images)
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
            
            if Learn == true {
                student_predict_teach_final_x = column
                student_predict_teach_final_y = row
                LearningCheckerboard = currentCheckerboard
                DispatchQueue.main.async { self.LearingMode() }
            }
            
            let (winningState, winning_pattern) = CortexProcess.detectWinning(currentBoard: currentCheckerboard)
            showResult(winner: winningState, winning_pattern: winning_pattern)
            
            if round_number == 1, winningState == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 , execute: {
                    self.current_player = 0
                    self.round_number += 1
                    self.TeacherPlayAutomatically()
                }) // automatically predict where to set the chess
            } else if round_number == 2, winningState == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.current_player = 1
                    self.round_number += 1
                    self.StudentPlay()
                })
            }
        } else if (check_exist), kind == 1 {
            continue_playing = false
            
            currentCheckerboard[row][column] = -1
            for image in symbals_temporary { image.removeFromSuperview() }
            let new_symbal = UIImageView(image: green_image)
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
            
            if Teach == true {
                student_predict_final_x = column
                student_predict_final_y = row
                for i in 0...18 {
                    for j in 0...18 {
                        TeachingCheckerboard[i][j] = -currentCheckerboard[i][j]
                    }
                }
                print("student is taught by teacher")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.LearingMode()
                })
            }
            
            let (winningState, winning_pattern) = CortexProcess.detectWinning(currentBoard: currentCheckerboard)
            showResult(winner: winningState, winning_pattern: winning_pattern)
            if round_number == 3, winningState == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.current_player = 1
                    self.round_number += 1
                    self.StudentPlay()
                })
            } else if round_number == 4, winningState == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 , execute: {
                    self.current_player = 0
                    self.round_number = 1
                    self.TeacherPlayAutomatically()
                })
            }
        } else if (!check_exist), kind == 1 {
            for image in symbals_temporary { image.removeFromSuperview() }
            StudentPlay()
        } else if kind == 2 {
            currentCheckerboard[row][column] = 1
            let new_symbal = UIImageView(image: blue_images)
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
        } else if kind == 3 {
            let new_symbal = UIImageView(image: green_image)
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
        } else if (!check_exist), kind == 4 {
            let new_symbal = UIImageView(image: UIImage(named: "blue_winning")!)
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
        } else if (!check_exist), kind == 5 {
            let new_symbal = UIImageView(image: UIImage(named: "green_winning")!)
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
        }
    }
    
    func drawSuggestionPattern(suggestionStatus: String, x_coordinateColleciont: [Int], y_coordinateCollections: [Int], player: String) {
        var currentStatues = UIImage(named: "blue_reminding")
        
        if player == "teacher" {
            if suggestionStatus == "Warning" { currentStatues = UIImage(named: "green_warning") }
        } else {
            if suggestionStatus == "Reminding" { currentStatues = UIImage(named: "green_reminding") }
            else { currentStatues = UIImage(named: "blue_warning") }
        }
        
        let symbal_width = CGFloat(checkboard.frame.size.width) * 0.99 / 19.5
        let symbal_height = CGFloat(checkboard.frame.size.height) * 0.99 / 19.5
        
        for index in 0...x_coordinateColleciont.count - 1 {
            let x = Double(checkboard.frame.size.width) * Double(x_coordinateColleciont[index]) / 19
            let y = Double(checkboard.frame.size.height) * Double(y_coordinateCollections[index]) / 19
            let new_suggestion_symbal = UIImageView(image: currentStatues)
            
            new_suggestion_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            suggestion_symbals_collecion.append(new_suggestion_symbal)
            self.view.addSubview(new_suggestion_symbal)
        }
    }
    
    func TeacherPlayAutomatically() {
        var (predicted_y, predicted_x) = (0, 0)
        var (suggested_x_collection, suggested_y_collection, suggestionStatus) = ([0], [0], "")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            self.tap = false
            self.studentPredictTeacherStep()
            (predicted_y, predicted_x) = self.CortexProcess._CortexDetect(currentBoard: self.currentCheckerboard, person: self.current_teacher)
            (suggested_x_collection, suggested_y_collection, suggestionStatus) = self.SpecialPatternsProcess.SearchingSuggestionArray(originalArray: self.currentCheckerboard)
            if suggestionStatus != "empty" { self.drawSuggestionPattern(suggestionStatus: suggestionStatus, x_coordinateColleciont: suggested_x_collection, y_coordinateCollections: suggested_y_collection, player: "teacher") } // drawing alert coordinates
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.tap = true
            
            if (predicted_y, predicted_x) != (-1, -1) {
                if self.Learn {
                    self.student_predict_teach_final_x = predicted_x
                    self.student_predict_teach_final_y = predicted_y
                }
                
                if self.auto { DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { self.checkToPlay(column: predicted_x, row: predicted_y, kind: 0) })
                    
                } else { self.TemporaryShow(column: predicted_x, row: predicted_y, kind: 0) }
                return
            }
            
            var random_array = [Int]()
            for i in 0...18 {
                for j in 0...18 {
                    if self.currentCheckerboard[i][j] == 0 { random_array.append(i + j * 19) }
                }
            }
            
            let random_play = random_array.randomElement()
            let random_column = random_play! % 19
            let random_row = random_play! / 19
            
            if self.Learn {
                self.student_predict_teach_final_x = random_column
                self.student_predict_teach_final_y = random_row
            }
            
            if self.auto { DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { self.checkToPlay(column: random_column, row: random_row, kind: 0) })
                
            } else { self.TemporaryShow(column: random_column, row: random_row, kind: 0) }
            
            random_array.removeAll()
        }
    }
    
    func studentPredictTeacherStep() {
        
        if !Learn { return }
        
        let (student_y, student_x) = CortexProcess._CortexDetect(currentBoard: currentCheckerboard, person: current_student)
        
        if (student_y, student_x) != (-1, -1) {
            student_predict_teach_origin_x = student_x
            student_predict_teach_origin_y = student_y
            return
        }
        
        var random_array = [Int]()
        for i in 0...18 {
            for j in 0...18 {
                if currentCheckerboard[i][j] == 0 { random_array.append(i + j * 19) }
            }
        }

        let random_play = random_array.randomElement()
        student_predict_teach_origin_x = random_play! % 19
        student_predict_teach_origin_y = random_play! / 19
    }
    
    
    func TemporaryShow(column: Int, row: Int, kind: Int) {
        
        if continue_playing == false { return }
        
        if currentCheckerboard[row][column] != 0 { return }
        else { Check.isEnabled = true }
        
        for image in symbals_temporary { image.removeFromSuperview() }
        
        let blue_images = [UIImage(named: "blue_dot")!, UIImage(named: "blue_dot_1")!, UIImage(named: "blue_dot_2")!, UIImage(named: "blue_dot_3")!, UIImage(named: "blue_dot_4")!]
        let green_images = [UIImage(named: "green_dot")!, UIImage(named: "green_dot_1")!, UIImage(named: "green_dot_2")!, UIImage(named: "green_dot_3")!, UIImage(named: "green_dot_4")!]
        let images = (kind == 0) ? blue_images : green_images
        let x = Double(checkboard.frame.size.width ) * Double(column) / 19
        let y = Double(checkboard.frame.size.height ) * Double(row) / 19
        let symbal_width = CGFloat(checkboard.frame.size.width) / 19.5
        let symbal_height = CGFloat(checkboard.frame.size.height) / 19.5
        
        let animatedImage = UIImage.animatedImage(with: images, duration: 0.5)
        let new_prdiction_symbal = UIImageView(image: animatedImage)
        new_prdiction_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
        symbals_temporary.append(new_prdiction_symbal)
        self.view.addSubview(new_prdiction_symbal)
        
        current_x = column
        current_y = row
    }
    
    func StudentPlay() {
        var opposite_currentboard = Array(repeating: Array(repeating: 0, count: 19), count: 19)
        for i in 0...18 {
            for j in 0...18 {
                opposite_currentboard[i][j] = -currentCheckerboard[i][j]
            }
        }
        
        var (next_y, next_x) = (0, 0)
        var (suggested_x_collection, suggested_y_collection, suggestionStatus) = ([0], [0], "")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            (next_y, next_x) = self.CortexProcess._CortexDetect(currentBoard: opposite_currentboard, person: self.current_student)
            (suggested_x_collection, suggested_y_collection, suggestionStatus) = self.SpecialPatternsProcess.SearchingSuggestionArray(originalArray: opposite_currentboard)
            if suggestionStatus != "empty" { self.drawSuggestionPattern(suggestionStatus: suggestionStatus, x_coordinateColleciont: suggested_x_collection, y_coordinateCollections: suggested_y_collection, player: "student") } // drawing alert coordinates
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.tap = true
            if (next_y, next_x) != (-1, -1) {
                if self.Teach {
                    self.student_predict_origin_x = next_x
                    self.student_predict_origin_y = next_y
                    self.TemporaryShow(column: next_x, row: next_y, kind: 1)
                } else { self.checkToPlay(column: next_x, row: next_y, kind: 1) }
                return
            }
            
            var random_array = [Int]()
            for i in 0...18 {
                for j in 0...18 {
                    if self.currentCheckerboard[i][j] == 0 { random_array.append(i * 19 + j) }
                }
            }
            
            let random_play = random_array.randomElement()
            let random_column = random_play! % 19
            let random_row = random_play! / 19
            
            if self.Teach { self.TemporaryShow(column: random_column, row: random_row, kind: 1) }
            else { self.checkToPlay(column: random_column, row: random_row, kind: 1) }
        }
    }
    
    func LearingMode() {
        if student_predict_final_x == student_predict_origin_x, student_predict_final_y == student_predict_origin_y, Teach, current_player == 1 { return }
        if student_predict_teach_final_x == student_predict_teach_origin_x, student_predict_teach_final_y == student_predict_teach_origin_y, Learn, current_player == 0 { return }
        
        var studentTaughtByTeacher_eight_direction_array = [[Int]]()
        var studentTaughtByTeacher_eight_direction_array_for_previous = [[Int]]()
        var studentWatchingTeacher_eight_direction_array = [[Int]]()
        var studentWatchingTeacher_eight_direction_array_for_previous = [[Int]]()
        
        if Teach, current_player == 1 {
            print("student is taught by teacher")
            studentTaughtByTeacher_eight_direction_array = CortexProcess.createDirectionArray(currentBoard: CortexProcess.createScanArray(currentBoard: TeachingCheckerboard, center_y: student_predict_final_y, center_x: student_predict_final_x))
            
            studentTaughtByTeacher_eight_direction_array_for_previous = CortexProcess.createDirectionArray(currentBoard: CortexProcess.createScanArray(currentBoard: TeachingCheckerboard, center_y: student_predict_origin_y, center_x: student_predict_origin_x))
            
            getting4DirectionArray(final_array: studentTaughtByTeacher_eight_direction_array, previous: studentTaughtByTeacher_eight_direction_array_for_previous, student_numb: current_student)
        }
        
        if Learn, current_player == 0 {
            print("student is watching teacher")
            print("student_predict_teach_final_x = \(student_predict_teach_final_x)")
            print("student_predict_teach_final_y = \(student_predict_teach_final_y)")
            print("student_predict_teach_origin_x = \(student_predict_teach_origin_x)")
            print("student_predict_teach_origin_y = \(student_predict_teach_origin_y)")
            studentWatchingTeacher_eight_direction_array = CortexProcess.createDirectionArray(currentBoard: CortexProcess.createScanArray(currentBoard: LearningCheckerboard, center_y: student_predict_teach_final_y, center_x: student_predict_teach_final_x))
            
            studentWatchingTeacher_eight_direction_array_for_previous = CortexProcess.createDirectionArray(currentBoard: CortexProcess.createScanArray(currentBoard: LearningCheckerboard, center_y: student_predict_teach_origin_y, center_x: student_predict_teach_origin_x))
            
            getting4DirectionArray(final_array: studentWatchingTeacher_eight_direction_array, previous: studentWatchingTeacher_eight_direction_array_for_previous, student_numb: current_student)
        }
    }
    
    func detectSameSubDirectionArray(DirectionArray: [[Int]]) -> [[Int]] {
        var finalDirectionArray = [[Int]]()
        
        switch DirectionArray.count {
        case 1:
            finalDirectionArray.append(DirectionArray[0])
            break
        case 2:
            if DirectionArray[0] != DirectionArray[1] { finalDirectionArray = DirectionArray }
            else { finalDirectionArray.append(DirectionArray[0]) }
            break
        case 3:
            if DirectionArray[0] != DirectionArray[1] {
                finalDirectionArray.append(DirectionArray[0])
                finalDirectionArray.append(DirectionArray[1])
                if DirectionArray[2] != DirectionArray[0], DirectionArray[2] != DirectionArray[1] { finalDirectionArray.append(DirectionArray[2]) }
            } else {
                finalDirectionArray.append(DirectionArray[0])
                if DirectionArray[2] != DirectionArray[0] { finalDirectionArray.append(DirectionArray[2]) }
            }
            break
        case 4:
            if DirectionArray[0] != DirectionArray[1] {
                finalDirectionArray.append(DirectionArray[0])
                finalDirectionArray.append(DirectionArray[1])
                if DirectionArray[2] != DirectionArray[0], DirectionArray[2] != DirectionArray[1] { finalDirectionArray.append(DirectionArray[2])
                    if DirectionArray[3] != DirectionArray[0], DirectionArray[3] != DirectionArray[1], DirectionArray[3] != DirectionArray[2] { finalDirectionArray.append(DirectionArray[3])
                    }
                }
            } else {
                finalDirectionArray.append(DirectionArray[0])
                if DirectionArray[2] != DirectionArray[0] {
                    finalDirectionArray.append(DirectionArray[2])
                    if DirectionArray[3] != DirectionArray[0], DirectionArray[3] != DirectionArray[2] {
                        finalDirectionArray.append(DirectionArray[3])
                    }
                } else {
                    if DirectionArray[3] != DirectionArray[0] { finalDirectionArray.append(DirectionArray[3]) }
                }
            }
            break
        default:
            break
        }
        
        return finalDirectionArray
    }
    
    func getting4DirectionArray(final_array: [[Int]], previous: [[Int]], student_numb: Int) {
        var four_direction_array = [[Int]]()
        var four_direction_array_for_previous = [[Int]]()
        var final_4_direction_array = [[Int]]()
        var final_4_direction_array_for_previous = [[Int]]()
        var store_valid_array = [[Int]]()
        var store_valid_array_for_previous = [[Int]]()
        
        for i in 0...3 {
            if final_array[i] != zero { four_direction_array.append(final_array[i]) }
            if previous[i] != zero { four_direction_array_for_previous.append(previous[i]) }
        }
        
        final_4_direction_array = detectSameSubDirectionArray(DirectionArray: four_direction_array)
        final_4_direction_array_for_previous = detectSameSubDirectionArray(DirectionArray: four_direction_array_for_previous)
        
        let cortexArrayCollection = ["cortex_array_one", "ST1_cortex_array_one", "ST2_cortex_array_one", "ST3_cortex_array_one", "ST4_cortex_array_one", "ST6_cortex_array_one", "ST5_cortex_array_one", "ST7_cortex_array_one", "ST8_cortex_array_one"]
        
        if let buffer_array = CortexUD.object(forKey: cortexArrayCollection[current_student]) { cortex_array = buffer_array as! [[[Int]]] }
        else { cortex_array = [[[0]]] }
        
        for array in final_4_direction_array {
            let (valid, _, _) = CortexProcess.recordValid(surrounding_binary_array: [array], valid_cortex_array: cortex_array)
            if valid == true { store_valid_array.append(array) }
        }
        
        for array in final_4_direction_array_for_previous {
            let (valid, _, _) = CortexProcess.recordValid(surrounding_binary_array: [array], valid_cortex_array: cortex_array)
            if valid == true { store_valid_array_for_previous.append(array) }
        }
        
        print("store_valid_array = \(store_valid_array)")
        print("store_valid_array_for_previous = \(store_valid_array_for_previous)")
        print("student to learn = \(current_student)")
        
        // temporarily add memory operation to restoreArray
        let restore_a = restoreElement(array: store_valid_array, score_operation: "S", person: student_numb)
        let restore_s = restoreElement(array: store_valid_array_for_previous, score_operation: "A", person: student_numb)
        restoreArray.append(restore_a)
        restoreArray.append(restore_s)
        
        CortexProcess.saveValidPattern(valid_array: store_valid_array, score_operation: "A", person: student_numb)
        CortexProcess.saveValidPattern(valid_array: store_valid_array_for_previous, score_operation: "S", person: student_numb)
        print("------------------------------------------------")
    }
    
    func restoreMemory(array: [restoreElement]) {
        for element in array {
            CortexProcess.saveValidPattern(valid_array: element.array, score_operation: element.score_operation, person: element.person)
        }
        
        restoreArray.removeAll()
    }
    
    func showRestoreMemoryView() {
        PopUpView.alpha = 1.0
        PopUpViewLabel.alpha = 1.0
        PopUpViewBtn_confirm.alpha = 1.0
        PopUpViewBtn_decline.alpha = 1.0
        
        let tap_c = UILongPressGestureRecognizer(target: self, action: #selector(confirm_memory))
        tap_c.minimumPressDuration = 0
        PopUpViewBtn_confirm.addGestureRecognizer(tap_c)
        PopUpViewBtn_confirm.isUserInteractionEnabled = true
        
        let tap_d = UILongPressGestureRecognizer(target: self, action: #selector(decline_memory))
        tap_d.minimumPressDuration = 0
        PopUpViewBtn_decline.addGestureRecognizer(tap_d)
        PopUpViewBtn_decline.isUserInteractionEnabled = true
    }
    
    @objc func confirm_memory(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            PopUpViewBtn_confirm.isSelected = true
        } else if gesture.state == .ended {
            print("Confirm memory updating!!")
            PopUpViewBtn_confirm.isSelected = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.resetAll()
            })
        }
    }
    
    @objc func decline_memory(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            PopUpViewBtn_decline.isSelected = true
        } else if gesture.state == .ended {
            print("Decline memory updating!!")
            PopUpViewBtn_decline.isSelected = false
            restoreMemory(array: restoreArray)
            
            let group = DispatchGroup()
            group.enter()
            
            DispatchQueue.global().sync {
                self.restoreMemory(array: self.restoreArray)
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.resetAll()
            }
        }
    }
    
    func showResult(winner: Int, winning_pattern: [[Int]]) {
        if winner == 1 {
            continue_playing = false
            for coordination in winning_pattern { checkToPlay(column: coordination[1], row: coordination[0], kind: 4) }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.showRestoreMemoryView()
            })
        } else if winner == -1 {
            continue_playing = false
            for coordination in winning_pattern { checkToPlay(column: coordination[1], row: coordination[0], kind: 5) }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.showRestoreMemoryView()
            })
        } else {
            continue_playing = true
        }
    }
    
    func resetAll() {
        for dot in suggestion_symbals_collecion { dot.removeFromSuperview() }
        for dot in symbals { dot.removeFromSuperview() }
        suggestion_symbals_collecion.removeAll()
        symbals.removeAll()
        
        for i in 0...18 {
            for j in 0...18 {
                currentCheckerboard[i][j] = 0
            }
        }
        
        current_player = 0
        
        Check.isHidden = true
        next_round_btn.isHidden = false
        
        PopUpView.alpha = 0.0
        PopUpViewLabel.alpha = 0.0
        PopUpViewBtn_confirm.alpha = 0.0
        PopUpViewBtn_decline.alpha = 0.0
    }
    
    @IBAction func check_mode(_ sender: UIButton) {
        checkToPlay(column: self.current_x, row: self.current_y, kind: self.current_player)
        Check.isEnabled = false        
    }
    
    @IBAction func teach_mode(_ sender: UIButton) {
        if !Teach {
            TeachByUser.setImage(UIImage(named: "LearningByUser_on"), for: .normal)
            Teach = !Teach
        } else if Teach && Learn {
            TeachByUser.setImage(UIImage(named: "LearningByUser_off"), for: .normal)
            Teach = !Teach
        }
    }
    
    @IBAction func learn_mode(_ sender: UIButton) {
        if !Learn {
            LearnByOwn.setImage(UIImage(named: "LearnbyOwn_on"), for: .normal)
            Learn = !Learn
        } else if Teach && Learn {
            LearnByOwn.setImage(UIImage(named: "LearnbyOwn_off"), for: .normal)
            Learn = !Learn
        }
    }
    
    @IBAction func next_round(_ sender: UIButton) {
        for dot in symbals { dot.removeFromSuperview() }
        current_player = 0
        round_number = 2
        continue_playing = true
        checkToPlay(column: 9, row: 9, kind: 0)
        next_round_btn.isHidden = true
        Check.isHidden = false
    }
    
    @IBAction func start_Teach(_ sender: UIButton) {
        if !Teach {
            start_userTeach.setImage(UIImage(named: "train_user_on"), for: .normal)
            TeachByUser.setImage(UIImage(named: "LearningByUser_on"), for: .normal)
        } else {
            start_userTeach.setImage(UIImage(named: "train_user_off"), for: .normal)
            TeachByUser.setImage(UIImage(named: "LearningByUser_off"), for: .normal)
        }
        
        Teach = !Teach
        
        if Teach || Learn { start_btn.isEnabled = true }
        else { start_btn.isEnabled = false }
    }
    
    @IBAction func start_Observe(_ sender: UIButton) {
        if !Learn {
            start_ownObserve.setImage(UIImage(named: "train_own_on"), for: .normal)
            LearnByOwn.setImage(UIImage(named: "LearnbyOwn_on"), for: .normal)
        } else {
            start_ownObserve.setImage(UIImage(named: "train_own_off"), for: .normal)
            LearnByOwn.setImage(UIImage(named: "LearnbyOwn_off"), for: .normal)
        }
        
        Learn = !Learn
        
        if Teach || Learn { start_btn.isEnabled = true }
        else { start_btn.isEnabled = false }
    }
    
    @IBAction func startToTrain(_ sender: Any) {
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1.2,
                delay: 0,
                options: [],
                animations: {
                    self.start_back.removeFromSuperview()
                    self.back_btn.isHidden = false
                    self.train_icon.center = CGPoint(x: self.train_icon.frame.midX, y: self.view.frame.height + self.train_icon.frame.height)
                    self.start_userTeach.center = CGPoint(x: self.start_userTeach.frame.midX, y: self.view.frame.height + self.start_userTeach.frame.height * 2.5)
                    self.start_ownObserve.center = CGPoint(x: self.start_ownObserve.frame.midX, y: self.view.frame.height + self.start_ownObserve.frame.height * 2.5)
                    self.start_btn.center = CGPoint(x: self.start_btn.frame.midX, y: self.view.frame.height + self.start_btn.frame.height * 3)
                    self.start_background.center = CGPoint(x: self.start_background.frame.midX, y: self.view.frame.height + self.start_background.frame.height / 2)
                },
                completion: { position in
                    self.train_icon.removeFromSuperview()
                    self.start_btn.removeFromSuperview()
                    self.start_userTeach.removeFromSuperview()
                    self.start_ownObserve.removeFromSuperview()
                    self.start_background.removeFromSuperview()
                }
            )
            
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.checkboard.alpha = 1
            self.tap = true
            
            // Rule: playing first point on center
            self.checkToPlay(column: 9, row: 9, kind: 4) // BUG: first time checkboard position is wrong(Do not know how to fix)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.checkToPlay(column: 9, row: 9, kind: 2) }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { self.StudentPlay() }
            
            // Add tap detector on CheckerBoard
            let tap_action = UILongPressGestureRecognizer(target: self, action: #selector(self.checkerBoard_tapGesture))
            tap_action.minimumPressDuration = 0
            self.checkboard.addGestureRecognizer(tap_action)
            self.checkboard.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func autoPlaying(_ sender: UIButton) {
        if !auto { auto_btn.setImage(UIImage(named: "auto_on"), for: .normal) }
        else { auto_btn.setImage(UIImage(named: "auto_off"), for: .normal) }
        auto = !auto
    }
}
