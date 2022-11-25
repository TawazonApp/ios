//
//  ConnectionUtils.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import SwiftMessages

extension UICollectionReusableView {
    class var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    class var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController {
    
    class var identifier: String {
        return String(describing: self)
    }
    
    func openActivityViewController(title:String?, urlString:String?) {
        var activityItems = [Any]()
        if let title = title {
            activityItems.append(title)
        }
        if let url = urlString?.url {
            activityItems.append(url)
        }
        openActivityViewController(activityItems: activityItems)
    }
    
    func openActivityViewController(activityItems: [Any]) {
        let activityViewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func isModal() -> Bool {
        
        if let navigationController = self.navigationController{
            if navigationController.viewControllers.first != self{
                return false
            }
        }
        
        if self.presentingViewController != nil {
            return true
        }
        
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        }
        
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
}

extension UIViewController:  UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return (presented is BaseViewController) ? PresentAnimatedTransitioning() : nil
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return (dismissed is BaseViewController) ? DismissAnimatedTransitioning() : nil
    }
    
}
extension UIImage {
    
    class func fromColor(color: UIColor,rect:CGRect) -> UIImage {
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}


class GradientView: UIView {
    
    private struct Animation {
        static let keyPath = "colors"
        static let key = "ColorChange"
    }
    
    override open class var layerClass: AnyClass {
        get {
            return CAGradientLayer.classForCoder()
        }
    }
    
    func applyGradientColor(colors: [CGColor], startPoint: GradientPoint, endPoint: GradientPoint)  {
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint.point
        gradientLayer.endPoint = endPoint.point
        gradientLayer.drawsAsynchronously = true
    }
    
    func animateGradient(colors: [CGColor], duration: TimeInterval) {
        let gradient = self.layer as! CAGradientLayer
        let animation = CABasicAnimation(keyPath: Animation.keyPath)
        animation.duration = duration
        animation.toValue = colors
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        gradient.add(animation, forKey: Animation.key)
    }
    
    open override func removeFromSuperview() {
        let gradient = self.layer as! CAGradientLayer
        super.removeFromSuperview()
        gradient.removeAllAnimations()
        gradient.removeFromSuperlayer()
    }
}

public enum GradientPoint: Int {
    case left
    case top
    case right
    case bottom
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case center
    
    var point: CGPoint {
        switch self {
        case .left: return CGPoint(x: 0.0, y: 0.5)
        case .top: return CGPoint(x: 0.5, y: 0.0)
        case .right: return CGPoint(x: 1.0, y: 0.5)
        case .bottom: return CGPoint(x: 0.5, y: 1.0)
        case .topLeft: return CGPoint(x: 0.0, y: 0.0)
        case .topRight: return CGPoint(x: 1.0, y: 0.0)
        case .bottomLeft: return CGPoint(x: 0.0, y: 1.0)
        case .bottomRight: return CGPoint(x: 1.0, y: 1.0)
        case .center: return CGPoint(x: 0.5, y: 0.5)
        }
    }
}

class GradientLabel: UILabel {
    
    private struct Animation {
        static let keyPath = "colors"
        static let key = "ColorChange"
    }
    
    override open class var layerClass: AnyClass {
        get {
            return CAGradientLayer.classForCoder()
        }
    }
    
    func applyGradientColor(colors: [CGColor], startPoint: GradientPoint, endPoint: GradientPoint)  {
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint.point
        gradientLayer.endPoint = endPoint.point
        gradientLayer.drawsAsynchronously = true
    }
    
    func animateGradient(colors: [CGColor], duration: TimeInterval) {
        let gradient = self.layer as! CAGradientLayer
        let animation = CABasicAnimation(keyPath: Animation.keyPath)
        animation.duration = duration
        animation.toValue = colors
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        gradient.add(animation, forKey: Animation.key)
    }
    
    open override func removeFromSuperview() {
        let gradient = self.layer as! CAGradientLayer
        super.removeFromSuperview()
        gradient.removeAllAnimations()
        gradient.removeFromSuperlayer()
    }
}

class GradientButton: UIButton {
    
    private struct Animation {
        static let keyPath = "colors"
        static let key = "ColorChange"
    }
    
    override open class var layerClass: AnyClass {
        get {
            return CAGradientLayer.classForCoder()
        }
    }
    
