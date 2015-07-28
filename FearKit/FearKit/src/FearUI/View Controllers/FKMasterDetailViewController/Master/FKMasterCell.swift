import UIKit

public class FKMasterCell: UITableViewCell {

	public let majorLabel: UILabel = UILabel()
	public var leftImage: UIImage?
	private var leftImageView: UIImageView = UIImageView(frame: CGRectZero)
	private let padding: CGFloat = 10

	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		self.addSubview(self.majorLabel)
		self.addSubview(self.leftImageView)
		self.reapplyConstraints()
	}

	required public init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	private func reapplyConstraints() {
		//autolayout
		self.addConstraint(NSLayoutConstraint(
			item: self.majorLabel,
			attribute: NSLayoutAttribute.Leading,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self,
			attribute: NSLayoutAttribute.Leading,
			multiplier: 1.0,
			constant: self.padding))

		self.addConstraint(NSLayoutConstraint(
			item: self.majorLabel,
			attribute: NSLayoutAttribute.Trailing,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self,
			attribute: NSLayoutAttribute.Right,
			multiplier: 1.0,
			constant: -self.padding))

		self.addConstraint(NSLayoutConstraint(
			item: self.majorLabel,
			attribute: NSLayoutAttribute.CenterY,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self,
			attribute: NSLayoutAttribute.CenterY,
			multiplier: 1.0,
			constant: 0))

		self.layoutIfNeeded()
	}
}
