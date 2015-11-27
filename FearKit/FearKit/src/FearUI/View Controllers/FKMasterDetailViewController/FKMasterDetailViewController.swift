import UIKit

public class FKMasterDetailViewController: UIViewController, FKBottomNavigation {

    var splitPercentage: CGFloat {
        return self.splitPercentageForMasterPanel?() ?? 0.65
    }
    let openAnimationDuration: Double = 0.25
    var detailViewController: FKDetailViewController?
    var masterViewController: FKMasterViewController?
    var navController: FKNavigationViewController?
    let masterItems: [FKMasterItem]

    //callbacks
    public var willOpenMasterPanel: (() -> (Bool))?
    public var didOpenMasterPanel: (() -> ())?
    public var willCloseMasterPanel: (() -> (Bool))?
    public var didCloseMasterPanel: (() -> ())?
    public var splitPercentageForMasterPanel: (() -> (CGFloat))?

    public init(masterDetailItems: [FKMasterItem]) {
        self.masterItems = masterDetailItems
        super.init(nibName: nil, bundle: nil);
        self.view.frame = UIScreen.mainScreen().bounds
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        //setup
        self.showMasterViewController(FKMasterViewController(items: self.masterItems))
        self.showDetailViewController(self.masterItems.first!.detailViewController)
    }

    private func showDetailViewController(vc: FKDetailViewController!) {

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

    private func showMasterViewController(vc: FKMasterViewController) {

        //Get rid of the old stuff
        self.masterViewController?.view.removeFromSuperview()
        self.masterViewController?.removeFromParentViewController()
        self.masterViewController?.view.removeFromSuperview()

        //Add new stuff
        self.masterViewController = vc
        self.view.addSubview(self.masterViewController!.view)
        self.view.sendSubviewToBack(self.masterViewController!.view)

        //contsraints
        self.view.addConstraint(NSLayoutConstraint(
            item: vc.view,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: vc.view,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Top,
            multiplier: 1.0,
            constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: vc.view,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: vc.view,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Width,
            multiplier: self.splitPercentage,
            constant: 0))
    }

    func hideMaster(animated: Bool) {
        let boolVal = self.willCloseMasterPanel?() == nil ? false : !self.willCloseMasterPanel!()
        if boolVal { return }
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
                }, completion: { complete in
                    if complete {
                        self.didCloseMasterPanel?()
                    }
            })
        } else {
            self.navController?.view.frame = closedRect
        }
    }

    func showMaster(animated: Bool) {
        let boolVal = self.willOpenMasterPanel?() == nil ? false : !self.willOpenMasterPanel!()
        if boolVal { return }
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
                }, completion: { complete in
                    if complete {
                        self.didOpenMasterPanel?()
                    }
            })
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

    // FKBottomNavigation protocol
    public var navigationOnBottom = false {
        didSet {
            self.navController?.navigationOnBottom = self.navigationOnBottom
        }
    }
}
