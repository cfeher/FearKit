import UIKit

public struct FKTab {
	let viewController: UIViewController
	let image: UIImage
	let title: String

	init(viewController: UIViewController, image: UIImage, title: String) {
		self.viewController = viewController
		self.image = image
		self.title = title
	}
}

public class FKTabBarController: UIViewController {

	private var tabs: [FKTab]? = [] //for now

	public init(tabs: [FKTab]?) {
		super.init(nibName: nil, bundle: nil)

		//assign to ivar
		self.tabs = tabs
		self.view.backgroundColor = UIColor.whiteColor()

		//create tabbar container and constrain it
		let tabBar = UIView(frame: CGRectZero)
		tabBar.backgroundColor = UIColor.blackColor()
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
			multiplier: 0.1,
			constant: 0))
	}

	required public init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}

internal class FKTabBarTab {

}