    func applyGradientColor(colors: [CGColor], startPoint: GradientPoint, endPoint: GradientPoint)  {
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint.point
        gradientLayer.endPoint = endPoint.point
        gradientLayer.drawsAsynchronously = true
    }
    
    func animateGradient(colors: [CGColor], duration: TimeInterval) {
        let gradient = self.layer as! CAGradientLayer
        let animation = CABasicAnimation(keyPath: Animation.keyPath)
        animation.duration = duration
        animation.toValue = colors
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        gradient.add(animation, forKey: Animation.key)
    }
    
    open override func removeFromSuperview() {
        let gradient = self.layer as! CAGradientLayer
        super.removeFromSuperview()
        gradient.removeAllAnimations()
        gradient.removeFromSuperlayer()
    }
}

class GradientImageView: UIImageView {
    
    override open class var layerClass: AnyClass {
        get {
            return CAGradientLayer.classForCoder()
        }
    }
    
    func applyGradientColor(colors: [CGColor], startPoint: GradientPoint, endPoint: GradientPoint)  {
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint.point
        gradientLayer.endPoint = endPoint.point
        gradientLayer.drawsAsynchronously = true
    }
}


extension UIButton {
    
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let factor: CGFloat = -1
        if UIApplication.isRTL() {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount*factor, bottom: 0, right: insetAmount*factor)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount*factor, bottom: 0, right: -insetAmount*factor)
            
        } else {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount*factor, bottom: 0, right: -insetAmount*factor)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount*factor, bottom: 0, right: insetAmount*factor)
            
        }
        if self.contentEdgeInsets == UIEdgeInsets.zero {
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }
    
    func setTitleWithoutAnimation(title: String) {
        UIView.performWithoutAnimation { [weak self] in
            self?.setTitle(title, for: .normal)
            self?.layoutIfNeeded()
        }
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func viewToImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        return image
    }
}



extension UIAlertController {
    
    private struct AssociatedKeys {
        static var blurStyleKey = "UIAlertController.blurStyleKey"
    }
    
    public var blurStyle: UIBlurEffect.Style {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.blurStyleKey) as? UIBlurEffect.Style ?? .extraLight
        } set (style) {
            objc_setAssociatedObject(self, &AssociatedKeys.blurStyleKey, style, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
    public var cancelButtonColor: UIColor? {
        return blurStyle == .dark ? UIColor(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1.0) : nil
    }
    
    private var visualEffectView: UIVisualEffectView? {
        if let presentationController = presentationController, presentationController.responds(to: Selector(("popoverView"))), let view = presentationController.value(forKey: "popoverView") as? UIView // We're on an iPad and visual effect view is in a different place.
        {
            return view.recursiveSubviews.compactMap({$0 as? UIVisualEffectView}).first
        }
        
        return view.recursiveSubviews.compactMap({$0 as? UIVisualEffectView}).first
    }
    
    private var cancelActionView: UIView? {
        return view.recursiveSubviews.compactMap({
                                                    $0 as? UILabel}
        ).first(where: {
            $0.text == actions.first(where: { $0.style == .cancel })?.title
        })?.superview?.superview
    }
    
    public convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, blurStyle: UIBlurEffect.Style) {
        if #available(iOS 13.0, *) {
            self.init(title: title, message: message, preferredStyle: preferredStyle)
            if blurStyle == .dark {
                self.overrideUserInterfaceStyle = .dark
            }
            return
        }
        self.init(title: nil, message: nil, preferredStyle: preferredStyle)
        self.blurStyle = blurStyle
        
        if let title = title {
            
            let titleAttrString = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font : UIFont.kacstPen(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.white])
            self.setValue(titleAttrString, forKey: "attributedTitle")
        }
        
        if let message = message {
            let messageAttrString = NSAttributedString.init(string: message, attributes: [NSAttributedString.Key.font : UIFont.kacstPen(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white])
            self.setValue(messageAttrString, forKey: "attributedMessage")
        }
        
        visualEffectView?.effect = UIBlurEffect(style: blurStyle)
        cancelActionView?.backgroundColor = cancelButtonColor
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 13.0, *) { return }
        visualEffectView?.effect = UIBlurEffect(style: blurStyle)
        cancelActionView?.backgroundColor = cancelButtonColor
    }
    
    
    
    func addAction(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let action = UIAlertAction(title: title, style: style, handler: { (action) in
            handler?(action)
        })
        
        switch style {
        case .default:
            action.setValue(UIColor.white, forKey: "titleTextColor")
        case .cancel:
            action.setValue(UIColor.white, forKey: "titleTextColor")
            break
        case .destructive:
            action.setValue(UIColor.orangePink, forKey: "titleTextColor")
            break
        }
        self.addAction(action)
    }
    
}

