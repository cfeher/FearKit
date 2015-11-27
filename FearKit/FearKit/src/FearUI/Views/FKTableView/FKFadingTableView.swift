import UIKit

private class VisibleCell {
    var indexPath: NSIndexPath
    let rowHeight: CGFloat
    var calculatedAlpha: CGFloat = 1.0
    //    var contentView: UIView?

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
    public var delegate: UITableViewDelegate?
    private let tableView: UITableView
    private var visibleCells = [VisibleCell]() {
        didSet {
            self.visibleCells.each({ visibleCell in
                if let newThing = self.newThings[visibleCell.indexPath] {
                    setAllAlpha(newThing, alpha: visibleCell.calculatedAlpha)
                }
            })
        }
    }
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
    }
}

extension FKFadingTableView: UITableViewDataSource {

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dataSource?.tableView(tableView, cellForRowAtIndexPath: indexPath) ?? UITableViewCell(style: .Default, reuseIdentifier: "")

        self.newThings[indexPath] = cell.contentView
        return cell
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = self.dataSource?.tableView(tableView, numberOfRowsInSection: section) ?? 0
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

    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.delegate?.tableView?(tableView, shouldHighlightRowAtIndexPath: indexPath) ?? false
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.tableView?(tableView, didSelectRowAtIndexPath: indexPath)
    }

    public func insertRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation: UITableViewRowAnimation) {
        indexPaths.each { ip in
            self.adjustIndexPathsFor(.Insert, indexPath: ip)
        }
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: withRowAnimation)
    }

    public func deleteRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation: UITableViewRowAnimation) {
        indexPaths.each { ip in
            self.adjustIndexPathsFor(.Delete, indexPath: ip)
        }
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: withRowAnimation)
    }

    public func reloadRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation: UITableViewRowAnimation) {
        self.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: withRowAnimation)
    }

    public func reloadData() {

        Array(self.newThings.values).each({ view in
            setAllAlpha(view, alpha: 1.0)
        })

        self.newThings.removeAll()
        self.visibleCells.removeAll()
        self.tableView.reloadData()
    }

    enum TableViewAction {
        case Insert
        case Delete
    }

    private func adjustIndexPathsFor(insertOrDelete: TableViewAction, indexPath: NSIndexPath) {

        var newNewThings = [NSIndexPath: UIView]()
        switch insertOrDelete {
        case .Insert:

            let numberOfRowsInSection = self.tableView(self.tableView, numberOfRowsInSection: indexPath.section) - 1

            if self.newThings.count > 0 {
                if indexPath.row == 0 {
                    //increment everything
                    Array(self.newThings.keys).each { key in
                        if key.section == indexPath.section {
                            newNewThings[NSIndexPath(forRow: key.row + 1, inSection: key.section)] = self.newThings[key]

                            self.visibleCells.each { visibleCell in
                                if visibleCell.indexPath.compare(key) == .OrderedSame {
                                    visibleCell.indexPath = NSIndexPath(forRow: key.row + 1, inSection: key.section)
                                }
                            }
                        }
                    }
                } else if indexPath.row < numberOfRowsInSection {
                    //increment after
                    Array(self.newThings.keys).each { key in
                        if key.section == indexPath.section && key.row > indexPath.row {
                            newNewThings[NSIndexPath(forRow: key.row + 1, inSection: key.section)] = self.newThings[key]

                            self.visibleCells.each { visibleCell in
                                if visibleCell.indexPath.compare(key) == .OrderedSame {
                                    visibleCell.indexPath = NSIndexPath(forRow: key.row + 1, inSection: key.section)
                                }
                            }
                        }
                    }
                }
            }
            self.newThings = newNewThings
            break
        case .Delete:
            let numberOfRowsInSection = self.tableView(self.tableView, numberOfRowsInSection: indexPath.section) - 1
            if self.newThings.count > 0 {
                if indexPath.row == 0 {
                    //decrement everything
                    Array(self.newThings.keys).each { key in
                        if key.section == indexPath.section {
                            newNewThings[NSIndexPath(forRow: key.row - 1, inSection: key.section)] = self.newThings[key]

                            self.visibleCells.each { visibleCell in
                                if visibleCell.indexPath.compare(key) == .OrderedSame {
                                    visibleCell.indexPath = NSIndexPath(forRow: key.row - 1, inSection: key.section)
                                }
                            }
                        }
                    }
                } else if indexPath.row < numberOfRowsInSection {
                    //decrement after
                    Array(self.newThings.keys).each { key in
                        if key.section == indexPath.section && key.row > indexPath.row {
                            newNewThings[NSIndexPath(forRow: key.row - 1, inSection: key.section)] = self.newThings[key]

                            self.visibleCells.each { visibleCell in
                                if visibleCell.indexPath.compare(key) == .OrderedSame {
                                    visibleCell.indexPath = NSIndexPath(forRow: key.row - 1, inSection: key.section)
                                }
                            }
                        }
                    }
                }
            }
            self.newThings = newNewThings
            break
        }
        self.visibleCells = self.visibleCellsForContentOffset(self.tableView.contentOffset.y)
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

            let numberOfRows = self.tableView(self.tableView, numberOfRowsInSection: section)
            if numberOfRows <= 0 { return [] }
            for row in 0...numberOfRows - 1 {
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
