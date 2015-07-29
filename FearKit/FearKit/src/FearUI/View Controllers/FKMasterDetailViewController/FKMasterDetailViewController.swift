import UIKit

public class FKMasterDetailViewController: UIViewController {

	let splitPercentage: CGFloat = 0.65
	let openAnimationDuration: Double = 0.25
	var detailViewController: FKDetailViewController?
	var masterViewController: FKMasterViewController?
	var navController: FKNavigationViewController?

	public init() {
		super.init(nibName: nil, bundle: nil);
		self.view.frame = UIScreen.mainScreen().bounds
	}

	required public init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	override public func viewDidLoad() {
        super.viewDidLoad()
	}


	override public func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	public func addDetailViewController(vc: FKDetailViewController!) {

		//Get rid of the old stuff
		self.navController?.view.removeFromSuperview()
		self.navController?.removeFromParentViewController()
		self.navController?.view.removeFromSuperview()
		self.detailViewController?.view.removeFromSuperview()
		self.detailViewController?.removeFromParentViewController()
		self.detailViewController?.view.removeFromSuperview()

		//Add new stuff
		self.detailViewController = vc
		let barButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("masterStateChange"))
		self.detailViewController?.showHideButton = barButton

		self.navController = FKNavigationViewController(rootViewController: self.detailViewController!)
		self.navController?.view.layer.shadowOffset = CGSizeMake(-3, 3)
		self.navController?.view.layer.shadowRadius = 5
		self.navController?.view.layer.shadowOpacity = 0.5

		let bezPath = UIBezierPath(rect: CGRect(x: 0,
			y: 0,
			width: 0.5 * self.navController!.view.frame.size.width,
			height: self.navController!.view.frame.size.height))
		self.navController?.view.layer.shadowPath = bezPath.CGPath

		self.addChildViewController(self.navController!)
		self.view.addSubview(self.navController!.view)
		self.view.bringSubviewToFront(self.navController!.view)
	}

	public func addMasterViewController(vc: FKMasterViewController) {

		//Get rid of the old stuff
		self.masterViewController?.view.removeFromSuperview()
		self.masterViewController?.removeFromParentViewController()
		self.masterViewController?.view.removeFromSuperview()

		//Add new stuff
		self.masterViewController = vc
		self.view.addSubview(self.masterViewController!.view)
		self.view.sendSubviewToBack(self.masterViewController!.view)
	}

	func hideMaster(animated: Bool) {
		let closedRect = CGRect(
			x: 0,
			y: 0,
			width: self.view.frame.size.width,
			height: self.view.frame.size.height)

		if animated {
			UIView.animateWithDuration(self.openAnimationDuration,
				delay: 0.0,
				usingSpringWithDamping: 1.0,
				initialSpringVelocity: 1.0,
				options: .AllowUserInteraction,
				animations: { () -> Void in
					self.navController?.view.frame = closedRect
			}, completion: nil)
		} else {
			self.navController?.view.frame = closedRect
		}
	}

	func showMaster(animated: Bool) {
		let openRect = CGRect(
			x: self.view.frame.size.width * self.splitPercentage,
			y: 0,
			width: self.view.frame.size.width,
			height: self.view.frame.size.height)

		if animated {
			UIView.animateWithDuration(self.openAnimationDuration,
				delay: 0.0,
				usingSpringWithDamping: 1.0,
				initialSpringVelocity: 1.0,
				options: .AllowUserInteraction,
				animations: { () -> Void in
					self.navController?.view.frame = openRect
				}, completion: nil)
		} else {
			self.navController?.view.frame = openRect
		}
	}

	var buttonState = false
	func masterStateChange() {
		self.buttonState = !self.buttonState
		switch self.buttonState {
		case true:
			self.showMaster(true)
		default:
			self.hideMaster(true)
		}
	}
}
