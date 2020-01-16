//
//  GameViewController.swift
//  Connect6
//
//  Created by Christian on 2019/5/25.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // File name
    private let CortexProcess = Cortex()
    private let SpecialPatternsProcess = SpecialPatterns()
    private let TrainProcess = TrainningViewController()

    // UI elements
    @IBOutlet weak var checkboard: UIImageView!
    @IBOutlet weak var AI_score: UIImageView!
    @IBOutlet weak var player_score: UIImageView!
    @IBOutlet weak var Check: UIButton!
    @IBOutlet weak var next_round_btn: UIButton!
    @IBOutlet weak var P1_icon: UIImageView!
    @IBOutlet weak var P2_icon: UIImageView!
    @IBOutlet weak var P1_current_name: UILabel!
    @IBOutlet weak var P2_current_name: UILabel!
    @IBOutlet weak var auto_btn: UIButton!
    @IBOutlet weak var teachingBtn: UIButton!
    @IBOutlet weak var watchingBtn: UIButton!
    
    // winning coefficient
    private var AI_winning_count = 0
    private var player_winning_count = 0
    private var continue_playing = true
    private let player_winning_count_icon = ["b_win_1", "b_win_2", "b_win_3", "b_win_4", "b_win_5"]
    private let AI_winning_count_icon = ["g_win_1", "g_win_2", "g_win_3", "g_win_4", "g_win_5"]
    
    // Temporary animation
    private var symbals = [UIImageView]()
    private var symbals_temporary = [UIImageView]()
    private var suggestion_symbals_collecion = [UIImageView]()
    
    // ChangePlayer
    var current_player = 1
    private var round_number = 2
    private var current_x = 0
    private var current_y = 0
    
    // Checkerboard
    private var currentCheckerboard = Array(repeating: Array(repeating: 0, count: 19), count: 19)
    private var LearningCheckerboard = Array(repeating: Array(repeating: 0, count: 19), count: 19)
    private var tap = false
    private var checkCount = 0
    
    // Playsers
    var P1_icon_img = UIImage(named: "User")
    var P1_name: String? = "Christian"
    var P2_icon_img = UIImage(named: "opponent_1")
    var P2_name: String? = "Julia"
    var current_user = 1
    var current_opponent = 0
    private var watch = false
    private var teach = false
    private var auto = false
    
    // Learning coefficient
    private var student_predict_teach_origin_x = 0
    private var student_predict_teach_origin_y = 0
    private var student_predict_teach_final_x = 0
    private var student_predict_teach_final_y = 0
    
    // Cortex array
    private let CortexUD = UserDefaults.standard
    private var cortex_array = [[[Int]]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        P1_icon.image = P1_icon_img
        P2_icon.image = P2_icon_img
        P1_current_name.text = P1_name
        P2_current_name.text = P2_name
        
        // Add tap detector on CheckerBoard
        let tap_action = UILongPressGestureRecognizer(target: self, action: #selector(checkerBoard_tapGesture))
        tap_action.minimumPressDuration = 0
        checkboard.addGestureRecognizer(tap_action)
        checkboard.isUserInteractionEnabled = true
        
        // Rule: playing first point on center
        checkToPlay(column: 9, row: 9, kind: 6) // BUG: first time checkboard position is wrong(Do not know how to fix)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.checkToPlay(column: 9, row: 9, kind: 0) }
    }
    
    @objc func checkerBoard_tapGesture(gesture: UITapGestureRecognizer) {
        if tap == true {
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
                
                if x_number < 19 && y_number < 19 { TemporaryShow(column: x_number, row: y_number) }
            }
        }
    }
    
    func checkToPlay(column: Int, row: Int, kind: Int) {
        
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
        let blue_winning = UIImage(named: "blue_winning")!
        let green_winning = UIImage(named: "green_winning")!
        let x = Double(checkboard.frame.size.width ) * Double(column) / 19
        let y = Double(checkboard.frame.size.height ) * Double(row) / 19
        let symbal_width = CGFloat(checkboard.frame.size.width) * 0.99 / 19.5
        let symbal_height = CGFloat(checkboard.frame.size.height) * 0.99 / 19.5
        
        var check_exist = true
        if currentCheckerboard[row][column] != 0 { check_exist = false }
        
        if !check_exist { print("this place has dot alreday!!") }
        
        if (check_exist), kind == 0 {
            currentCheckerboard[row][column] = 1
            
            if watch == true {
                student_predict_teach_final_x = column
                student_predict_teach_final_y = row
                LearningCheckerboard = currentCheckerboard
                LearningMode()
            }
            
            for image in symbals_temporary { image.removeFromSuperview() }
            let new_symbal = UIImageView(image: blue_images)
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
            continue_playing = false
            let (winningState, winning_pattern) = CortexProcess.detectWinning(currentBoard: currentCheckerboard)
            showResult(winner: winningState, winning_pattern: winning_pattern)
            
            if winningState != 0 { return }
            
            checkCount += 1
            
            if checkCount != 361 {
                if round_number == 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.round_number += 1
                        self.TeacherPlayAutomatically()
                        self.tap = true
                    } // automatically predict where to set the chess
                } else if round_number == 2 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if winningState == 0 {
                            self.current_player = 1
                            self.round_number += 1
                            self.StudentPlay()
                        }
                    }
                }
            } else {
                showTieResult()
            }
        } else if (!check_exist), kind == 0 {
            if auto == false {
                for image in symbals_temporary { image.removeFromSuperview() }
            }
            TeacherPlayAutomatically()
        } else if (check_exist), kind == 1 {
            currentCheckerboard[row][column] = -1
            for image in symbals_temporary { image.removeFromSuperview() }
            let new_symbal = UIImageView(image: green_image)
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
            continue_playing = false
            let (winningState, winning_pattern) = CortexProcess.detectWinning(currentBoard: currentCheckerboard)
            showResult(winner: winningState, winning_pattern: winning_pattern)
            
            if winningState != 0 { return }
            
            checkCount += 1
            
            if checkCount != 361 {
                if round_number == 3 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.round_number += 1
                        self.StudentPlay()
                    }
                } else if round_number == 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.current_player = 0
                        self.round_number = 1
                        self.tap = true
                        self.TeacherPlayAutomatically()
                    }
                }
            } else {
                showTieResult()
            }
        } else if (!check_exist), kind == 1 {
            for image in symbals_temporary { image.removeFromSuperview() }
            StudentPlay()
        } else if (!check_exist), kind == 2 {
            //print("blue_winning")
            let new_symbal = UIImageView(image: blue_winning)
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
        } else if (!check_exist), kind == 3 {
            //print("green_winning")
            let new_symbal = UIImageView(image: green_winning)
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
        } else if kind == 4 {
            currentCheckerboard[row][column] = 1
            let new_symbal = UIImageView(image: blue_images)
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
        } else if kind == 5 {
            currentCheckerboard[row][column] = -1
            let new_symbal = UIImageView(image: green_image)
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
        }
    }

    func TemporaryShow(column: Int, row: Int) {
        
        if currentCheckerboard[row][column] != 0 { return }
        else { Check.isEnabled = true }
        
        for image in symbals_temporary { image.removeFromSuperview() }
        
        let blue_images = [UIImage(named: "blue_dot")!, UIImage(named: "blue_dot_1")!, UIImage(named: "blue_dot_2")!, UIImage(named: "blue_dot_3")!, UIImage(named: "blue_dot_4")!]
        let x = Double(checkboard.frame.size.width ) * Double(column) / 19
        let y = Double(checkboard.frame.size.height ) * Double(row) / 19
        let symbal_width = CGFloat(checkboard.frame.size.width) * 0.99 / 19.5
        let symbal_height = CGFloat(checkboard.frame.size.height) * 0.99 / 19.5
        
        let animatedImage = UIImage.animatedImage(with: blue_images, duration: 0.5)
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
                if currentCheckerboard[i][j] == 1 { opposite_currentboard[i][j] = -1 }
                else if currentCheckerboard[i][j] == -1 { opposite_currentboard[i][j] = 1 }
            }
        }
        
        var (next_y, next_x) = (0, 0)
        var (suggested_x_collection, suggested_y_collection, suggestionStatus) = ([0], [0], "")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            (next_y, next_x) = self.CortexProcess._CortexDetect(currentBoard: opposite_currentboard, person: self.current_user)
            (suggested_x_collection, suggested_y_collection, suggestionStatus) = self.SpecialPatternsProcess.SearchingSuggestionArray(originalArray: opposite_currentboard)
            if suggestionStatus != "empty" { self.drawSuggestionPattern(suggestionStatus: suggestionStatus, x_coordinateColleciont: suggested_x_collection, y_coordinateCollections: suggested_y_collection, player: "student") } // drawing alert coordinates
            group.leave()
        }
        
        group.notify(queue: .main) {
            if (next_y, next_x) != (-1, -1) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { self.checkToPlay(column: next_x, row: next_y, kind: 1) })
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { self.checkToPlay(column: random_column, row: random_row, kind: 1) })
            
            random_array.removeAll()
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
        
        print("--------------------------")
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            self.tap = false
            self.studentPredictTeacherStep()
            (predicted_y, predicted_x) = self.CortexProcess._CortexDetect(currentBoard: self.currentCheckerboard, person: self.current_opponent)
            (suggested_x_collection, suggested_y_collection, suggestionStatus) = self.SpecialPatternsProcess.SearchingSuggestionArray(originalArray: self.currentCheckerboard)
            if suggestionStatus != "empty" { self.drawSuggestionPattern(suggestionStatus: suggestionStatus, x_coordinateColleciont: suggested_x_collection, y_coordinateCollections: suggested_y_collection, player: "teacher") } // drawing alert coordinates
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.tap = true
            
            if (predicted_y, predicted_x) != (-1, -1) {
                if self.watch {
                    self.student_predict_teach_final_x = predicted_x
                    self.student_predict_teach_final_y = predicted_y
                }
                
                if self.teach {
                    print("start to correct student strategy!!!")
                } else {
                    print("do nothing!!!!!")
                }
                
                if self.auto == true {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { self.checkToPlay(column: predicted_x, row: predicted_y, kind: 0) })
                } else {
                    self.TemporaryShow(column: predicted_x, row: predicted_y)
                }
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
            
            if self.watch {
                self.student_predict_teach_final_x = random_column
                self.student_predict_teach_final_y = random_row
            }
            
            if self.teach {
                print("start to correct student strategy")
            } else {
                print("do nothing")
            }
            
            if self.auto == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { self.checkToPlay(column: random_column, row: random_row, kind: 0) })
            } else {
                self.TemporaryShow(column: random_column, row: random_row)
            }
            
            random_array.removeAll()
        }
    }
    
    func LearningMode() {
        if student_predict_teach_final_x == student_predict_teach_origin_x, student_predict_teach_final_y == student_predict_teach_origin_y, watch, current_player == 0 { return }
        
        var studentWatchingTeacher_eight_direction_array = [[Int]]()
        var studentWatchingTeacher_eight_direction_array_for_previous = [[Int]]()
        
        if watch, current_player == 0 {
            print("student is watching teacher")
            print("student_predict_teach_final_x = \(student_predict_teach_final_x)")
            print("student_predict_teach_final_y = \(student_predict_teach_final_y)")
            print("student_predict_teach_origin_x = \(student_predict_teach_origin_x)")
            print("student_predict_teach_origin_y = \(student_predict_teach_origin_y)")
            
            studentWatchingTeacher_eight_direction_array = CortexProcess.createDirectionArray(currentBoard: CortexProcess.createScanArray(currentBoard: LearningCheckerboard, center_y: student_predict_teach_final_y, center_x: student_predict_teach_final_x))
            
            studentWatchingTeacher_eight_direction_array_for_previous = CortexProcess.createDirectionArray(currentBoard: CortexProcess.createScanArray(currentBoard: LearningCheckerboard, center_y: student_predict_teach_origin_y, center_x: student_predict_teach_origin_x))
            
            TrainProcess.getting4DirectionArray(final_array: studentWatchingTeacher_eight_direction_array, previous: studentWatchingTeacher_eight_direction_array_for_previous, student_numb: current_user)
        }
    }
    
    func studentPredictTeacherStep() {
        print("studentPredictTeacherStep before")
        if !watch { return }
        print("studentPredictTeacherStep enter")
        
        let (student_y, student_x) = CortexProcess._CortexDetect(currentBoard: currentCheckerboard, person: current_user)
        
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
    
    func showTieResult() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { self.resetAll() }
    }
    
    func showResult(winner: Int, winning_pattern: [[Int]]) {
        if winner == 1 {
            player_winning_count += 1
            continue_playing = false
            player_score.image = UIImage(named: player_winning_count_icon[player_winning_count - 1])
            for coordination in winning_pattern { checkToPlay(column: coordination[1], row: coordination[0], kind: 2) }
            
            if player_winning_count < 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { self.resetAll() }
            } else if player_winning_count == 5 {
                Check.isHidden = true
                next_round_btn.isHidden = false
            }
        } else if winner == -1 {
            AI_winning_count += 1
            continue_playing = false
            AI_score.image = UIImage(named: AI_winning_count_icon[AI_winning_count - 1])
            for coordination in winning_pattern { checkToPlay(column: coordination[1], row: coordination[0], kind: 3) }
            
            if AI_winning_count < 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { self.resetAll() }
            } else if AI_winning_count == 5 {
                Check.isHidden = true
                next_round_btn.isHidden = false
            }
        } else {
            continue_playing = true
        }
    }
    
    func resetAll() {
        checkCount = 0
        continue_playing = true
        
        for dot in suggestion_symbals_collecion { dot.removeFromSuperview() }
        for dot in symbals { dot.removeFromSuperview() }
        suggestion_symbals_collecion.removeAll()
        symbals.removeAll()
        
        for i in 0...18 {
            for j in 0...18 {
                currentCheckerboard[i][j] = 0
            }
        }

        if player_winning_count + AI_winning_count < 5 {
            round_number = 2
            current_player = 0
        } else {
            round_number = 4
            current_player = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.checkToPlay(column: 9, row: 9, kind: self.current_player) }
    }
    
    @IBAction func nextRountStart(_ sender: Any) {
        AI_winning_count = 0
        player_winning_count = 0
        player_score.image = UIImage(named: "win_0")
        AI_score.image = UIImage(named: "win_0")
        next_round_btn.isHidden = true
        Check.isHidden = false
        resetAll()
    }
    
    @IBAction func checkToPlay(_ sender: Any) {
        tap = false
        checkToPlay(column: self.current_x, row: self.current_y, kind: 0)
        current_player = 1
        Check.isEnabled = false
    }
    
    @IBAction func autoPlaying(_ sender: UIButton) {
        if auto == false { auto_btn.setImage(UIImage(named: "auto_on"), for: .normal) }
        else { auto_btn.setImage(UIImage(named: "auto_off"), for: .normal) }
        auto = !auto
    }
    
    @IBAction func SecrectlyLearningOpponent(_ sender: Any) {
        if watch { watchingBtn.setImage(UIImage(named: "LearnbyOwn_off"), for: .normal) }
        else { watchingBtn.setImage(UIImage(named: "LearnbyOwn_on"), for: .normal) }
        watch = !watch
    }
    
    @IBAction func stopToTeachStudent(_ sender: UIButton) {
        if teach { teachingBtn.setImage(UIImage(named: "pause"), for: .normal) }
        else { teachingBtn.setImage(UIImage(named: "continue"), for: .normal) }
        teach = !teach
    }
    
    @IBAction func backToSelect(_ sender: UIButton) {
        watch = false
        auto = false
    }
}
