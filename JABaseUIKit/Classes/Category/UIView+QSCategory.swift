//
//  UIView+QSCategory.swift
//  JABaseUIKit
//
//  Created by Qiyeyun7 on 2021/8/16.
//

import Foundation

// MARK: - ====== 添加存储属性 ======

public extension UIView {
    convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
    }

    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.w, height: self.h)
        }
    }

    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.w, height: self.h)
        }
    }

    var w: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.h)
        }
    }

    var h: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.w, height: value)
        }
    }

    var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }

    var right: CGFloat {
        get {
            return self.x + self.w
        } set(value) {
            self.x = value - self.w
        }
    }

    var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }

    var bottom: CGFloat {
        get {
            return self.y + self.h
        } set(value) {
            self.y = value - self.h
        }
    }

    var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }

    var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }

    var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }

    var size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }
}

// MARK: - ====== 添加点击手势 ======

public extension UIView {
    func addTapGestureRecognizer(tapNumber: Int = 1, target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}

public extension UIView {
    // 来源：https://medium.com/@sdrzn/adding-gesture-recognizers-with-closures-instead-of-selectors-9fb3e09a8f0b

    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate enum AssociatedObjectKeys {
        static var tapGestureRecognizer = "AssociatedObjectKey_tapGestureRecognizer"
    }

    fileprivate typealias Action = (() -> Void)?

    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }

    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    func addTapGestureRecognizer(tapNumber: Int = 1, action: (() -> Void)?) {
        self.tapGestureRecognizerAction = action
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture))
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
}

// MARK: - ====== 添加方法 ======

public extension UIView {
    /// 移除所有子视图
    func removeAllChildView() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    /// 获取视图的控制器
    func viewController() -> UIViewController? {
        var next = superview
        while next != nil {
            let nextResponder = next?.next
            if nextResponder is UIViewController {
                return (nextResponder as? UIViewController) ?? nil
            }
            next = next?.superview
        }

        return nil
    }

    /// Create a snapshot image of the complete view hierarchy.
    func snapshotImage() -> UIImage? {
        var isOpaque = self.isOpaque
        // 若有裁剪，则默认false，否则转图片有黑边
        if self.layer.mask != nil {
            isOpaque = false
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap
    }

    /// Create a snapshot image of the complete view hierarchy.
    /// @discussion It's faster than "snapshotImage", but may cause screen updates.
    /// See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.
    /// - Parameter afterUpdates:
    /// - Returns:
    func snapshotImageAfterScreenUpdates(_ afterUpdates: Bool) -> UIImage? {
        if !self.responds(to: #selector(drawHierarchy(in:afterScreenUpdates:))) {
            return snapshotImage()
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        drawHierarchy(in: self.bounds, afterScreenUpdates: afterUpdates)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap
    }
}

// MARK: - ====== 设置边框与圆角 ======

public extension UIView {
    /// 添加阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 偏移量
    ///   - opacity: 透明度
    ///   - radius: 圆角
    func addShadow(color: UIColor = .gray, opacity: Float = 0, offset: CGSize = CGSize(width: 0, height: -3), radius: CGFloat = 3) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }

    func addCorner(size: CGFloat, roundingCorners: UIRectCorner = [.bottomRight, .bottomLeft, .topRight, .topLeft]) {
        let cornerRadii = CGSize(width: size, height: size)
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.name = "QS_addCorner"
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
