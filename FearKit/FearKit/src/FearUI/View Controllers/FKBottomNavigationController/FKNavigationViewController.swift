import UIKit

public class FKNavigationViewController: UINavigationController, FKBottomNavigation {

	// FKBottomNavigation protocol
	public var navigationOnBottom = true {
		didSet {
			//Move bar to bottom
			self.navigationBar.transform = CGAffineTransformScale(self.navigationBar.transform, 1, -1)
			self.navigationBar.frame = CGRectMake(
				0,
				self.view.frame.size.height - self.navigationBar.frame.size.height,
				self.navigationBar.frame.size.width,
				self.navigationBar.frame.size.height)

			for vc in self.viewControllers {
				if vc.isKindOfClass(FKDetailViewController.self) {
					//need to flip it here
				}
			}
		}
	}
}
