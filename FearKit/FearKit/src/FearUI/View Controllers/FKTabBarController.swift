import UIKit

public struct FKTab {
	private let viewController: UIViewController
	private let image: UIImage
	private let title: String
	private let backgroundColor: UIColor

	public init(viewController: UIViewController, image: UIImage, title: String, backgroundColor: UIColor = UIColor.clearColor()) {
		self.viewController = viewController
		self.image = image
		self.title = title
		self.backgroundColor = backgroundColor
	}
}

public class FKTabBarController: UIViewController {

	private var fkTabs = [FKTabBarTab]()

	public init(tabs: [FKTab]) {
		super.init(nibName: nil, bundle: nil)

		//assign to ivar
		self.view.backgroundColor = UIColor.whiteColor()

		//create tabbar container and constrain it
		let tabBar = UIView(frame: CGRectZero)
		tabBar.backgroundColor = UIColor.lightGrayColor()
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
			multiplier: 0.15,
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

		setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(self.view, false)
		//view controllers
		for fkTab in self.fkTabs {
			self.addChildViewController(fkTab.tab.viewController)
		}
		self.view.bringSubviewToFront(tabBar)
		self.view.layoutIfNeeded()
		self.tabSelected(0)
	}

	required public init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}

extension FKTabBarController {
	func tabSelected(index: Int) {
		for fkTab in self.fkTabs {
			fkTab.tab.viewController.view.removeFromSuperview()
		}
		let view = self.fkTabs[index].tab.viewController.view
		view.frame = CGRect(
			x: 0,
			y: 0,
			width: self.view.frame.size.width,
			height: self.view.frame.size.height - 0.15 * self.view.frame.size.height)
		self.view.addSubview(view)
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
		self.button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
		self.button.addTarget(self, action: Selector("buttonPress"), forControlEvents: .TouchUpInside)
		self.addSubview(self.button)
		self.backgroundColor = tab.backgroundColor

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

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func buttonPress() {
		self.buttonSelectedCallback?(tab: self.tab)
	}
}

func == (lhs: FKTab, rhs: FKTab) -> Bool {
	return lhs.viewController == rhs.viewController
}
