import UIKit

public class PulseView: UIView {
    private var animationLayers: [CAShapeLayer] = []
    
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
        print("PulseView initialized with frame: \(frame)")
    }
    
    public func startPulsing(duration: TimeInterval = 1.5, repeatCount: Float = .infinity, color: UIColor = .blue) {
        stopPulsing()
        
        let numberOfRipples = 5
        let delay = duration / Double(numberOfRipples)
        
        print("Starting pulse animation with duration: \(duration), color: \(color)")
        
        for i in 0..<numberOfRipples {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * delay) {
                self.createRipple(duration: duration, color: color)
            }
        }
    }
    
    private func createRipple(duration: TimeInterval, color: UIColor) {
        let rippleLayer = CAShapeLayer()
        rippleLayer.bounds = bounds
        rippleLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        rippleLayer.fillColor = nil // Remove fill color
        rippleLayer.strokeColor = color.cgColor // Add stroke color
        rippleLayer.lineWidth = 2 // Add line width
        rippleLayer.opacity = 1 // Make fully opaque
        rippleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        layer.addSublayer(rippleLayer)
        
        let animation = CAAnimationGroup()
        animation.animations = [createScaleAnimation(), createOpacityAnimation()]
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        rippleLayer.add(animation, forKey: "ripple")
        animationLayers.append(rippleLayer)
        
        print("Ripple created with duration: \(duration)")
    }
    
    private func createScaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.1
        scaleAnimation.toValue = 1.0 // Reduce max scale to fit within view
        return scaleAnimation
    }
    
    private func createOpacityAnimation() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [1, 0.5, 0] // Start fully opaque
        opacityAnimation.keyTimes = [0, 0.5, 1]
        return opacityAnimation
    }
    
    public func stopPulsing() {
        for layer in animationLayers {
            layer.removeFromSuperlayer()
        }
        animationLayers.removeAll()
        print("Pulse animation stopped")
    }
}
