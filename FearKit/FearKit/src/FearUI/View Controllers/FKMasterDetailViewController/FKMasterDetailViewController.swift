import UIKit

internal struct FKMasterItem {
    let itemTitle: String
    var itemImage: UIImage?
    let itemCallback: ((ord: Int) -> Void)
    let ord: Int
    let viewController: UIViewController
    let detailViewController: FKDetailViewController
    var internalItemCallback: ((FKMasterItem) -> Void)?

    init(masterItem: FKMasterDetailProtocol, internalItemCallback: ((FKMasterItem) -> Void)?) {
        self.itemTitle = masterItem.itemTitle
        self.itemImage = masterItem.itemImage
        self.itemCallback = masterItem.itemCallback
        self.ord = masterItem.ord
        self.viewController = masterItem.viewController

        let dvc = FKDetailViewController()
        dvc.title = masterItem.viewController.title
        dvc.addChildViewController(self.viewController)
        dvc.view.addSubview(masterItem.viewController.view)
        self.detailViewController = dvc
    }
}

public protocol FKMasterDetailProtocol {
    var itemTitle: String { get }
    var itemImage: UIImage? { get }
    var itemCallback: ((ord: Int) -> Void) { get }
    var ord: Int { get }
    var viewController: UIViewController { get }
}

public class FKMasterDetailViewController: UIViewController, FKBottomNavigation {

    var splitPercentage: CGFloat {
        return self.splitPercentageForMasterPanel?() ?? 0.65
    }
    let openAnimationDuration: Double = 0.25
    var detailViewController: FKDetailViewController?
    var masterViewController: FKMasterViewController?
    var navController: FKNavigationViewController?
    var masterItems = [FKMasterItem]()

    //callbacks
    public var willOpenMasterPanel: (() -> (Bool))?
    public var didOpenMasterPanel: (() -> ())?
    public var willCloseMasterPanel: (() -> (Bool))?
    public var didCloseMasterPanel: (() -> ())?
    public var splitPercentageForMasterPanel: (() -> (CGFloat))? {
        didSet {
            self.setup()
        }
    }

    public init(masterDetailItems: [FKMasterDetailProtocol]) {
        super.init(nibName: nil, bundle: nil);

        let itemSelectedCallback: (FKMasterItem) -> Void = { item in
            print("Selected: \(item.itemTitle)")
            self.showDetailViewController(item.detailViewController)
        }
        self.masterItems = masterDetailItems.map({ return FKMasterItem(masterItem: $0, internalItemCallback: itemSelectedCallback) })
        self.view.frame = UIScreen.mainScreen().bounds
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    func setup() {
        //setup
        self.showDetailViewController(self.masterItems.first!.detailViewController)
        self.showMasterViewController(FKMasterViewController(items: self.masterItems))
    }

    private func showDetailViewController(vc: FKDetailViewController!) {

        //Get rid of the old stuff
        let navContFrame = self.navController?.view.frame
        let detailFrame = self.detailViewController?.view.frame

        self.navController?.view.removeFromSuperview()
        self.navController?.removeFromParentViewController()
        self.detailViewController?.view.removeFromSuperview()
        self.detailViewController?.removeFromParentViewController()

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
            width: self.splitPercentage * self.navController!.view.frame.size.width,
            height: self.navController!.view.frame.size.height))
        self.navController?.view.layer.shadowPath = bezPath.CGPath

        if let navContFrame = navContFrame, detailFrame = detailFrame {
            self.detailViewController?.view.frame = detailFrame
            self.navController?.view.frame = navContFrame
        }

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
        vc.view.translatesAutoresizingMaskIntoConstraints = false

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

        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
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
