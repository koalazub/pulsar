import UIKit

public class PulseView: UIView {
    private var pulseLayer: CAShapeLayer?
    private var animationTimer: CADisplayLink?
    private var animationStartTime: CFTimeInterval = 0
    private var pulseDuration: TimeInterval = 1.5
    private var pulseColor: UIColor = .blue
    private var pulseRadius: CGFloat = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupPulseView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPulseView()
    }
    
    private func setupPulseView() {
        backgroundColor = .clear
        print("PulseView initialized with frame: \(frame)")
    }
    
    public func startPulsing(duration: TimeInterval = 1.5, color: UIColor = .blue, radius: CGFloat? = nil) {
        stopPulsing()
        
        self.pulseDuration = duration
        self.pulseColor = color
        self.pulseRadius = radius ?? min(bounds.width, bounds.height) / 2
        
        print("Starting pulse animation with duration: \(duration), color: \(color), radius: \(self.pulseRadius)")
        
        createPulseLayer()
        startAnimationTimer()
    }
    
    private func createPulseLayer() {
        let newPulseLayer = CAShapeLayer()
        let pulseDiameter = pulseRadius * 2
        newPulseLayer.bounds = CGRect(x: 0, y: 0, width: pulseDiameter, height: pulseDiameter)
        newPulseLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        newPulseLayer.fillColor = nil
        newPulseLayer.strokeColor = pulseColor.cgColor
        newPulseLayer.lineWidth = 3
        newPulseLayer.opacity = 1
        newPulseLayer.path = UIBezierPath(ovalIn: newPulseLayer.bounds).cgPath
        layer.addSublayer(newPulseLayer)
        
        pulseLayer = newPulseLayer
    }
    
    private func startAnimationTimer() {
        animationTimer = CADisplayLink(target: self, selector: #selector(updatePulseAnimation))
        animationTimer?.add(to: .main, forMode: .common)
        animationStartTime = CACurrentMediaTime()
    }
    
    @objc private func updatePulseAnimation() {
        guard let pulseLayer = pulseLayer else { return }
        
        let elapsedTime = CACurrentMediaTime() - animationStartTime
        let normalizedTime = fmod(elapsedTime, pulseDuration) / pulseDuration
        
        let currentScale = calculatePulseScale(at: normalizedTime)
        let currentOpacity = calculatePulseOpacity(at: normalizedTime)
        
        pulseLayer.transform = CATransform3DMakeScale(currentScale, currentScale, 1)
        pulseLayer.opacity = Float(currentOpacity)
    }
    
    private func calculatePulseScale(at time: Double) -> CGFloat {
        let beatDuration = pulseDuration * 0.4
        let firstBeatTime = time / 0.4
        let secondBeatTime = (time - 0.5) / 0.4
        
        if time < 0.4 {
            return 1 + 0.3 * sin(firstBeatTime * .pi)
        } else if time < 0.5 {
            return 1
        } else if time < 0.9 {
            return 1 + 0.15 * sin(secondBeatTime * .pi)
        } else {
            return 1
        }
    }
    
    private func calculatePulseOpacity(at time: Double) -> CGFloat {
        if time < 0.4 {
            return 0.8 + 0.2 * sin(time / 0.4 * .pi)
        } else if time < 0.5 {
            return 0.8
        } else if time < 0.9 {
            return 0.8 + 0.1 * sin((time - 0.5) / 0.4 * .pi)
        } else {
            return max(0.8 - 4 * (time - 0.9), 0)
        }
    }
    
    @MainActor
    public func stopPulsing() {
        animationTimer?.invalidate()
        animationTimer = nil
        pulseLayer?.removeFromSuperlayer()
        pulseLayer = nil
        print("Pulse animation stopped")
    }
}
