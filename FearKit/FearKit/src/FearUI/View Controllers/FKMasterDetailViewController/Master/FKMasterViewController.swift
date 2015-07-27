import UIKit

public class FKMasterViewController: UIViewController {

	init() {
		super.init(nibName: nil, bundle: nil);
		self.view.backgroundColor = UIColor.greenColor()
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