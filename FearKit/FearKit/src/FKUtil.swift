import Foundation
import UIKit

// Definitions
public struct FKFont {
	private var font: UIFont
	private var color: UIColor

	public init(font: UIFont, color: UIColor) {
		self.font = font
		self.color = color
	}

	public func colorValue() -> UIColor {
		return self.color
	}
	public func fontValue() -> UIFont {
		return self.font
	}
}

public struct MasterItem {
	public let itemTitle: String!
	public var itemImage: UIImage?
	public let itemCallback: ((MasterItem) -> Void)!
	public let ord: Int!

	public init(itemTitle: String, itemImage: UIImage?, ord: Int = Int.min, itemCallback: (MasterItem) -> Void) {
		self.itemTitle = itemTitle
		self.itemImage = itemImage
		self.itemCallback = itemCallback
		self.ord = ord
	}
}

public protocol FKBottomNavigation {
	var navigationOnBottom: Bool { get set }
}

public protocol FKTableViewDelegate {
	func numberOfRowsInTableView(tableView: UITableView) -> Int
	func tableView(tableView: UITableView, cellForRow row: Int) -> UITableViewCell
	func tableView(tableView: UITableView, didSelectRow row: Int)
	func tableView(tableView: UITableView, heightForRow row: Int) -> CGFloat
	func topView(thatFitsIn: CGSize) -> UIView
	func tableView(tableView: UITableView, editActionsForRow row: Int) -> [AnyObject]?
}

func < (size1: CGSize, size2: CGSize) -> Bool {
	return size1.width * size1.height < size2.width * size2.height
}
func > (size1: CGSize, size2: CGSize) -> Bool {
	return size1.width * size1.height > size2.width * size2.height
}
func == (size1: CGSize, size2: CGSize) -> Bool {
	return size1.width * size1.height == size2.width * size2.height
}
func <= (size1: CGSize, size2: CGSize) -> Bool {
	return size1.width * size1.height <= size2.width * size2.height
}
func >= (size1: CGSize, size2: CGSize) -> Bool {
	return size1.width * size1.height >= size2.width * size2.height
}

public enum GradientDirection {
	case Horizontal, Vertical
}

public func delay(delay:Double, closure:()->()) {
	dispatch_after(
		dispatch_time(
			DISPATCH_TIME_NOW,
			Int64(delay * Double(NSEC_PER_SEC))
		),
		dispatch_get_main_queue(), closure)
}

extension Array {
	func indexesOf<T : Equatable>(object:T) -> [Int] {
		var result: [Int] = []
		for (index,obj) in enumerate(self) {
			if obj as! T == object {
				result.append(index)
			}
		}
		return result
	}
}

public func setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(root: UIView, val: Bool) {
	for view in root.subviews {
		view.setTranslatesAutoresizingMaskIntoConstraints(val)
		if view.subviews.count > 0 {
			setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(view as! UIView, val)
		}
	}
}