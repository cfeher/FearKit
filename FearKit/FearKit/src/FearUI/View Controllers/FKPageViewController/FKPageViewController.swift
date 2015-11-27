import UIKit

internal struct FKPageViewContainer {
    var pageView: UIView
    var controller: UIViewController

    init(controller: UIViewController, pageView: UIView) {
        //make sure the controller and the pageview match up
        self.pageView = pageView
        self.controller = controller
    }
}

public class FKPageViewController: UIViewController, UIPageViewControllerDataSource {

    private var currentIndex: Int = 0
    private var pageViewController = UIPageViewController(
        transitionStyle: .Scroll,
        navigationOrientation: .Horizontal,
        options: nil)
    private var pages = [FKPageViewContainer]()
    public var pageSize: CGSize = CGSizeZero {
        didSet {
            self.view.frame = CGRect(origin: CGPointZero, size: self.pageSize)
            self.pageViewController.view.frame = self.view.bounds
        }
    }
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FKPageViewController {
    public func addPageView(view: UIView) {

        //setup new view controller
        let viewController = UIViewController(nibName: nil, bundle: nil)
        viewController.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        //setup pageviewcontroller
        self.currentIndex = 0
        self.pageViewController.dataSource = self
        self.pages.append(FKPageViewContainer(controller: viewController, pageView: view))

        //		let tmp = self.viewControllersFromPages() //FIXME: Remove this?
        self.pageViewController.setViewControllers(
            [viewController],
            direction: .Forward,
            animated: true,
            completion: nil)


        //adjust page size - TODO: NOT NEEDED?
        self.pageSize = CGSize(
            width: view.frame.size.width,
            height: view.frame.size.height)
    }

    private func viewControllersFromPages() -> [UIViewController] {
        var vcs = [UIViewController]()
        for container in self.pages {
            vcs.append(container.controller)
        }
        return vcs
    }

    public func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            if self.currentIndex > 0 {
                self.currentIndex -= 1
            }
            return self.pages[self.currentIndex].controller
    }
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if self.currentIndex < self.pages.count - 1 {
            self.currentIndex += 1
        }
        return self.pages[self.currentIndex].controller
    }
}
