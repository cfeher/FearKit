import UIKit

public protocol FKSegmentedControlSegmentProtocol {
    var tabSelected: Bool { get set }
}

public class FKSegmentedControlSegmentView: UIView, FKSegmentedControlSegmentProtocol {
    public var tabSelected = false
}

public struct FKSegmentedControlSegment {
    public let view: FKSegmentedControlSegmentView
    let selectedCallback: ((FKSegmentedControlSegment) -> ())?

    public init(backgroundView: FKSegmentedControlSegmentView, selectedCallback: ((FKSegmentedControlSegment) -> ())?) {
        self.view = backgroundView
        self.selectedCallback = selectedCallback
    }
}

public class FKSegmentedControl: UIControl {

    let segments: [FKSegmentedControlSegment]

    public init(frame: CGRect, segments: [FKSegmentedControlSegment]) {
        self.segments = segments
        super.init(frame: frame)

        var index = 0
        var lastSegment: FKSegmentedControlSegment?
        for segment in self.segments {
            self.addSubview(segment.view)
            if let unwrappedLastSegment = lastSegment {
                self.addConstraint(NSLayoutConstraint(
                    item: segment.view,
                    attribute: .Left,
                    relatedBy: .Equal,
                    toItem: unwrappedLastSegment.view,
                    attribute: .Right,
                    multiplier: 1.0,
                    constant: 0.0))
            } else {
                //first segment
                self.addConstraint(NSLayoutConstraint(
                    item: segment.view,
                    attribute: .Left,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .Left,
                    multiplier: 1.0,
                    constant: 0.0))
            }
            self.addConstraint(NSLayoutConstraint(
                item: segment.view,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0.0))
            self.addConstraint(NSLayoutConstraint(
                item: segment.view,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: 0.0))
            self.addConstraint(NSLayoutConstraint(
                item: segment.view,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Width,
                multiplier: 1.0/CGFloat(self.segments.count),
                constant: 0.0))

            lastSegment = segment
        }
        setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(self, false)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
