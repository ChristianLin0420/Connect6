//
//  AnimationPlayingViewController.swift
//  Connect6
//
//  Created by Christian on 2019/5/30.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

class AnimationPlayingViewController: UIViewController {

    // UI elements
    @IBOutlet weak var Playing_btn: UIButton!
    @IBOutlet weak var Trainning_btn: UIButton!
    @IBOutlet weak var versus_animation: UIImageView!
    @IBOutlet weak var trainning_animation: UIImageView!
    @IBOutlet weak var back_btn: UIButton!
    @IBOutlet weak var back_ground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let versus_tap = UILongPressGestureRecognizer(target: self, action: #selector(moveToIntroVersus))
        versus_tap.minimumPressDuration = 0.0
        Playing_btn.addGestureRecognizer(versus_tap)
        Playing_btn.isUserInteractionEnabled = true
        
        let train_tap = UILongPressGestureRecognizer(target: self, action: #selector(moveToIntroTrain(gesture:)))
        train_tap.minimumPressDuration = 0
        Trainning_btn.addGestureRecognizer(train_tap)
        Trainning_btn.isUserInteractionEnabled = true
        
    }
    
    @objc func moveToIntroVersus(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            back_btn.isHidden = true
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1.2,
                delay: 0,
                options: [],
                animations: {
                    self.versus_animation.center = self.view.center
                    self.Playing_btn.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 3.0)
                    self.Trainning_btn.center = CGPoint(x: self.trainning_animation.frame.midX, y: self.view.frame.height * 1.25 )
                    self.trainning_animation.center = CGPoint(x: self.trainning_animation.frame.midX, y: self.view.frame.height * 1.25 )
                },
                completion: { position in
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 2,
                        delay: 0,
                        options: [],
                        animations: {
                            self.Playing_btn.center = CGPoint(x: self.Playing_btn.frame.midX, y: self.view.frame.height * 2)
                            self.versus_animation.center = CGPoint(x: self.versus_animation.frame.midX, y: self.versus_animation.frame.height + self.view.frame.height)
                        },
                        completion: { position in
                            self.Playing_btn.isHidden = true
                            self.versus_animation.isHidden = true
                            self.performSegue(withIdentifier: "intro_versus", sender: self)
                    })
                }
            )
        default:
            break
        }
    }
    
    @objc func moveToIntroTrain(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            back_btn.isHidden = true
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1.2,
                delay: 0,
                options: [],
                animations: {
                    self.trainning_animation.center = self.view.center
                    self.Trainning_btn.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 3.1)
                    self.Playing_btn.center = CGPoint(x: self.Playing_btn.frame.midX, y: -self.view.frame.height * 0.26 )
                    self.versus_animation.center = CGPoint(x: self.versus_animation.frame.midX, y: -self.view.frame.height * 0.26 )
            },
                completion: { position in
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 2,
                        delay: 0,
                        options: [],
                        animations: {
                            self.Trainning_btn.center = CGPoint(x: self.Trainning_btn.frame.midX, y: -self.view.frame.height * 2)
                            self.trainning_animation.center = CGPoint(x: self.trainning_animation.frame.midX, y: -self.trainning_animation.frame.height * 2.5)
                        },
                        completion: { position in
                            self.Trainning_btn.isHidden = true
                            self.trainning_animation.isHidden = true
                            self.performSegue(withIdentifier: "intro_train", sender: self)
                    })
            }
            )
        default:
            break
        }
    }
    
    @IBAction func backToMenu(_ sender: UIButton) {
        performSegue(withIdentifier: "backMenu", sender: self)
    }
}
