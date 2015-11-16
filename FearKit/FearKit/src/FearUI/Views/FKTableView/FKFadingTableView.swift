import UIKit

private class VisibleCell {
    let indexPath: NSIndexPath
    let rowHeight: CGFloat
    var calculatedAlpha: CGFloat = 1.0
    var contentView: UIView?

    init(indexPath: NSIndexPath, rowHeight: CGFloat) {
        self.indexPath = indexPath
        self.rowHeight = rowHeight
    }
}

private func == (cell1: VisibleCell, cell2: VisibleCell) -> Bool {
    return cell1.indexPath.compare(cell2.indexPath) == NSComparisonResult.OrderedSame
}

public class FKFadingTableView: UIView {
    
    public var dataSource: UITableViewDataSource? {
        didSet {
            self.tableView.reloadData()
        }
    }
    public var delegate: UITableViewDelegate? {
        didSet {
//            self.tableView.delegate = self.delegate
        }
    }
    private let tableView: UITableView
    private var visibleCells = [VisibleCell]()
    private var newThings = [NSIndexPath: UIView]()
    override public var backgroundColor: UIColor? {
        didSet {
            self.tableView.backgroundColor = backgroundColor
        }
    }
    public init(frame: CGRect, style: UITableViewStyle) {
        self.tableView = UITableView(frame: CGRectZero, style: style)
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        self.tableView = UITableView(frame: CGRectZero, style: .Grouped)
        super.init(frame: CGRectZero)
        self.setup()
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
        self.visibleCells = self.visibleCellsForContentOffset(self.tableView.contentOffset.y)

        self.visibleCells.each({ visibleCell in
            if let newThing = self.newThings[visibleCell.indexPath] {
                setAllAlpha(newThing, alpha: visibleCell.calculatedAlpha)
            }
        })
    }
}

extension FKFadingTableView {
    public func reloadData() {
        self.newThings = nil
        self.tableView.reloadData()
    }
}

extension FKFadingTableView: UITableViewDataSource {
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dataSource?.tableView(tableView, cellForRowAtIndexPath: indexPath) ?? UITableViewCell(style: .Default, reuseIdentifier: "")
        
        self.newThings[indexPath] = cell.contentView
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
    
    private func visibleCellsForContentOffset(contentOffset: CGFloat) -> [VisibleCell] {
        
        let numberOfSections = self.dataSource?.numberOfSectionsInTableView?(self.tableView) ?? 1
        var yVal: CGFloat = -1 * contentOffset
        var visibleCells = [VisibleCell]()
        
        for section in 0...numberOfSections - 1 {
            let headerHeight = self.tableView(self.tableView, heightForHeaderInSection: section)
            yVal += headerHeight
            for row in 0...self.tableView(self.tableView, numberOfRowsInSection: section) - 1 {
                let ip = NSIndexPath(forRow: row, inSection: section)
                let rowHeight = self.tableView(self.tableView, heightForRowAtIndexPath: ip)
                yVal += rowHeight
                if yVal >= 0 {
                    let visibleCell = VisibleCell(indexPath: ip, rowHeight: rowHeight)
                    
                    if yVal <= self.tableView.frame.size.height {
                        if visibleCells.count <= 1 {
                            if fabs(yVal/rowHeight) <= 2 {
                                visibleCell.calculatedAlpha = max(fabs(yVal/rowHeight) - 1, 0)
                            }
                        }
                        visibleCells.append(visibleCell)
                    }
                }
            }
            let footerHeight = self.tableView(self.tableView, heightForFooterInSection: section)
            yVal += footerHeight
        }
        return visibleCells
    }
}
