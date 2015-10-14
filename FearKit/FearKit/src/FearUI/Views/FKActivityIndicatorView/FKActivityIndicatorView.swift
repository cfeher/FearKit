import UIKit

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

public enum FKActivityIndicatorViewStyle {
    case ThreeDots(c1: UIColor, c2: UIColor)
}

public class FKActivityIndicatorView: UIView {

    public private(set) var animating: Bool = false
    private var style: FKActivityIndicatorViewStyle
    private var animatableView: FKAnimatableView

    public init(frame: CGRect = CGRect(x: 0, y: 0, width: 50, height: 10), style: FKActivityIndicatorViewStyle = FKActivityIndicatorViewStyle.ThreeDots(c1: UIColor.lightGrayColor(), c2: UIColor.lightGrayColor().colorWithAlphaComponent(0.5))) {
        self.style = style

        switch style {
        case .ThreeDots(let c1, let c2):
            let threeDots = FKThreeDotsAnimatableView(
                frame: CGRectZero,
                colorOne: c1,
                colorTwo: c2)
            self.animatableView = threeDots
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

    public func animate(_startStop: Bool) {
        self.animatableView.animate(_startStop)
    }
}

