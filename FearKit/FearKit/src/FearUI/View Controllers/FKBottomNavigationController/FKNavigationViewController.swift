import UIKit

public class FKNavigationViewController: UINavigationController, FKBottomNavigation {

	// FKBottomNavigation protocol
	public var navigationOnBottom = false {
		willSet(newNavigationOnBottom) {
			if newNavigationOnBottom && !self.navigationOnBottom {
				// coming from right side up
				self.navigationBar.transform = CGAffineTransformScale(self.navigationBar.transform, 1, -1)
				self.navigationBar.frame = CGRectMake(
					0,
					self.view.frame.size.height - self.navigationBar.frame.size.height,
					self.navigationBar.frame.size.width,
					self.navigationBar.frame.size.height)

				for vc in self.viewControllers {
					if vc.isKindOfClass(FKDetailViewController.self) {
						(vc as! FKDetailViewController).navigationOnBottom = newNavigationOnBottom
					}
				}
			} else if !newNavigationOnBottom && self.navigationOnBottom {
				// coming from upside down
			}
		}
	}
}
