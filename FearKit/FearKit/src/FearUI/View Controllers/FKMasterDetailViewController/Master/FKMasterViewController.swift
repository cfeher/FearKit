import UIKit

public class FKMasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

/**

	// MARK: - Public Functionality

*/
	public var majorFont: FKFont = FKFont(
		font: UIFont(name: "Helvetica", size: 20)!,
		color: UIColor.blackColor()) {

		didSet {
			//reload tableview
			self.tableView.reloadData()
		}
	}

	required public init(items: [MasterItem]?) {
		super.init(nibName: nil, bundle: nil);
		self.view.backgroundColor = UIColor.greenColor()
		items?.map({[weak self] in self?.addMasterItem($0)})

		// Setup the table view
		self.tableView.frame = self.view.frame
		self.view.addSubview(self.tableView)
		self.tableView.dataSource = self
		self.tableView.delegate = self
	}

	required public init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	public func addMasterItem(item: MasterItem) {
		items.append(item)
	}

/**

	// MARK: - Private Functionality

*/

	private var items: [MasterItem] = []
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

				//assign the values
				let item: MasterItem = self.items[indexPath.row]

				//debug
				println(item)
				println(cell)
				println(self.majorFont)

				cell.majorLabel.attributedText = NSAttributedString(
					string: item.itemTitle,
					attributes: [
								NSForegroundColorAttributeName: self.majorFont.colorValue(),
								NSFontAttributeName: self.majorFont.fontValue()
								])

		} else {
			tableView.registerClass(FKMasterCell.self,
				forCellReuseIdentifier: self.identifier)
			return self.tableView(tableView, cellForRowAtIndexPath: indexPath)
		}
		return cell
	}

	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let item: MasterItem = self.items[indexPath.row]
		item.itemCallback(item)
	}
}
