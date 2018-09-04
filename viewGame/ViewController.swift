//
//  ViewController.swift
//  viewGame
//
//  Created by Jayden Garrick on 9/4/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    let colors: [UIColor] = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.697325338, blue: 0.0004205528421, alpha: 1), #colorLiteral(red: 1, green: 0.9728834899, blue: 0, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)]
    var timeInterval: Double = 5
    var score = 0
    var bullet: TriangleView?
    var index = 0
    let tapGestureForRestart = UITapGestureRecognizer(target: self, action: #selector(restartGame))
    
    let imageViewAvatar: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "xcaFrank")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score: 0"
        return label
    }()
    
    let wastedImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "xcaWasted")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureForRestart.delegate = self
        self.view.subviews.forEach { $0.isUserInteractionEnabled = true }
        generateFallingViews()
        setConstraints()
        changeBackgroundColor()
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (_) in
            guard let bulletPresentationLayer = self.bullet?.layer.presentation()?.frame,
                let avatarPresentationLayer = self.imageViewAvatar.layer.presentation()?.frame else { return }
            if bulletPresentationLayer.intersects(avatarPresentationLayer) {
                self.view.subviews.forEach{ $0.layer.removeAllAnimations() }
                self.wastedImageView.isHidden = false
                self.view.addSubview(self.wastedImageView)
                self.wastedImageView.addGestureRecognizer(self.tapGestureForRestart)
                self.wastedImageView.frame = self.view.frame
            }
        }
    }
    
    // MARK: - SetupFunctions
    func setConstraints() {
        view.addSubview(scoreLabel)
        view.addSubview(imageViewAvatar)
        
        // ImageView
        imageViewAvatar.layer.cornerRadius = 50
        imageViewAvatar.frame = CGRect(x: 150, y: 550, width: 100, height: 100)
        
        // Label
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        scoreLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        
        // Rainbow SeperatorView
        let rainbowSeperatorView = UIView()
        rainbowSeperatorView.backgroundColor = .black
        view.addSubview(rainbowSeperatorView)
        rainbowSeperatorView.frame = CGRect(x: 0, y: 500, width: view.frame.width, height: 5)
    }
    
    // MARK: - Generating views
    func generateFallingViews() {
        let generatedView = generateRandomView()
        bullet = generatedView
        self.view.addSubview(generatedView)
        animateFallingViews(inputView: generatedView)
    }
    
    func animateFallingViews(inputView: UIView) {
        inputView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        UIView.animate(withDuration: timeInterval, delay: 0, options: [.allowUserInteraction], animations: {
            let xAxis = inputView.frame.origin.x
            let yAxis: CGFloat = self.view.frame.maxY
            inputView.frame = CGRect(x: xAxis, y: yAxis, width: 50, height: 50)
        }) { (success) in
            if success {
                self.timeInterval -= 0.25
                self.score += 1
                self.scoreLabel.text = "Score: \(self.score)"
                let generatedView = self.generateRandomView()
                self.bullet = nil
                self.bullet = generatedView
                self.view.addSubview(generatedView)
                self.animateFallingViews(inputView: generatedView)
            }
        }
        
    }
    
    // MARK: - Restart
    @objc func restartGame() {
        print("Restarting")
    }
    
    // MARK: - Helper Function
    func randomNumberInRange(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(max - min + 1))) + min
    }
    
    func generateRandomView() -> TriangleView {
        let generatedView = TriangleView()
        let xAxis = self.randomNumberInRange(min: self.view.frame.minX, max: self.view.frame.maxX)
        generatedView.frame = CGRect(x: xAxis, y: 0, width: 50, height: 50)
        generatedView.backgroundColor = .clear
        return generatedView
    }
    
    func changeBackgroundColor() {
        UIView.animate(withDuration: 1.5, delay: 0, options: [.allowUserInteraction], animations: {
            if self.index > self.colors.count - 1 {
                self.index = 1
                self.view.backgroundColor = .red
            } else {
                self.view.backgroundColor = self.colors[self.index]
                self.index += 1
            }
        }) { (success) in
            self.changeBackgroundColor()
        }
    }
    
    // MARK: - Touches
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.25) {
            let touchPoint = touches.first!.location(in: self.view)
            if touchPoint.y < 500 {
                self.imageViewAvatar.frame = CGRect(x: touchPoint.x, y: 500, width: 100, height: 100)
            } else {
                self.imageViewAvatar.frame = CGRect(x: touchPoint.x, y: touchPoint.y, width: 100, height: 100)
            }
        }
    }
    
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        wastedImageView.isHidden = true
        score = 0
        timeInterval = 5.0
        generateFallingViews()
        return true
    }
}

