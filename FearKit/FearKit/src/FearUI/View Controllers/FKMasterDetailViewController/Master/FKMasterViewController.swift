import UIKit

public class FKMasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

/**

	// MARK: - Public Functionality

*/

	public struct MasterItem {
		public var itemTitle: String!
		public var itemImage: UIImage?
		public var itemCallback: (MasterItem) -> Void!
		public var ord: Int = Int.min
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

/**

	// MARK: - Private Functionality

*/

	private var items: [MasterItem] = []
	private func addMasterItem(item: MasterItem) {
		items.append(item)
	}

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
		var cell: UITableViewCell
		if let unwrappedCell: AnyObject = tableView.dequeueReusableCellWithIdentifier(self.identifier)
			where (unwrappedCell.isKindOfClass(UITableViewCell)) {

			cell = unwrappedCell as! UITableViewCell
		} else {
			tableView.registerNib(UINib(nibName: "FKMasterCell", bundle: nil), forCellReuseIdentifier: self.identifier)
			return self.tableView(tableView, cellForRowAtIndexPath: indexPath)
		}
		return cell
	}
}
