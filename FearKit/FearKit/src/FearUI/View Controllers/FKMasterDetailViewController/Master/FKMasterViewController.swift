import UIKit

public class FKMasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    /**

     // MARK: - Public Functionality

     */
    public var majorFont: FKFont = FKFont(
        font: UIFont(name: "Helvetica", size: 20)!,
        color: UIColor.blackColor()) {

        didSet {
            self.tableView.reloadData()
        }
    }

    required public init(items: [FKMasterItem]?) {
        super.init(nibName: nil, bundle: nil);
        items?.each({[weak self] in self?.addFKMasterItem($0)})
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func addFKMasterItem(item: FKMasterItem) {
        items.append(item)
        items.sortInPlace { (item1: FKMasterItem, item2: FKMasterItem) -> Bool in
            return item1.ord < item2.ord
        }
        self.tableView.reloadData()
    }

    public override func viewDidAppear(animated: Bool) {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the table view
        self.view.addSubview(self.tableView)
        setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(self.view, val: false)

        //contsraints
        self.view.addConstraint(NSLayoutConstraint(
            item: self.tableView,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: self.tableView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Top,
            multiplier: 1.0,
            constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: self.tableView,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: self.tableView,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Right,
            multiplier: 1.0,
            constant: 0))
    }

    private var width = CGFloat.max
    public func setWidth(width: CGFloat) {
        self.width = width
        self.tableView.reloadData()
    }

    /**

     // MARK: - Private Functionality

     */

    private var items: [FKMasterItem] = []
    private let tableView = UITableView()

    /**

     // MARK: - UITableView delegate and data source

     */

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    let identifier = "master_row"
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: FKMasterCell
        if let unwrappedCell: AnyObject = tableView.dequeueReusableCellWithIdentifier(self.identifier)
            where (unwrappedCell.isKindOfClass(FKMasterCell)) {

                cell = unwrappedCell as! FKMasterCell

                //set the width
                if self.width != CGFloat.max {
                    cell.cellWidth = self.width
                }

                //assign the values
                let item: FKMasterItem = self.items[indexPath.row]

                cell.majorLabel.attributedText = NSAttributedString(
                    string: item.itemTitle,
                    attributes: [
                        NSForegroundColorAttributeName: self.majorFont.colorValue(),
                        NSFontAttributeName: self.majorFont.fontValue()
                    ])
                if let unwrappedImage = item.itemImage {
                    cell.leftImage = unwrappedImage
                }

        } else {
            tableView.registerClass(FKMasterCell.self,
                forCellReuseIdentifier: self.identifier)
            return self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
        return cell
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item: FKMasterItem = self.items[indexPath.row]
        item.itemCallback(item)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}
