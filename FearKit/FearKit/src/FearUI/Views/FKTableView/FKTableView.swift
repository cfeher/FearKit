import UIKit

public class FKTableView: UIView, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Private Properties
    private let tableView: UITableView = UITableView(frame: CGRectZero)
    private let scrollView: CustomScrollView = CustomScrollView(frame: CGRectZero)
    private let topView: UIView = UIView(frame: CGRectZero)
    private var consts: [NSLayoutConstraint] = []
    private let identifier = "master_row"
    private var numRows = 0 {
        didSet(old) {
            if old != self.numRows {
                self.updateTableViewHeight()
            }
        }
    }

    //Mark: - Public Properties
    public var delegate: FKTableViewDelegate? {
        didSet {
            self.layoutIfNeeded()
            self.tableView.reloadData()
            self.updateTableViewHeight()
            self.updateTopView()
        }
    }
    public var tableViewBackgroundColor = UIColor.whiteColor() {
        didSet {
            self.tableView.backgroundColor = self.tableViewBackgroundColor
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()

        //colors for seeing stuff
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.topView.backgroundColor = UIColor.blackColor()

        //drop shadow
        self.tableView.layer.masksToBounds = false;
        self.tableView.layer.shadowOffset = CGSizeMake(0, -5);
        self.tableView.layer.shadowOpacity = 0.3;
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.topView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.scrollEnabled = false
        self.scrollView.bounces = false
        self.scrollView.showsVerticalScrollIndicator = false
        for const in self.consts { self.removeConstraint(const) }
        for view in self.subviews { view.removeFromSuperview() }
        self.consts = []
        self.addSubview(self.topView)
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.tableView)

        //topview
        consts.append(NSLayoutConstraint(
            item: self.topView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0))
        consts.append(NSLayoutConstraint(
            item: self.topView,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0))
        consts.append(NSLayoutConstraint(
            item: self.topView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1.0,
            constant: 0))
        consts.append(NSLayoutConstraint(
            item: self.topView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 6/10.0,
            constant: 0))

        //scrollview
        consts.append(NSLayoutConstraint(
            item: self.scrollView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0))
        consts.append(NSLayoutConstraint(
            item: self.scrollView,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0))
        consts.append(NSLayoutConstraint(
            item: self.scrollView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1.0,
            constant: 0))
        consts.append(NSLayoutConstraint(
            item: self.scrollView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: 0))

        self.addConstraints(self.consts)
        self.layoutIfNeeded()
    }

    private func updateTableViewHeight() {
        var totalHeight: CGFloat = 0
        if self.numRows > 0 {
            for row in 0...self.numRows - 1 {
                totalHeight += self.tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: row, inSection: 0))
            }
        }

        //Table view needs to fill the remainder of the screen
        if totalHeight < self.frame.size.height - self.topView.frame.size.height {
            totalHeight = self.frame.size.height - self.topView.frame.size.height
        }

        //update the height of the tableview
        self.tableView.frame = CGRect(
            x: self.tableView.frame.origin.x,
            y: self.tableView.frame.origin.y,
            width: self.scrollView.frame.size.width,
            height: totalHeight)

        //make sure top view is visible
        self.scrollView.contentInset = UIEdgeInsets(
            top: self.topView.frame.size.height,
            left: 0.0,
            bottom: 0.0,
            right: 0.0)

        //this makes it so we can scroll
        self.scrollView.contentSize = CGSizeMake(
            self.scrollView.frame.size.width,
            self.tableView.frame.size.height)

        self.layoutIfNeeded()
    }

    func updateTopView() {
        if let view = self.delegate?.topView(topView.frame.size) where view.frame.size <= self.topView.frame.size {
            view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
            self.topView.addSubview(view)
        }
        self.bringSubviewToFront(self.scrollView)
    }
}

extension FKTableView {
    // Table View Delegate and Data Source
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let del = self.delegate {
            self.numRows = del.numberOfRowsInTableView(tableView)
        } else {
            self.numRows = 1
        }
        return self.numRows
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let del = self.delegate {
            return del.tableView(tableView, cellForRow: indexPath.row)
        } else {
            return UITableViewCell(style: .Default, reuseIdentifier: self.identifier)
        }
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.tableView(tableView, didSelectRow: indexPath.row)
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let del = self.delegate {
            return del.tableView(tableView, heightForRow: indexPath.row)
        } else {
            return 60
        }
    }
    public func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return self.delegate?.tableView(tableView, editActionsForRow: indexPath.row) as? [UITableViewRowAction]
    }
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

    }
}

extension FKTableView {
    //Table View Methods
    public func insertSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        self.tableView.insertSections(sections, withRowAnimation: animation)
        self.updateTableViewHeight()
    }
    public func deleteSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        self.tableView.deleteSections(sections, withRowAnimation: animation)
        self.updateTableViewHeight()
    }
    public func reloadSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        self.tableView.reloadSections(sections, withRowAnimation: animation)
    }
    public func moveSection(section: Int, toSection newSection: Int) {
        self.tableView.moveSection(section, toSection: newSection)
    }
    public func insertRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        self.updateTableViewHeight()
    }
    public func deleteRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        self.updateTableViewHeight()
    }
    public func reloadRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        self.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
    }
    public func moveRowAtIndexPath(indexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath) {
        self.tableView.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
    }
}

internal class CustomScrollView: UIScrollView {
    func touchIntersectsTransparentRegion(point: CGPoint) -> Bool {
        for view in self.subviews {

            let alteredFrame = CGRect(
                origin: CGPoint(
                    x: view.frame.origin.x,
                    y: view.frame.origin.y + -self.contentOffset.y),
                size: view.frame.size)
            let alteredPoint = CGPoint(
                x: point.x,
                y: point.y + -self.contentOffset.y)

            if alteredPoint.y > alteredFrame.origin.y && alteredPoint.y <= alteredFrame.origin.y + alteredFrame.size.height {
                return false
            }
        }
        return true
    }
}
