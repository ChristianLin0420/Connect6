//
//  IntroPlayingViewController.swift
//  Connect6
//
//  Created by Christian on 2019/5/29.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

class IntroPlayingViewController: UIViewController {
    
    @IBOutlet weak var ai_icon: UIImageView!
    @IBOutlet weak var user_icon: UIImageView!
    @IBOutlet weak var versus_icon: UILabel!
    @IBOutlet weak var checkboard: UIImageView!
    @IBOutlet weak var ai_winning_img: UIImageView!
    @IBOutlet weak var ai_winning_label: UILabel!
    @IBOutlet weak var user_winning_img: UIImageView!
    @IBOutlet weak var user_winning_label: UILabel!
    @IBOutlet weak var check_btn: UIButton!
    @IBOutlet weak var nextRound_btn: UIButton!
    @IBOutlet weak var finger_img: UIImageView!
    
    // File name
    let CortexProcess = Cortex()
    
    // Checkerboard
    var currentCheckerboard = Array(repeating: Array(repeating: 0, count: 19), count: 19)
    var tap = false
    var animation_chapter = 0
    
    // Temporary animation
    var symbals = [UIImageView]()
    var symbals_temporary = [UIImageView]()
    let player_winning_count_icon = ["b_win_1", "b_win_2", "b_win_3", "b_win_4", "b_win_5"]
    let AI_winning_count_icon = ["g_win_1", "g_win_2", "g_win_3", "g_win_4", "g_win_5"]
    
    // ChangePlayer
    var current_player = 0
    var continue_playing = true
    var current_x = 0
    var current_y = 0
    var AI_winning_count = 2
    var player_winning_count = 4
    var check_animate = false
    var check_alpha = 1.0
    var delta = 0.02
    var user_winning_img_animate = false
    var user_winning_alpha = 1.0
    var user_winning_delta = 0.02
    var ai_winning_img_animate = false
    var ai_winning_alpha = 1.0
    var ai_winning_delta = 0.02
    var isAnimating = true
    