extension UIView {
    
    var recursiveSubviews: [UIView] {
        var subviews = self.subviews.compactMap({$0})
        subviews.forEach { subviews.append(contentsOf: $0.recursiveSubviews) }
        return subviews
    }
}


public protocol NibInstantiatable {
    
    static func nibName() -> String
    
}

extension NibInstantiatable {
    
    static func nibName() -> String {
        return String(describing: self)
    }
    
}

extension NibInstantiatable where Self: UIView {
    
    static func fromNib() -> Self {
        
        let bundle = Bundle(for: self)
        let nib = bundle.loadNibNamed(nibName(), owner: self, options: nil)
        
        return nib!.first as! Self
        
    }
    
}

extension UIView {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.1
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = false
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
    
    func clearLabels() {
        for subview in self.subviews {
            if subview.isKind(of: UILabel.self){
                (subview as! UILabel).text = ""
            }else if subview.isKind(of: UIButton.self){
                (subview as! UIButton).setTitle("", for: .normal)
            }else{
                subview.clearLabels()
            }
        }
    }
    
    func respectLanguageFrame()-> CGRect{
        var frame = self.frame
        if Language.language == .arabic{
            frame = CGRect(x: UIScreen.main.bounds.width - (frame.origin.x + frame.width), y: frame.origin.y, width: frame.width, height: frame.height)
        }
        
        
        return frame
    }
    
    static let kLayerNameGradientBorder = "GradientBorderLayer"

    func gradientBorder(width: CGFloat,
                        colors: [UIColor],
                        startPoint: GradientPoint,
                        endPoint: GradientPoint,
                        corners: UIRectCorner = .allCorners,
                        andRoundCornersWithRadius cornerRadius: CGFloat = 0) {

        let existingBorder = gradientBorderLayer()
        let border = existingBorder ?? CAGradientLayer()
        border.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y,
                                      width: bounds.size.width + width, height: bounds.size.height + width)
        border.colors = colors.map { return $0.cgColor }
        border.startPoint = startPoint.point
        border.endPoint = endPoint.point
        border.name = UIView.kLayerNameGradientBorder

        let mask = CAShapeLayer()
        let maskRect = CGRect(x: bounds.origin.x + width/2, y: bounds.origin.y + width/2,
                                      width: bounds.size.width - width, height: bounds.size.height - width)
        mask.path = UIBezierPath(roundedRect: maskRect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = width

        border.mask = mask

        let exists = (existingBorder != nil)
        if !exists {
            layer.addSublayer(border)
        }
    }
    
    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameGradientBorder }
        if borderLayers?.count ?? 0 > 1 {
            fatalError()
        }
        return borderLayers?.first as? CAGradientLayer
    }
    
    var snapshot: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let capturedImage = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return capturedImage
    }
    
    func createDashedLine(from point1: CGPoint, to point2: CGPoint, color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat) {
            let shapeLayer = CAShapeLayer()

            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = width
            shapeLayer.lineDashPattern = [strokeLength, gapLength]

            let path = CGMutablePath()
            path.addLines(between: [point1, point2])
            shapeLayer.path = path
            layer.addSublayer(shapeLayer)
        }
}

extension UIImage {
    var flipIfNeeded: UIImage {
        return UIApplication.isRTL() ? self : self.withHorizontallyFlippedOrientation()
    }
}

extension UIButton {
    func addBlurEffect(style: UIBlurEffect.Style = .regular) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .clear
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        blurView.layer.masksToBounds = true
        self.insertSubview(blurView, at: 0)
        if let imageView = self.imageView{
            imageView.backgroundColor = .clear
            self.bringSubviewToFront(imageView)
        }
    }
}
extension CALayer {
    func addGradienBorder(colors:[UIColor],
                          andRoundCornersWithRadius cornerRadius: CGFloat = 0, width:CGFloat = 1) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: CGPointZero, size: self.bounds.size)
        gradientLayer.startPoint = CGPointMake(0.0, 0.5)
        gradientLayer.endPoint = CGPointMake(1.0, 0.5)
        gradientLayer.colors = colors.map({$0.cgColor})

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer

        self.addSublayer(gradientLayer)
    }

}
