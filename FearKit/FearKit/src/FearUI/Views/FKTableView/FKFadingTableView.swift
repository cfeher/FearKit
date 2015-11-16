import UIKit

public class FKFadingTableView: UIView {
    
    public var dataSource: UITableViewDataSource? {
        didSet {
            self.tableView.reloadData()
        }
    }
    public var delegate: UITableViewDelegate? {
        didSet {
            self.tableView.delegate = self.delegate
        }
    }
    private let tableView: UITableView
    private var lastContentOffset: CGFloat = 0
    
    public init(frame: CGRect, style: UITableViewStyle) {
        self.tableView = UITableView(frame: CGRectZero, style: style)
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.addSubview(self.tableView)
        setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(self, val: false)
        
        self.addConstraint(NSLayoutConstraint(
            item: self.tableView,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.tableView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.tableView,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Right,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.tableView,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0))
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}

extension FKFadingTableView: UITableViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        //calculate a list of visible cells
        let visibleCells = self.visibleCellsForContentOffset(self.tableView.contentOffset.y)
        self.lastContentOffset = self.tableView.contentOffset.y
    }
}

extension FKFadingTableView: UITableViewDataSource {
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dataSource?.tableView(tableView, cellForRowAtIndexPath: indexPath) ?? UITableViewCell(style: .Default, reuseIdentifier: "")
        return cell
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = self.dataSource?.tableView(tableView, numberOfRowsInSection: section) ?? 25
        return num
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return max(self.delegate?.tableView?(tableView, heightForHeaderInSection: section) ?? 40, 20)
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return max(self.delegate?.tableView?(tableView, heightForFooterInSection: section) ?? 40, 20)
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.delegate?.tableView?(tableView, heightForRowAtIndexPath: indexPath) ?? 50
    }
}

extension FKFadingTableView {
    
    func visibleCellsForContentOffset(contentOffset: CGFloat) -> [NSIndexPath] {
        
        let numberOfSections = self.dataSource?.numberOfSectionsInTableView?(self.tableView) ?? 1
        var yVal: CGFloat = -1 * contentOffset
        var visibleCells = [NSIndexPath]()
        
        for section in 0...numberOfSections - 1 {
            let headerHeight = self.tableView(self.tableView, heightForHeaderInSection: section)
            yVal += headerHeight
            for row in 0...self.tableView(self.tableView, numberOfRowsInSection: section) - 1 {
                let ip = NSIndexPath(forRow: row, inSection: section)
                let rowHeight = self.tableView(self.tableView, heightForRowAtIndexPath: ip)
                if yVal >= 0 && yVal <= self.tableView.frame.size.height {
                    visibleCells.append(ip)
                }
                yVal += rowHeight
            }
            let footerHeight = self.tableView(self.tableView, heightForFooterInSection: section)
            yVal += footerHeight
        }
        return visibleCells
    }
}
