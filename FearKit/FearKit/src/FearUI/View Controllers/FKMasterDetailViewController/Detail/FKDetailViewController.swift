import UIKit

public class FKDetailViewController: UIViewController {

	public var showHideButton: UIBarButtonItem? {
		didSet {
			self.navigationItem.leftItemsSupplementBackButton = true
			self.navigationItem.leftBarButtonItem = self.showHideButton
		}
	}

	public init() {
		super.init(nibName: nil, bundle: nil);
		self.title = "Detail"
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required public init(coder aDecoder: NSCoder) {
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
}