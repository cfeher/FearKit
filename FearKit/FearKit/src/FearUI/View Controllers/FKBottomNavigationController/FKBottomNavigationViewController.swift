import UIKit

public class FKBottomNavigationViewController: UINavigationController {
	override public func viewDidAppear(animated: Bool) {

		//Move bar to bottom
		self.navigationBar.transform = CGAffineTransformScale(self.navigationBar.transform, 1, -1)
		self.navigationBar.frame = CGRectMake(
			0,
			self.view.frame.size.height - self.navigationBar.frame.size.height,
			self.navigationBar.frame.size.width,
			self.navigationBar.frame.size.height)
	}
}
