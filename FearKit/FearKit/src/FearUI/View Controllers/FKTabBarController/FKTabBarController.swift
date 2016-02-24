import UIKit

public struct FKTab {
    private let viewController: UIViewController
    private let image: UIImage
    private let title: String
    private let backgroundColor: UIColor
    private let selectedBackgroundColor: UIColor

    public init(viewController: UIViewController, image: UIImage, title: String, backgroundColor: UIColor = UIColor.clearColor(), selectedBackgroundColor: UIColor = UIColor.grayColor()) {
        self.viewController = viewController
        self.image = image
        self.title = title
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
    }
}

public func == (lhs: FKTab, rhs: FKTab) -> Bool {
    return lhs.viewController == rhs.viewController
}

public class FKTabBarController: UIViewController {

    private var selectedTab = 0
    private var fkTabs = [FKTabBarTab]()
    private var tabBar: UIView?
    public var tabSelectedCallback: ((tab: FKTab) -> ())?

    public init(tabs: [FKTab], barBackgroundColor: UIColor) {
        super.init(nibName: nil, bundle: nil)

        //assign to ivar
        self.view.backgroundColor = barBackgroundColor

        //create tabbar container and constrain it
        let tabBar = UIView(frame: CGRectZero)
        tabBar.backgroundColor = barBackgroundColor
        self.view.addSubview(tabBar)

        self.view.addConstraint(NSLayoutConstraint(
            item: tabBar,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: tabBar,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: tabBar,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: tabBar,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Height,
            multiplier: 0.09,
            constant: 0))

        //create the list of tabs
        self.fkTabs.removeAll(keepCapacity: false)
        for tab in tabs {
            let tab = FKTabBarTab(tab: tab, frame: CGRectZero)
            tab.buttonSelectedCallback = { [weak self] (tab: FKTab) in
                if let welf = self {
                    var index = 0
                    for fkTab in welf.fkTabs {
                        if fkTab.tab == tab {
                            welf.tabSelected(index)
                        }
                        index += 1
                    }
                }
            }
            self.fkTabs.append(tab)
            tabBar.addSubview(tab)
        }
        self.tabBar = tabBar

        //constrain the tabs
        var index = 0
        for fkTab in self.fkTabs {
            if index == 0 {
                self.view.addConstraint(NSLayoutConstraint(
                    item: fkTab,
                    attribute: .Left,
                    relatedBy: .Equal,
                    toItem: tabBar,
                    attribute: .Left,
                    multiplier: 1.0,
                    constant: 0))
            } else {
                let previous = self.fkTabs[index - 1]
                self.view.addConstraint(NSLayoutConstraint(
                    item: fkTab,
                    attribute: .Left,
                    relatedBy: .Equal,
                    toItem: previous,
                    attribute: .Right,
                    multiplier: 1.0,
                    constant: 0))
            }
            self.view.addConstraint(NSLayoutConstraint(
                item: fkTab,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: tabBar,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0))
            self.view.addConstraint(NSLayoutConstraint(
                item: fkTab,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: tabBar,
                attribute: .Height,
                multiplier: 1.0,
                constant: 0))
            self.view.addConstraint(NSLayoutConstraint(
                item: fkTab,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: tabBar,
                attribute: .Width,
                multiplier: CGFloat(1.0)/CGFloat(self.fkTabs.count),
                constant: 0))

            index += 1
        }

        setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(self.view, val: false)
        //view controllers
        for fkTab in self.fkTabs {
            self.addChildViewController(fkTab.tab.viewController)
        }
        self.view.bringSubviewToFront(tabBar)
        self.view.layoutIfNeeded()
        self.tabSelected(0)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FKTabBarController {
    //MARK: - Hiding tab bar
    public func tabBarHidden(isHidden: Bool) {
        self.tabBar?.hidden = isHidden
    }

    public func setSelectedTab(tab: FKTab) {
        var index = 0
        for internalTab in self.fkTabs {
            if tab == internalTab.tab {
                self.tabSelected(index)
                return
            }
            index += 1
        }
    }
}

extension FKTabBarController {
    func tabSelected(index: Int) {
        guard index != self.selectedTab else {
            return
        }
        self.selectedTab = index
        for fkTab in self.fkTabs {
            fkTab.tab.viewController.view.removeFromSuperview()
            fkTab.backgroundColor = fkTab.tab.backgroundColor
        }
        if let tabBar = self.tabBar {
            let fkTabbarTab = self.fkTabs[index]
            self.tabSelectedCallback?(tab: fkTabbarTab.tab)
            fkTabbarTab.backgroundColor = fkTabbarTab.tab.selectedBackgroundColor
            let view = fkTabbarTab.tab.viewController.view
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false

            self.view.addConstraint(NSLayoutConstraint(
                item: view,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Left,
                multiplier: 1.0,
                constant: 0))
            self.view.addConstraint(NSLayoutConstraint(
                item: view,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Right,
                multiplier: 1.0,
                constant: 0))
            self.view.addConstraint(NSLayoutConstraint(
                item: view,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0))
            self.view.addConstraint(NSLayoutConstraint(
                item: view,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: tabBar,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0))

            self.view.bringSubviewToFront(tabBar)
            self.view.layoutIfNeeded()
        }
    }
}

internal class FKTabBarTab: UIView {

    let button = UIButton(frame: CGRectZero)
    let tab: FKTab
    var buttonSelectedCallback: ((tab: FKTab) -> ())?

    init(tab: FKTab, frame: CGRect) {
        self.tab = tab
        super.init(frame: frame)

        self.button.setImage(tab.image, forState: .Normal)
        self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        self.button.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        self.button.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        let imagesize = tab.image.size
        self.button.imageEdgeInsets = UIEdgeInsets(
            top: ((imagesize.height - frame.size.height)/2.0) * 0.75,
            left: ((imagesize.width - frame.size.width)/2.0) * 0.75,
            bottom: ((imagesize.height - frame.size.height)/2.0) * 0.75,
            right: ((imagesize.width - frame.size.width)/2.0) * 0.75)
        self.button.addTarget(self, action: Selector("buttonPress"), forControlEvents: .TouchUpInside)
        self.button.backgroundColor = UIColor.clearColor()
        self.addSubview(self.button)
        self.backgroundColor = UIColor.clearColor()

        self.addConstraint(NSLayoutConstraint(
            item: self.button,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.button,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.button,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Width,
            multiplier: 0.75,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.button,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: self.button,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0))

        //self.button.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.layoutIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buttonPress() {
        self.buttonSelectedCallback?(tab: self.tab)
    }
}
