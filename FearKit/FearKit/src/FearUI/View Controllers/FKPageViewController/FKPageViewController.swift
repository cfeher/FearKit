import UIKit

public class FKPageViewController: UIViewController {

	private let pageViewController = UIPageViewController(
		transitionStyle: .Scroll,
		navigationOrientation: .Horizontal,
		options: nil)
	private var pages = [FKPageView]()

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

	public func addPageView(view: FKPageView) {
		self.pages.append(view)
	}

	public func removePageView(view: FKPageView) {
		for index in self.pages.indexesOf(view) {
			self.pages.removeAtIndex(index)
		}
	}
}
