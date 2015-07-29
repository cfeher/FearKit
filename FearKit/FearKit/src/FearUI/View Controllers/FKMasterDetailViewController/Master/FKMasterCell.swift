import UIKit

public class FKMasterCell: UITableViewCell {

	public let majorLabel: UILabel = UILabel()
	public var leftImage: UIImage? {
		didSet {
			self.leftImageView.image = self.leftImage!
			self.reapplyConstraints()
		}
	}
	private var leftImageView: UIImageView = UIImageView(frame: CGRectZero)
	private let padding: CGFloat = 10
	private var consts: [NSLayoutConstraint] = []

	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		self.contentView.addSubview(self.majorLabel)
		self.contentView.addSubview(self.leftImageView)
		self.reapplyConstraints()
	}

	required public init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	public var cellWidth = CGFloat.max {
		didSet {
			self.reapplyConstraints()
		}
	}
	
	private func reapplyConstraints() {
		//autolayout
		self.majorLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.leftImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
		for constraint in self.consts { self.contentView.removeConstraint(constraint) }
		self.consts = []

		//Content view
		if self.cellWidth != CGFloat.max {
			consts.append(NSLayoutConstraint(
				item: self.contentView,
				attribute: NSLayoutAttribute.Width,
				relatedBy: NSLayoutRelation.Equal,
				toItem: nil,
				attribute: NSLayoutAttribute.NotAnAttribute,
				multiplier: 1.0,
				constant: self.cellWidth))
		}

		// Left Image
		consts.append(NSLayoutConstraint(
			item: self.leftImageView,
			attribute: NSLayoutAttribute.CenterY,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self.contentView,
			attribute: NSLayoutAttribute.CenterY,
			multiplier: 1.0,
			constant: 0))
		consts.append(NSLayoutConstraint(
			item: self.leftImageView,
			attribute: NSLayoutAttribute.Height,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self.contentView,
			attribute: NSLayoutAttribute.Height,
			multiplier: 1.0,
			constant: -self.padding))
		consts.append(NSLayoutConstraint(
			item: self.leftImageView,
			attribute: NSLayoutAttribute.Left,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self.contentView,
			attribute: NSLayoutAttribute.Left,
			multiplier: 1.0,
			constant: self.padding/2.0))
		if let unwrappedImage = self.leftImage {
			consts.append(NSLayoutConstraint(
				item: self.leftImageView,
				attribute: NSLayoutAttribute.Width,
				relatedBy: NSLayoutRelation.Equal,
				toItem: self.leftImageView,
				attribute: NSLayoutAttribute.Height,
				multiplier: 1.0,
				constant: 0))
		} else {
			consts.append(NSLayoutConstraint(
				item: self.leftImageView,
				attribute: NSLayoutAttribute.Width,
				relatedBy: NSLayoutRelation.Equal,
				toItem: nil,
				attribute: NSLayoutAttribute.NotAnAttribute,
				multiplier: 1.0,
				constant: 0))
		}


		// Label
		consts.append(NSLayoutConstraint(
			item: self.majorLabel,
			attribute: NSLayoutAttribute.Leading,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self.leftImageView,
			attribute: NSLayoutAttribute.Right,
			multiplier: 1.0,
			constant: self.padding))

		consts.append(NSLayoutConstraint(
			item: self.majorLabel,
			attribute: NSLayoutAttribute.Trailing,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self.contentView,
			attribute: NSLayoutAttribute.Right,
			multiplier: 1.0,
			constant: -self.padding))

		consts.append(NSLayoutConstraint(
			item: self.majorLabel,
			attribute: NSLayoutAttribute.CenterY,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self.contentView,
			attribute: NSLayoutAttribute.CenterY,
			multiplier: 1.0,
			constant: 0))

		consts.append(NSLayoutConstraint(
			item: self.majorLabel,
			attribute: NSLayoutAttribute.Height,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self.contentView,
			attribute: NSLayoutAttribute.Height,
			multiplier: 1.0,
			constant: 0)
		)

		self.contentView.addConstraints(self.consts)
		self.contentView.layoutIfNeeded()
	}
}
