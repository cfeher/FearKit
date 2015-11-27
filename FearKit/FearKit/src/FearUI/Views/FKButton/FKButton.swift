import UIKit

public enum FKButtonStyle {
    case RoudedBorder(textColor: UIColor, textFont: UIFont, borderColor: UIColor)
}

public class FKButton: UIControl {

    static private let defaultStyle: FKButtonStyle = .RoudedBorder(
        textColor: .whiteColor(),
        textFont: UIFont(name: "HelveticaNeue", size: 18.0)!,
        borderColor: .whiteColor())
    private let style: FKButtonStyle
    public var buttonPressCallback: (() -> ())?
    private let buttonLabel = UILabel(frame: CGRectZero)
    public var buttonText: String = "" {
        didSet {
            switch self.style {
            case .RoudedBorder(let textColor, let textFont, _):
                self.buttonLabel.attributedText = NSAttributedString(
                    string: buttonText,
                    attributes: [
                        NSFontAttributeName: textFont,
                        NSForegroundColorAttributeName: textColor
                    ])
                self.buttonLabel.textAlignment = .Center
                break
            }

        }
    }

    public init(
        frame: CGRect,
        style: FKButtonStyle = defaultStyle) {
            self.style = style
            super.init(frame: frame)
            self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup() {

        self.addSubview(self.buttonLabel)
        setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(self, val: false)

        self.addConstraint(NSLayoutConstraint(
            item: self.buttonLabel,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.buttonLabel,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.buttonLabel,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Height,
            multiplier: 0.9,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.buttonLabel,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Width,
            multiplier: 0.9,
            constant: 0))

        switch self.style {
        case .RoudedBorder(_, _, let borderColor):
            self.layer.borderColor = borderColor.CGColor
            self.layer.cornerRadius = 5.0
            self.layer.borderWidth = 1.5
            break
        }

        self.setNeedsLayout()
        self.layoutIfNeeded()

        self.addTarget(self, action: Selector("touchDownAction"), forControlEvents: .TouchDown)
        self.addTarget(self, action: Selector("touchUpInsideAction"), forControlEvents: .TouchUpInside)
        self.addTarget(self, action: Selector("touchUpOutsideAction"), forControlEvents: .TouchUpOutside)
    }
}

extension FKButton {

    func touchDownAction() {
        self.alpha = 0.5
    }

    func touchUpInsideAction() {
        self.alpha = 1.0
        self.buttonPressCallback?()
    }

    func touchUpOutsideAction() {
        self.alpha = 1.0
    }
}

