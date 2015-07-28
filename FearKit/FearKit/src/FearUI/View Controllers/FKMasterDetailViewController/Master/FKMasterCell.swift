import UIKit

public class FKMasterCell: UITableViewCell {

	public let majorLabel: UILabel = UILabel()
	public var leftImage: UIImage?
	private var leftImageView: UIImageView = UIImageView(frame: CGRectZero)
	private let padding: CGFloat = 10

	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		// TODO: Use autolayout
		self.majorLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

		self.addSubview(self.majorLabel)
		self.addSubview(self.leftImageView)

	}

	required public init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}