import UIKit

public enum FKButtonStyle {
    case RoudedBorder(textColor: UIColor, textFont: UIFont, borderColor: UIColor)
}

public class FKButton: UIButton {
    
    static private let defaultStyle: FKButtonStyle = .RoudedBorder(
                                    textColor: .whiteColor(),
                                    textFont: UIFont(name: "HelveticaNeue", size: 12.0)!,
                                    borderColor: .whiteColor())
    private let style: FKButtonStyle
    public var buttonPressCallback: (() -> ())?
    
    public init(
        frame: CGRect,
        style: FKButtonStyle = defaultStyle) {
            
        self.style = style
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func drawRect(rect: CGRect) {

    }
}
