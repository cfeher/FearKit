import UIKit

public struct FKTab {
	private let viewController: UIViewController
	private let image: UIImage
	private let title: String

	public init(viewController: UIViewController, image: UIImage, title: String) {
		self.viewController = viewController
		self.image = image
		self.title = title
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
		tabBar.backgroundColor = UIColor.blueColor()
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
			self.fkTabs.append(tab)
			self.view.addSubview(tab)
		}

		//constrain the tabs
		var index = 0
		for fkTab in self.fkTabs {
			if index == 0 {
				self.view.addConstraint(NSLayoutConstraint(
					item: fkTab,
					attribute: .Left,
					relatedBy: .Equal,
					toItem: self,
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
				toItem: fkTab,
				attribute: .Height,
				multiplier: 1.0,
				constant: 0))
			
			index += 1
		}

		setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(self.view, false)
		self.view.layoutIfNeeded()
	}

	required public init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}

internal class FKTabBarTab: UIView {

	let button = UIButton(frame: CGRectZero)

	init(tab: FKTab, frame: CGRect) {
		super.init(frame: frame)

		self.button.imageView?.image = tab.image
		self.addSubview(self.button)

		self.addConstraint(NSLayoutConstraint(
			item: self.button,
			attribute: .Left,
			relatedBy: .Equal,
			toItem: self,
			attribute: .Left,
			multiplier: 1.0,
			constant: 0))
		self.addConstraint(NSLayoutConstraint(
			item: self.button,
			attribute: .Right,
			relatedBy: .Equal,
			toItem: self,
			attribute: .Right,
			multiplier: 1.0,
			constant: 0))
		self.addConstraint(NSLayoutConstraint(
			item: self.button,
			attribute: .Top,
			relatedBy: .Equal,
			toItem: self,
			attribute: .Top,
			multiplier: 1.0,
			constant: 0))
		self.addConstraint(NSLayoutConstraint(
			item: self.button,
			attribute: .Bottom,
			relatedBy: .Equal,
			toItem: self,
			attribute: .Bottom,
			multiplier: 1.0,
			constant: 0))

		setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(self, false)
		self.layoutIfNeeded()
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

