import UIKit

class UniversalLayoutHelper {
    
    static func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func adaptiveWidth(iPhone: CGFloat, iPad: CGFloat) -> CGFloat {
        return isIPad() ? iPad : iPhone
    }
    
    static func adaptiveHeight(iPhone: CGFloat, iPad: CGFloat) -> CGFloat {
        return isIPad() ? iPad : iPhone
    }
    
    static func adaptiveFontSize(iPhone: CGFloat, iPad: CGFloat) -> CGFloat {
        return isIPad() ? iPad : iPhone
    }
    
    // Adaptive constraints for universal support
    static func setupUniversalConstraints(for view: UIView, in containerView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if isIPad() {
            // iPad: Center with max width
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                view.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
                view.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
                view.widthAnchor.constraint(lessThanOrEqualToConstant: 600),
                view.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 20),
                view.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -20)
            ])
        } else {
            // iPhone: Full width
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                view.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
                view.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
}