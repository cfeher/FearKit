import UIKit

class FKDetailViewController: UIViewController {

	var showHideButton: UIBarButtonItem? {
		didSet {
			self.navigationItem.leftItemsSupplementBackButton = true
			self.navigationItem.leftBarButtonItem = self.showHideButton
		}
	}

	init() {
		super.init(nibName: nil, bundle: nil);
		self.title = "Detail"
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}