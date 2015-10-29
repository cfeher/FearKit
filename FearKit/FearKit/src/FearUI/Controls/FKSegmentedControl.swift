import UIKit

public protocol FKSegmentedControlSegmentProtocol {
    var tabSelected: Bool { get set }
}

public class FKSegmentedControlSegmentView: UIView, FKSegmentedControlSegmentProtocol {

    public var tabSelected = false

    override public init(frame: CGRect) {
        super.init(frame: frame)

        let tapGestureRec = UITapGestureRecognizer(target: self, action: "tabTapped")
        self.addGestureRecognizer(tapGestureRec)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public typealias FKSegmentedControlSegmentCallback = (FKSegmentedControlSegment, selected: Bool) -> ()
public class FKSegmentedControlSegment: NSObject {

    public let view: FKSegmentedControlSegmentView
    public var externalNotifier: FKSegmentedControlSegmentCallback?
    var internalNotifier: FKSegmentedControlSegmentCallback?

    public init(backgroundView: FKSegmentedControlSegmentView) {
        self.view = backgroundView
        super.init()

        let tapGestureRec = UITapGestureRecognizer(target: self, action: "tabTapped")
        self.view.addGestureRecognizer(tapGestureRec)

    }

    func tabTapped() {
        if !self.view.tabSelected {
            self.view.tabSelected = true
            self.internalNotifier?(self, selected: self.view.tabSelected)
            self.externalNotifier?(self, selected: self.view.tabSelected)
        }
    }
}

public class FKSegmentedControl: UIControl {

    let segments: [FKSegmentedControlSegment]

    public init(frame: CGRect, segments: [FKSegmentedControlSegment]) {
        self.segments = segments
        super.init(frame: frame)

        var lastSegment: FKSegmentedControlSegment?
        for segment in self.segments {

            segment.internalNotifier = { retSegment, selected in
                for internalSegment in self.segments {
                    if internalSegment != retSegment {
                        internalSegment.view.tabSelected = false
                    }
                }
            }

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
                segment.view.tabSelected = true
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
        setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(self, val: false)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tabSelected() {
        print("Tab Selected")
    }
}
