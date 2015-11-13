import UIKit

public class FKFadedLineView: UIView {

	public var gradientDirection: GradientDirection = .Vertical {
		didSet {
			self.setNeedsDisplay()
		}
	}
	public var baseColor: UIColor = UIColor.lightGrayColor() {
		didSet {
			self.setNeedsDisplay()
		}
	}

	override public init(frame: CGRect) {
		super.init(frame: frame)
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override public func drawRect(rect: CGRect) {

		var red : CGFloat = 0
		var green : CGFloat = 0
		var blue : CGFloat = 0
		var alpha: CGFloat = 0
		self.baseColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

		//Information for gradient
		let context = UIGraphicsGetCurrentContext()
		let locations: [CGFloat] = [0.0, 0.15, 0.85, 1.0]
		let components: [CGFloat] = [
			red, green, blue, 0.0 /*End of colour 1*/,
			red, green, blue, 1.0/*End of colour 2*/,
			red, green, blue, 1.0/*End of colour 3*/,
			red, green, blue, 0.0/*End of colour 4*/]

		//Create gradient
		let rgbColorspace = CGColorSpaceCreateDeviceRGB();
		let glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, locations.count);

		//Draw gradient
		let currentBounds = self.bounds;
		if self.gradientDirection == .Vertical {

			let topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0);
			let endCenter = CGPointMake(
				CGRectGetMidX(currentBounds),
				currentBounds.size.height);
			CGContextDrawLinearGradient(context, glossGradient, topCenter, endCenter, .DrawsBeforeStartLocation);

		} else if gradientDirection == .Horizontal {

			let leftCenter = CGPointMake(0, CGRectGetMidY(currentBounds));
			let endCenter = CGPointMake(
				currentBounds.size.width,
				CGRectGetMidY(currentBounds));
			CGContextDrawLinearGradient(context, glossGradient, leftCenter, endCenter, .DrawsBeforeStartLocation);
		}
	}
}