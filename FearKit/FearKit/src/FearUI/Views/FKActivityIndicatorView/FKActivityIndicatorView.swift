import UIKit

public enum FKActivityIndicatorViewStyle {
    case ThreeDots
    case Default
}

public class FKActivityIndicatorView: UIView {

    public private(set) var animating: Bool = false
    private var style: FKActivityIndicatorViewStyle
    private var animatableView: FKAnimatableView

    public init(frame: CGRect = CGRect(x: 0, y: 0, width: 50, height: 10), style: FKActivityIndicatorViewStyle = .Default) {
        self.style = style

        switch style {
        case .ThreeDots:
            self.animatableView = ThreeDotsView(frame: CGRectZero)
        case .Default:
            self.animatableView = ThreeDotsView(frame: CGRectZero)
        }

        super.init(frame: frame)

        //constraints
        self.addSubview(self.animatableView)
        setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(self, false)

        self.addConstraint(NSLayoutConstraint(
            item: self.animatableView,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.animatableView,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Right,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.animatableView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.animatableView,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0))
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animate(_startStop: Bool) {
        self.animatableView.animate(_startStop)
    }
}

class FKAnimatableView: UIView {

    var animationSpeed: NSTimeInterval = 0.75
    var animating: Bool = false

    func animate(_startStop: Bool) {
        println("default implementation of animate - must implement")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Three Dots
internal class ThreeDotsView: FKAnimatableView {

    private let dotOne = FKCircleView(frame: CGRectZero)
    private let dotTwo = FKCircleView(frame: CGRectZero)
    private let dotThree = FKCircleView(frame: CGRectZero)
    private var dotDiameter: CGFloat {
        return self.frame.size.width/3.0 - self.dotSpacing/3.0
    }
    private let dotSpacing: CGFloat = 3

    override init(frame: CGRect = CGRectZero) {
        super.init(frame: frame)
        self.setup()
    }

    func setup() {

        self.addSubview(self.dotOne)
        self.addSubview(self.dotTwo)
        self.addSubview(self.dotThree)
        setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(self, false)

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
            toItem: self,
            attribute: .Width,
            multiplier: 1.0/3.0,
            constant: -(self.dotSpacing * 2.0/3.0)))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotOne,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: self.dotOne,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0))

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
            toItem: self,
            attribute: .Width,
            multiplier: 1.0/3.0,
            constant: -(self.dotSpacing * 2.0/3.0)))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotTwo,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: self.dotTwo,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0))

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
            toItem: self,
            attribute: .Width,
            multiplier: 1.0/3.0,
            constant: -(self.dotSpacing * 2.0/3.0)))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotThree,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: self.dotThree,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func animate(_startStop: Bool) {

        self.animating = _startStop
        var fade: (() -> Void)?
        var show: (() -> Void)?

        show = {
            let showOne: () -> Void = {
                self.dotOne.alpha = 1.0
            }
            let showTwo: () -> Void = {
                self.dotTwo.alpha = 1.0
            }
            let showThree: () -> Void = {
                self.dotThree.alpha = 1.0
            }

            UIView.animateKeyframesWithDuration(self.animationSpeed,
                delay: 0.0, options: .CalculationModeLinear, animations: {

                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0/3.0, animations: showOne)

                    UIView.addKeyframeWithRelativeStartTime(1.0/3.0, relativeDuration: 1.0/3.0, animations: showTwo)

                    UIView.addKeyframeWithRelativeStartTime(2.0/3.0, relativeDuration: 1.0/3.0, animations: showThree)

                }) { (complete) -> Void in
                    if self.animating {
                        fade?()
                    }
            }
        }

        fade = {
            let fadeOne: () -> Void = {
                self.dotOne.alpha = 0.5
            }
            let fadeTwo: () -> Void = {
                self.dotTwo.alpha = 0.5
            }
            let fadeThree: () -> Void = {
                self.dotThree.alpha = 0.5
            }

            UIView.animateKeyframesWithDuration(self.animationSpeed,
                delay: 0.0, options: .CalculationModeLinear, animations: {
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0/3.0, animations: fadeOne)

                    UIView.addKeyframeWithRelativeStartTime(1.0/3.0, relativeDuration: 1.0/3.0, animations: fadeTwo)

                    UIView.addKeyframeWithRelativeStartTime(2.0/3.0, relativeDuration: 1.0/3.0, animations: fadeThree)

                }) { (complete) -> Void in
                    show?()
            }
        }
        _startStop ? fade?() : show?()
    }
}