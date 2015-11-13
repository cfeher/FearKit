import UIKit

public class FKDetailViewController: UIViewController, FKBottomNavigation {

	public var showHideButton: UIBarButtonItem? {
		didSet {
			self.navigationItem.leftItemsSupplementBackButton = true
			self.navigationItem.leftBarButtonItem = self.showHideButton
		}
	}

	public init() {
		super.init(nibName: nil, bundle: nil);
		self.title = "Detail"
		self.view.backgroundColor = UIColor.redColor()
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required public init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	override public func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override public func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// FKBottomNavigation protocol
	public var navigationOnBottom = false {
		willSet(newNavigationOnBottom) {
			let titleView = UIView(frame: CGRect(
				x: 0,
				y: 0,
				width: 100,
				height: 30))
			titleView.backgroundColor = UIColor.greenColor()
			self.navigationItem.titleView = titleView
		}
	}
}