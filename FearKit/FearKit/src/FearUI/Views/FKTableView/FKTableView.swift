import UIKit

public class FKTableView: UIView, UITableViewDelegate, UITableViewDataSource {

	// MARK: - Private Properties
	private let tableView: UITableView = UITableView(frame: CGRectZero)
	private let scrollView: UIScrollView = UIScrollView(frame: CGRectZero)
	private let topView: UIView = UIView(frame: CGRectZero)
	private var consts: [NSLayoutConstraint] = []

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
		self.topView.backgroundColor = UIColor.orangeColor()

	}

	required public init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		self.scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.topView.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.scrollEnabled = false
		self.scrollView.bounces = false
		self.scrollView.showsVerticalScrollIndicator = false
		for const in self.consts { self.removeConstraint(const) }
		for view in self.subviews { (view as? UIView)?.removeFromSuperview() }
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
			multiplier: 4.0/10.0,
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
		println(self.topView.frame)
		var totalHeight: CGFloat = 0
		for row in 0...self.tableView(self.tableView, numberOfRowsInSection: 0) {
			totalHeight += self.tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: row, inSection: 0))
		}

		//Table view needs to fill the remainder of the screen
		if totalHeight < self.frame.size.height - self.topView.frame.size.height {
			totalHeight = self.frame.size.height
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
	}

	// MARK: - Table View Delegate and Data Source
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let del = self.delegate {
			return del.numberOfRowsInTableView(tableView)
		} else {
			return 1
		}
	}

	let identifier = "master_row"
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
}
