//
//  placeholder.swift
//  pulsar
//
//  Created by Ali El Ali on 8/12/2024.
//

import UIKit

public class PulseView: UIView {
    private var animationLayer: CAShapeLayer?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
    
    public func startPulsing(duration: TimeInterval = 1.5, repeatCount: Float = .infinity, color: UIColor = .blue) {
        animationLayer?.removeFromSuperlayer()
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        circleLayer.fillColor = color.cgColor
        circleLayer.opacity = 0
        layer.addSublayer(circleLayer)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 1.5
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.8
        opacityAnimation.toValue = 0
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [scaleAnimation, opacityAnimation]
        groupAnimation.duration = duration
        groupAnimation.repeatCount = repeatCount
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        circleLayer.add(groupAnimation, forKey: "pulse")
        animationLayer = circleLayer
    }
    
    public func stopPulsing() {
        animationLayer?.removeFromSuperlayer()
        animationLayer = nil
    }
}
