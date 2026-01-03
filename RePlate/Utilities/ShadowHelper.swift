import UIKit

class ShadowHelper {
    
    // Exact shadow implementation from prompt
    static func applyCardShadow(to view: UIView) {
        let shadows = UIView()
        shadows.frame = view.frame
        shadows.clipsToBounds = false
        view.superview?.insertSubview(shadows, belowSubview: view)
        
        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 30)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 60
        layer0.shadowOffset = CGSize(width: 0, height: 30)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)
        
        let shapes = UIView()
        shapes.frame = view.frame
        shapes.clipsToBounds = true
        view.superview?.insertSubview(shapes, belowSubview: view)
        
        let layer1 = CALayer()
        layer1.backgroundColor = UIColor.white.cgColor
        layer1.bounds = shapes.bounds
        layer1.position = shapes.center
        shapes.layer.addSublayer(layer1)
        shapes.layer.cornerRadius = 30
    }
    
    static func applyShadow(to view: UIView, shadowColor: UIColor = UIColor.black, shadowOpacity: Float = 0.25, shadowOffset: CGSize = CGSize(width: 0, height: 30), shadowRadius: CGFloat = 30) {
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowRadius = shadowRadius
        view.layer.masksToBounds = false
    }
    
    // Exact shadow from CSS: 0px 30px 60px rgba(0, 0, 0, 0.25)
    static func applyMainContainerShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 30)
        view.layer.shadowRadius = 30
        view.layer.masksToBounds = false
    }
    
    // Standard card shadow
    static func applyStandardCardShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.masksToBounds = false
    }
}