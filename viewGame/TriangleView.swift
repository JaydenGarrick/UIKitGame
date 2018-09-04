//
//  TriangleView.swift
//  viewGame
//
//  Created by Jayden Garrick on 9/4/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class TriangleView: UIView {
    let colors: [UIColor] = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.697325338, blue: 0.0004205528421, alpha: 1), #colorLiteral(red: 1, green: 0.9728834899, blue: 0, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()
//        let randomColor = self.colors[Int(self.randomNumberInRange(min: 0, max: CGFloat(self.colors.count - 1)))]

        context.setFillColor(UIColor.black.cgColor)
        context.fillPath()
    }
    
    func randomNumberInRange(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(max - min + 1))) + min
    }

}