    var current_opponent = 0
    var current_player_count = 2
    var check_count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap detector on CheckerBoard
        let tap_action = UILongPressGestureRecognizer(target: self, action: #selector(checkerBoard_tapGesture))
        tap_action.minimumPressDuration = 0
        checkboard.addGestureRecognizer(tap_action)
        checkboard.isUserInteractionEnabled = true
        
        // Rule: playing first point on center
        checkToPlay(column: 9, row: 9, kind: 4) // BUG: first time checkboard position is wrong(Do not know how to fix)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.user_icon.alpha = 0.3
            self.ai_icon.alpha = 1
            self.checkToPlay(column: 9, row: 9, kind: self.current_player) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.finger_animation()
            self.ai_icon.alpha = 0.3
            self.user_icon.alpha = 1
            self.versus_icon.alpha = 0.3
            self.ai_winning_img.alpha = 0.3
            self.ai_winning_label.alpha = 0.3
            self.user_winning_img.alpha = 0.3
            self.user_winning_label.alpha = 0.3
            self.check_btn.alpha = 0.3
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in self.check_animation()}
        }
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
    
    func check_animation() {
        if check_animate {
            if check_alpha < 0.3 { delta = 0.02 }
            else if check_alpha > 1 { delta = -0.02 }
            check_alpha += delta
            check_btn.alpha = CGFloat(check_alpha)
        }
        
        if user_winning_img_animate {
            if user_winning_alpha < 0.3 { user_winning_delta = 0.02 }
            else if user_winning_alpha > 1 { user_winning_delta = -0.02 }
            user_winning_alpha += user_winning_delta
            user_winning_img.alpha = CGFloat(user_winning_alpha)
        }
        
        if ai_winning_img_animate {
            if ai_winning_alpha < 0.3 { ai_winning_delta = 0.02 }
            else if ai_winning_alpha > 1 { ai_winning_delta = -0.02 }
            ai_winning_alpha += ai_winning_delta
            ai_winning_img.alpha = CGFloat(ai_winning_alpha)
        }
    }
    
    func finger_animation() {
        let (x, y) = getRandomCoordinate()
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 2.0,
            delay: 0,
            options: [],
            animations: {
                self.finger_size_animation(width_delta: 54, height_delta: 76, x: x, y: y)
            },
            completion: { position in
                self.finger_size_animation(width_delta: 30, height_delta: 40, x: x, y: y)
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.8,
                    delay: 0,
                    options: [],
                    animations: {
                        self.finger_size_animation(width_delta: 54, height_delta: 76, x: x, y: y)
                    },
                    completion: { position in
                        self.TemporaryShow(column: x, row: y)
                        
                        let x_1 = 10
                        var y_1 = 10
                        
                        if self.currentCheckerboard[10][10] != 0 { y_1 = 8 }
                        
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 2.0,
                            delay: 0,
                            options: [],
                            animations: {
                                self.finger_size_animation(width_delta: 54, height_delta: 76, x: x_1, y: y_1)
                            },
                            completion: { position in
                                self.finger_size_animation(width_delta: 30, height_delta: 40, x: x_1, y: y_1)
                                UIViewPropertyAnimator.runningPropertyAnimator(
                                    withDuration: 0.8,
                                    delay: 0,
                                    options: [],
                                    animations: {
                                        self.finger_size_animation(width_delta: 54, height_delta: 76, x: x_1, y: y_1)
                                    },
                                    completion: { position in
                                        self.TemporaryShow(column: x_1, row: y_1)
                                        let group = DispatchGroup()
                                        group.enter()
                                        
                                        DispatchQueue.main.async {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                self.check_btn.alpha = 1.0
                                                self.check_alpha = 1.0
                                                self.check_animate = true
                                            }
                                            group.leave()
                                        }
                                        
                                        group.notify(queue: .main) {
                                            UIViewPropertyAnimator.runningPropertyAnimator(
                                                withDuration: 2.0,
                                                delay: 0,
                                                options: [],
                                                animations: {
                                                    self.check_size_animation(width_delta: 54, height_delta: 76)
                                                },
                                                completion: { position in
                                                    self.check_size_animation(width_delta: 30, height_delta: 40)
                                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                                        withDuration: 0.8,
                                                        delay: 0,
                                                        options: [],
                                                        animations: {
                                                            self.check_size_animation(width_delta: 54, height_delta: 76)
                                                        },
                                                        completion: { position in
                                                            self.checkToPlay(column: x_1, row: y_1, kind: 1)
                                                    })
                                            })
                                        }
                                })
                        })
                })
        })
    }
    
    func getRandomCoordinate() -> (Int, Int) {
        let array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 16, 17, 18]
        var x = array.randomElement()
        var y = array.randomElement()
        
        while currentCheckerboard[x!][y!] != 0 {
            x = array.randomElement()
            y = array.randomElement()
        }
        
        return(x!, y!)
    }
    
    func check_size_animation(width_delta: Int, height_delta: Int) {
        finger_img.frame = CGRect(
            x: self.check_btn.frame.midX,
            y: self.check_btn.frame.midY,
            width: checkboard.frame.width * CGFloat(width_delta) / CGFloat(375),
            height: checkboard.frame.height * CGFloat(height_delta) / CGFloat(375))
    }
    
    func finger_size_animation(width_delta: Int, height_delta: Int, x: Int, y: Int) {
        finger_img.frame = CGRect(
            x: checkboard.frame.size.width * (CGFloat(x) + CGFloat(0.5)) / 19 + self.checkboard.frame.minX,
            y: checkboard.frame.size.height * (CGFloat(y) + CGFloat(0.5)) / 19 + self.checkboard.frame.minY,
            width: checkboard.frame.width * CGFloat(width_delta) / CGFloat(375),
            height: checkboard.frame.height * CGFloat(height_delta) / CGFloat(375))
    }
    
    func checkToPlay(column: Int, row: Int, kind: Int) {
        
        check_animate = false
        
        if kind == 0 || kind == 1 {
            if continue_playing == false { return }
        }
        
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
        
        if (check_exist), kind == 0 {
            currentCheckerboard[row][column] = 1
            for image in symbals_temporary { image.removeFromSuperview() }
            let new_symbal = UIImageView(image: blue_images)
            
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
            continue_playing = false
            user_icon.alpha = 0.3
            ai_icon.alpha = 1.0
            let (winningState, winning_pattern) = CortexProcess.detectWinning(currentBoard: currentCheckerboard)
            showResult(winner: winningState, winning_pattern: winning_pattern)
            
            check_count += 1
            
            if check_count != 361 {
                if current_player_count == 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.OpponentPlaying()
                    }
                } else if current_player_count == 2 {
                    current_player = 1
                    ai_icon.alpha = 0.3
                    user_icon.alpha = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        if self.isAnimating {
                            self.finger_img.isHidden = false
                            self.finger_animation()
                        } else {
                            self.tap = true
                            self.userPredicting()
                        }
                    }
                }
                
                current_player_count += 1
            }
        } else if (check_exist), kind == 1 {
            currentCheckerboard[row][column] = -1
            for image in symbals_temporary { image.removeFromSuperview() }
            let new_symbal = UIImageView(image: green_image)
            new_symbal.frame = CGRect(x: CGFloat(x) + checkboard.frame.minX, y: CGFloat(y) + checkboard.frame.minY, width: symbal_width, height: symbal_height)
            symbals.append(new_symbal)
            self.view.addSubview(new_symbal)
            continue_playing = false
            ai_icon.alpha = 0.3
            user_icon.alpha = 1.0
            let (winningState, winning_pattern) = CortexProcess.detectWinning(currentBoard: currentCheckerboard)
            showResult(winner: winningState, winning_pattern: winning_pattern)
            
            check_count += 1
            
            if check_count != 361 {
                if current_player_count == 3 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.current_player_count += 1
                        if self.isAnimating { self.finger_animation() }
                        else { self.userPredicting() }
                    }
                } else if current_player_count == 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.current_player_count = 1
                        self.finger_img.isHidden = true
                        self.isAnimating = false
                        self.tap = false
                        self.OpponentPlaying()
                    }
                }
            }
            
        } else if (!check_exist), kind == 1 {
            for image in symbals_temporary { image.removeFromSuperview() }
            OpponentPlaying()
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
        }
    }
    
    func TemporaryShow(column: Int, row: Int) {
        
        if currentCheckerboard[row][column] != 0 { return }
        else { check_btn.isEnabled = true }
        
        user_icon.alpha = 1.0
        
        var current_checkerboard_count = 0
        for i in 0...18 {
            for j in 0...18 {
                if self.currentCheckerboard[i][j] != 0 { current_checkerboard_count += 1 }
            }
        }
        
        if current_checkerboard_count != 2 {
            check_btn.alpha = 1.0
            check_alpha = 1.0
            check_animate = true
        }
        
        for image in symbals_temporary { image.removeFromSuperview() }
        
        let blue_images = [UIImage(named: "green_dot")!, UIImage(named: "green_dot_1")!, UIImage(named: "green_dot_2")!, UIImage(named: "green_dot_3")!, UIImage(named: "green_dot_4")!]
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
    
    func OpponentPlaying() {
        var opposite_currentboard = Array(repeating: Array(repeating: 0, count: 19), count: 19)
        for i in 0...18 {
            for j in 0...18 {
                if currentCheckerboard[i][j] == 1 { opposite_currentboard[i][j] = -1 }
                else if currentCheckerboard[i][j] == -1 { opposite_currentboard[i][j] = 1 }
            }
        }
        
        let (next_y, next_x) = CortexProcess._CortexDetect(currentBoard: opposite_currentboard, person: current_opponent)
        
        if (next_y, next_x) != (-1, -1) {
            checkToPlay(column: next_x, row: next_y, kind: 0)
            return
        }
        
        var random_array = [Int]()
        for i in 0...18 {
            for j in 0...18 {
                if currentCheckerboard[i][j] == 0 { random_array.append(i + j * 19) }
            }
        }
        
        let random_play = random_array.randomElement()
        let random_column = random_play! % 19
        let random_row = random_play! / 19
        
        checkToPlay(column: random_column, row: random_row, kind: 0)
    }
    
    func userPredicting() {
        let (predicted_y, predicted_x) = CortexProcess._CortexDetect(currentBoard: currentCheckerboard, person: current_opponent)
        
        if (predicted_y, predicted_x) != (-1, -1) {
            TemporaryShow(column: predicted_x, row: predicted_y)
            return
        }
        
        var random_array = [Int]()
        for i in 0...18 {
            for j in 0...18 {
                if currentCheckerboard[i][j] == 0 { random_array.append(i + j * 19) }
            }
        }
        
        let random_play = random_array.randomElement()
        let random_column = random_play! % 19
        let random_row = random_play! / 19
        
        TemporaryShow(column: random_column, row: random_row)
    }
    
    func showResult(winner: Int, winning_pattern: [[Int]]) {
        if winner == 1 {
            if player_winning_count != 5 {
                player_winning_count += 1
                continue_playing = false
                user_winning_img.image = UIImage(named: player_winning_count_icon[player_winning_count - 1])
            }
            if player_winning_count == 5 {
                user_icon.alpha = 1.0
                ai_icon.alpha = 0.3
                check_btn.isHidden = true
                nextRound_btn.isHidden = false
                user_winning_img.alpha = 1.0
                user_winning_img_animate = true
                user_winning_alpha = 1.0
                for coordination in winning_pattern { checkToPlay(column: coordination[1], row: coordination[0], kind: 2) }
            } else {
                for coordination in winning_pattern { checkToPlay(column: coordination[1], row: coordination[0], kind: 2) }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { self.resetAll() }
            }
        } else if winner == -1 {
            if AI_winning_count != 5 {
                AI_winning_count += 1
                continue_playing = false
                ai_winning_img.image = UIImage(named: AI_winning_count_icon[AI_winning_count - 1])
            }
            if AI_winning_count == 5 {
                user_icon.alpha = 0.3
                ai_icon.alpha = 1.0
                check_btn.isHidden = true
                nextRound_btn.isHidden = false
                ai_winning_img.alpha = 1.0
                ai_winning_img_animate = true
                ai_winning_alpha = 1.0
                for coordination in winning_pattern { checkToPlay(column: coordination[1], row: coordination[0], kind: 3) }
            } else {
                for coordination in winning_pattern { checkToPlay(column: coordination[1], row: coordination[0], kind: 3) }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { self.resetAll() }
            }
        } else {
            continue_playing = true
        }
    }
    
    func resetAll() {
        for dot in symbals { dot.removeFromSuperview() }
        for i in 0...18 {
            for j in 0...18 {
                currentCheckerboard[i][j] = 0
            }
        }
        
        isAnimating = true
        continue_playing = true
        
        if player_winning_count + AI_winning_count >= 5 {
            current_player = 0
            current_player_count = 4
            checkToPlay(column: 9, row: 9, kind: 1)
        } else {
            current_player = 1
            current_player_count = 2
            checkToPlay(column: 9, row: 9, kind: 0)
        }
    }
    
    @IBAction func checkToPlay(_ sender: UIButton) {
        checkToPlay(column: self.current_x, row: self.current_y, kind: self.current_player)
        current_player = 1
        check_btn.isEnabled = false
//        let (winningState, _) = self.CortexProcess.detectWinning(currentBoard: self.currentCheckerboard)
        
        check_animate = false
        check_btn.alpha = 0.3
        check_alpha = 1.0
    }
    
    @IBAction func nextRoundStart(_ sender: UIButton) {
        user_icon.alpha = 1.0
        ai_icon.alpha = 0.3
        user_winning_img_animate = false
        user_winning_delta = 1.0
        user_winning_img.alpha = 0.3
        ai_winning_img.alpha = 0.3
        continue_playing = true
        current_player = 0
        AI_winning_count = 0
        player_winning_count = 0
        user_winning_img.image = UIImage(named: "win_0")
        ai_winning_img.image = UIImage(named: "win_0")
        resetAll()
        nextRound_btn.isHidden = true
        check_btn.isHidden = false
    }
}
