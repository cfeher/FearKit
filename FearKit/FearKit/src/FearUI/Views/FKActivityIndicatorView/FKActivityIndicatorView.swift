import UIKit

public enum FKActivityIndicatorViewStyle {
    case ThreeDots
    case Default
}

public class FKActivityIndicatorView: UIView {

    public private(set) var animating: Bool = false
    private var style: FKActivityIndicatorViewStyle
    private var animatableView: FKAnimatableView {
        didSet(oldView) {
            (oldView as? UIView)?.removeFromSuperview()

            if let animatableView = self.animatableView as? UIView {
                self.addSubview(animatableView)

                self.addConstraint(NSLayoutConstraint(
                    item: animatableView,
                    attribute: .Left,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .Left,
                    multiplier: 1.0,
                    constant: 0))
                self.addConstraint(NSLayoutConstraint(
                    item: animatableView,
                    attribute: .Right,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .Right,
                    multiplier: 1.0,
                    constant: 0))
                self.addConstraint(NSLayoutConstraint(
                    item: animatableView,
                    attribute: .Top,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .Top,
                    multiplier: 1.0,
                    constant: 0))
                self.addConstraint(NSLayoutConstraint(
                    item: animatableView,
                    attribute: .Bottom,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .Bottom,
                    multiplier: 1.0,
                    constant: 0))

                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }

    public init(frame: CGRect, style: FKActivityIndicatorViewStyle = .Default) {
        self.style = style

        switch style {
        case .ThreeDots:
            self.animatableView = ThreeDotsView(frame: CGRectZero)
        case .Default:
            self.animatableView = ThreeDotsView(frame: CGRectZero)
        }

        super.init(frame: frame)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Animating Portion
extension FKActivityIndicatorView {
    func animate(_startStop: Bool) {
        if _startStop {

        } else {

        }
    }
}

protocol FKAnimatableView {
    func animate(_startStop: Bool)
}

//MARK: Three Dots
internal class ThreeDotsView: UIView, FKAnimatableView {

    private let dotOne = FKCircleView(frame: CGRectZero)
    private let dotTwo = FKCircleView(frame: CGRectZero)
    private let dotThree = FKCircleView(frame: CGRectZero)
    private var dotDiameter: CGFloat {
        return self.frame.size.width/3.0 - self.dotSpacing/3.0
    }
    private let dotSpacing: CGFloat = 5

    override init(frame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 20)) {
        super.init(frame: frame)
        self.setup()
    }

    func setup() {
        self.addSubview(self.dotOne)
        self.addSubview(self.dotTwo)
        self.addSubview(self.dotThree)
        setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(self, false)

        //self
        self.addConstraint(NSLayoutConstraint(
            item: self,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: self.dotDiameter))
        self.addConstraint(NSLayoutConstraint(
            item: self,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: 3 * self.dotDiameter + 2 * self.dotSpacing))

        //dot one
        self.addConstraint(NSLayoutConstraint(
            item: self.dotOne,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotOne,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotOne,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: self.dotDiameter))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotOne,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: self.dotDiameter))

        //dot two
        self.addConstraint(NSLayoutConstraint(
            item: self.dotTwo,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self.dotOne,
            attribute: .Right,
            multiplier: 1.0,
            constant: self.dotSpacing))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotTwo,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotTwo,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: self.dotDiameter))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotTwo,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: self.dotDiameter))

        //dot three
        self.addConstraint(NSLayoutConstraint(
            item: self.dotThree,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self.dotTwo,
            attribute: .Right,
            multiplier: 1.0,
            constant: self.dotSpacing))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotThree,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotThree,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: self.dotDiameter))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotThree,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: self.dotDiameter))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animate(_startStop: Bool) {
        if _startStop {

        } else {

        }
    }
}