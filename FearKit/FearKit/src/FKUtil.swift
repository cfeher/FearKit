import Foundation

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

	public init(itemTitle: String, itemImage: UIImage?, itemCallback: (MasterItem) -> Void, ord: Int = Int.min) {
		self.itemTitle = itemTitle
		self.itemImage = itemImage
		self.itemCallback = itemCallback
		self.ord = ord
	}
}