//
//  File.swift
//  
//
//  Created by Eang Tithsophorn on 15/8/23.
//

import Foundation
import UIKit

extension UIView {
    @discardableResult
    public func fillSafeArea() -> [NSLayoutConstraint] {
        return fillSuperView(fullTop: false, fullBottom: false)
    }
    
    @discardableResult
    public func fillSuperView(fullTop: Bool = true, fullBottom: Bool = true) -> [NSLayoutConstraint] {
        if let superview = superview {
            return [
                setConstraint(.top, to: superview, attribute: fullTop ? .top : .topMargin, constant: 0),
                setConstraint(.leading, to: superview, attribute: .leading, constant: 0),
                setConstraint(.bottom, to: superview, attribute: fullBottom ? .bottom : .bottomMargin, constant: 0),
                setConstraint(.trailing, to: superview, attribute: .trailing, constant: 0)
            ]
        }
        return []
    }
    
    @discardableResult
    public func fill(view: UIView, top: CGFloat?, leading: CGFloat?, trailing: CGFloat?, bottom: CGFloat?, fullTop: Bool = true, fullBottom: Bool = true) -> [NSLayoutConstraint] {
        var constraints : [NSLayoutConstraint] = []
        
        if let top = top {
            constraints.append(setConstraint(.top, to: view, attribute: fullTop ? .top : .topMargin, constant: top))
        }
        if let leading = leading {
            constraints.append(setConstraint(.leading, to: view, attribute: .leading, constant: leading))
        }
        if let trailing = trailing {
            constraints.append(setConstraint(.trailing, to: view, attribute: .trailing, constant: trailing))
        }
        if let bottom = bottom {
            constraints.append(setConstraint(.bottom, to: view, attribute: fullBottom ? .bottom : .bottomMargin, constant: bottom))
        }
        
        return constraints
    }
    
    @discardableResult
    public func setConstraint(
        _ from          : NSLayoutConstraint.Attribute,
        to view         : UIView? = nil,
        attribute       : NSLayoutConstraint.Attribute? = nil,
        relation        : NSLayoutConstraint.Relation = .equal,
        constant        : CGFloat = 0.0,
        multiplier      : CGFloat = 1.0
    ) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(
            item        : self,
            attribute   : from,
            relatedBy   : relation,
            toItem      : view,
            attribute   : attribute ?? from,
            multiplier  : multiplier,
            constant    : constant
        )
        
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraint(constraint)

        return constraint
    }
    
    @discardableResult
   public func constraint(
        _ from          : NSLayoutConstraint.Attribute,
        toView view     : UIView? = nil,
        attribute       : NSLayoutConstraint.Attribute? = nil,
        relation        : NSLayoutConstraint.Relation = .equal,
        constant        : CGFloat = 0.0,
        multiplier      : CGFloat = 1.0
    ) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(
            item        : self,
            attribute   : from,
            relatedBy   : relation,
            toItem      : view,
            attribute   : attribute ?? from,
            multiplier  : multiplier,
            constant    : constant
        )
        
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraint(constraint)

        return constraint
    }
    
   public func setConstraintHorizontalPadding(
        toView view     : UIView,
        constant        : CGFloat
    ) {
        setConstraint(.leading, to: view, constant: constant)
        setConstraint(.trailing, to: view, constant: -constant)
    }
}

extension UIView {
  public  func findConstraint(layoutAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if let constraints = superview?.constraints {
            for constraint in constraints where itemMatch(constraint: constraint, layoutAttribute: layoutAttribute) {
                return constraint
            }
        }
        return nil
    }

    private func itemMatch(constraint: NSLayoutConstraint, layoutAttribute: NSLayoutConstraint.Attribute) -> Bool {
        let firstItemMatch = constraint.firstItem as? UIView == self && constraint.firstAttribute == layoutAttribute
        let secondItemMatch = constraint.secondItem as? UIView == self && constraint.secondAttribute == layoutAttribute
        return firstItemMatch || secondItemMatch
    }
}



extension UIView {
   public func addSubViews(for views: [UIView])  {
        views.forEach { view in
            self.addSubview(view)
        }
    }
}
