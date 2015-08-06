import UIKit

internal struct FKPageViewContainer {
	var pageView: FKPageView
	var controller: UIViewController

	init(controller: UIViewController, pageView: FKPageView) {
		//make sure the controller and the pageview match up
		self.pageView = pageView
		self.controller = controller
	}
}

public class FKPageViewController: UIViewController, UIPageViewControllerDataSource {

	private var currentIndex: Int = 0
	private var pageViewController = UIPageViewController(
		transitionStyle: .Scroll,
		navigationOrientation: .Horizontal,
		options: nil)
	private var pages = [FKPageViewContainer]()
	public var pageSize: CGSize = CGSizeZero {
		didSet {
			self.pageViewController.view.frame = CGRect(
				origin: CGPointZero,
				size: self.pageSize)
		}
	}
    override public func viewDidLoad() {
        super.viewDidLoad()

		self.addChildViewController(self.pageViewController)
		self.view.addSubview(self.pageViewController.view)

		self.view.addConstraint(NSLayoutConstraint(
			item: self.pageViewController.view,
			attribute: .Left,
			relatedBy: .Equal,
			toItem: self.view,
			attribute: .Left,
			multiplier: 1.0,
			constant: 0))
		self.view.addConstraint(NSLayoutConstraint(
			item: self.pageViewController.view,
			attribute: .Right,
			relatedBy: .Equal,
			toItem: self.view,
			attribute: .Right,
			multiplier: 1.0,
			constant: 0))
		self.view.addConstraint(NSLayoutConstraint(
			item: self.pageViewController.view,
			attribute: .Top,
			relatedBy: .Equal,
			toItem: self.view,
			attribute: .Top,
			multiplier: 1.0,
			constant: 0))
		self.view.addConstraint(NSLayoutConstraint(
			item: self.pageViewController.view,
			attribute: .Bottom,
			relatedBy: .Equal,
			toItem: self.view,
			attribute: .Bottom,
			multiplier: 1.0,
			constant: 0))
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FKPageViewController {
	public func addPageView(view: FKPageView) {

		//setup new view controller
		let viewController = UIViewController(nibName: nil, bundle: nil)
		viewController.view.addSubview(view)
		view.setTranslatesAutoresizingMaskIntoConstraints(false)

//		//Add Constraints
//		viewController.view.addConstraint(NSLayoutConstraint(
//			item: viewController.view,
//			attribute: .Width,
//			relatedBy: .Equal,
//			toItem: view,
//			attribute: .Width,
//			multiplier: 1.0,
//			constant: 0))
//		viewController.view.addConstraint(NSLayoutConstraint(
//			item: viewController.view,
//			attribute: .Height,
//			relatedBy: .Equal,
//			toItem: view,
//			attribute: .Height,
//			multiplier: 1.0,
//			constant: 0))
//		viewController.view.addConstraint(NSLayoutConstraint(
//			item: view,
//			attribute: .Left,
//			relatedBy: .Equal,
//			toItem: viewController.view,
//			attribute: .Left,
//			multiplier: 1.0,
//			constant: 0))
//		viewController.view.addConstraint(NSLayoutConstraint(
//			item: view,
//			attribute: .Top,
//			relatedBy: .Equal,
//			toItem: viewController.view,
//			attribute: .Top,
//			multiplier: 1.0,
//			constant: 0))
//		viewController.view.addConstraint(NSLayoutConstraint(
//			item: view,
//			attribute: .Right,
//			relatedBy: .Equal,
//			toItem: viewController.view,
//			attribute: .Right,
//			multiplier: 1.0,
//			constant: 0))
//		viewController.view.addConstraint(NSLayoutConstraint(
//			item: view,
//			attribute: .Bottom,
//			relatedBy: .Equal,
//			toItem: viewController.view,
//			attribute: .Bottom,
//			multiplier: 1.0,
//			constant: 0))

		//setup pageviewcontroller
		self.currentIndex = 0
		self.pageViewController.dataSource = self
		self.pages.append(FKPageViewContainer(controller: viewController, pageView: view))
		self.pageViewController.setViewControllers(
			[self.viewControllersFromPages()[0]],
			direction: .Forward,
			animated: true,
			completion: nil)

		//adjust page size - TODO: NOT NEEDED?
		self.pageSize = CGSize(
			width: view.frame.size.width,
			height: view.frame.size.height)
	}

	private func viewControllersFromPages() -> [UIViewController] {
		var vcs = [UIViewController]()
		for container in self.pages {
			vcs.append(container.controller)
		}
		return vcs
	}

	private func removePageView(view: FKPageView) {
		//TODO: Make this save to use externally
		for index in self.pages.indexesOf(view) {
			self.pages.removeAtIndex(index)
		}
	}

	public func pageViewController(pageViewController: UIPageViewController,
		viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
			if self.currentIndex > 0 {
				self.currentIndex -= 1
			}
			return self.pages[self.currentIndex].controller
	}
	public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		if self.currentIndex < self.pages.count - 1 {
			self.currentIndex += 1
		}
		return self.pages[self.currentIndex].controller
	}
}
