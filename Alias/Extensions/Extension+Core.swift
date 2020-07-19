//
//  Extension+Core.swift
//  Alias
//
//  Created by Sasha on 08/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

// MARK: - View
extension UIView {
    static var name: String {
        return String(describing: self)
    }
    
    var rootView: UIView? {
        var parentView = superview
        while let superview = parentView?.superview {
            parentView = superview
        }
        
        return parentView
    }
    
    func getConstraint(type: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint? {
        for constraint in self.constraints {
            if constraint.firstAttribute == type && constraint.relation == relation {
                return constraint
            }
        }
        return nil
    }
    
    func roundCorners(corners: CACornerMask, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
    
    func getSafeAreaRect() -> CGRect {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.layoutFrame
        }
        
        return frame
    }
    
//    func getSafeAreaTopInsets() -> UIEdgeInsets {
//        let result = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
//        if #available(iOS 11.0, *) {
//            return UIApplication.shared.keyWindow?.safeAreaInsets ?? result
//        }
//        return result
//    }
    
}

// MARK: - UILabel
extension UILabel {
    
    func kern(kerningValue: CGFloat) {
        self.attributedText =  NSAttributedString(string: self.text ?? "", attributes: [
            .kern: kerningValue,
            .font: font as Any,
            .foregroundColor: textColor as Any
        ])
    }
    
    func getAttributes() -> [NSAttributedString.Key : Any] {
        return [
            .font: font as Any,
            .foregroundColor: textColor as Any
        ]
    }
    
    func setTextWhileKeepingAttributes(_ string: String) {
        if let newAttributedText = self.attributedText {
            let mutableAttributedText = newAttributedText.mutableCopy() as! NSMutableAttributedString
            
            mutableAttributedText.mutableString.setString(string)
            self.attributedText = mutableAttributedText
        } else {
            self.text = string
        }
    }
}

// MARK: - UIButton
extension UIButton {
    func adjustImageAndTitleOffsetsForButton() {
        let spacing: CGFloat = 6.0
        let imageSize = imageView!.frame.size
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
        let titleSize = titleLabel!.frame.size
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
}

// MARK: - UIImage
extension UIImage {
    func resizeWithWidth(_ newWidth: CGFloat) -> UIImage? {
        let newHeight: CGFloat = ceil(newWidth/size.width * size.height)
        let newSize = CGSize(width: newWidth, height: newHeight)
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: newSize))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

// MARK: - UIProgressView
extension UIProgressView {
    @IBInspectable var barHeight : CGFloat {
        get {
            return transform.d * 2.0
        }
        set {
            let heightScale = newValue / 2.0
            let c = center
            transform = CGAffineTransform(scaleX: 1.0, y: heightScale)
            center = c
        }
    }
}

// MARK: - UITableView
extension UITableView {
    func register(type: UITableViewCell.Type) {
        let typeName = type.name
        let nib = UINib(nibName: typeName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: typeName)
    }
    
    func register(type: UITableViewHeaderFooterView.Type) {
        let typeName = type.name
        let nib = UINib(nibName: typeName, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: typeName)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.name, for: indexPath) as! T
    }

    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(with type: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: type.name) as! T
    }
    
    func scrollToBottom(animated: Bool) {
        let lastSection = numberOfSections-1
        let lastRow = numberOfRows(inSection: lastSection)-1
        guard lastSection >= 0, lastRow >= 0 else { return }
        let lastIndexPath = IndexPath(row: lastRow, section: lastSection)
        scrollToRow(at: lastIndexPath, at: .bottom, animated: animated)
    }
}

// MARK: - UICollectionView
extension UICollectionView {
    func register(type: UICollectionViewCell.Type) {
        let typeName = type.name
        let nib = UINib(nibName: typeName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: typeName)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: type.name, for: indexPath) as! T
    }
        
}

// MARK: - UITableViewCell
extension UITableViewCell {
//    static var name: String {
//        return String(describing: self)
//    }
//
    var tableView: UITableView? {
        var view = self.superview
        while (view != nil && view!.isKind(of: UITableView.self) == false) {
            view = view!.superview
        }
        return view as? UITableView
    }
}

// MARK: - UIFont
extension UIFont {
    static func museoSans(style: Int, size: CGFloat) -> UIFont {
        return UIFont(name: "MuseoSans-\(style)", size: size)!
    }
    
    static func museoCyrl(style: Int, size: CGFloat) -> UIFont {
        return UIFont(name: "MuseoCyrl-\(style)", size: size)!
    }
    
    static func museo(style: Int, size: CGFloat) -> UIFont {
        return UIFont(name: "Museo-\(style)", size: size)!
    }
}

// MARK: - UIColor
extension UIColor {
    convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1
        )
    }
}

// MARK: - CGRect
extension CGRect {
    var centerY: CGFloat {
        return minY + height / CGFloat(2)
    }
    
    var centerX: CGFloat {
        return minX + width / CGFloat(2)
    }
}

// MARK: - CGFloat
extension CGFloat {
    func translateIn(range: PartialRangeFrom<CGFloat>) -> CGFloat {
        if self < range.lowerBound {
            return range.lowerBound
        }
        
        return self
    }
    
    func translateIn(range: ClosedRange<CGFloat>) -> CGFloat {
        if self > range.upperBound {
            return range.upperBound
        } else if self < range.lowerBound {
            return range.lowerBound
        }
        
        return self
    }
}

// MARK: - CALayer

extension CALayer {
    var shadowUIColor: UIColor {
        set {
            self.shadowColor = newValue.cgColor
        }

        get {
            return UIColor(cgColor: self.shadowColor!)
        }
    }
}
