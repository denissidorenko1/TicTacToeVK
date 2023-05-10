//
//  Cell.swift
//  TicTacToeVK
//
//  Created by Denis on 09.05.2023.
//

import UIKit

class Cell: UIView {
    var currentState: State = .blank
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
    }
    
    private func addCircle() {
        let circleLayer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: frame.width*0.4,
                                  startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        circleLayer.path = path.cgPath
        circleLayer.strokeColor = UIColor.green.cgColor
        circleLayer.lineWidth = 10
        circleLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(circleLayer)
    }
    
    private func addCross() {
        let crossLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 10))
        path.addLine(to: CGPoint(x: bounds.width-10, y: bounds.height-10))
        path.close()
        path.move(to: CGPoint(x: bounds.width-10, y: 10))
        path.addLine(to: CGPoint(x: 10, y: bounds.height-10))
        path.close()
        crossLayer.path = path.cgPath
        crossLayer.strokeColor = UIColor.red.cgColor
        crossLayer.lineWidth = 10
        layer.addSublayer(crossLayer)
    }
    
    public func switchState(new state: State) {

        currentState = state
        switch state {
        case .circle:
            addCircle()
        case .cross:
            addCross()
        case .blank:
            self.layer.sublayers?.popLast()
        }
    }
}
