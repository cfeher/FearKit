import UIKit

public class FKBubbleColorView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        // Drawing code
		for iterator in 1...100 {
			if iterator == 0 {
				let outerBez = UIBezierPath(rect: self.bounds)
				let red = arc4random() % 255 + 1 //random for now
				let green = arc4random() % 255 + 1 //random for now
				let blue = arc4random() % 255 + 1 //random for now
				let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
				color.setFill()
				outerBez.fill()
			} else {
				let radius = arc4random() % 100 + 1
				let x = Int(arc4random()) % Int(self.frame.size.width)
				let y = Int(arc4random()) % Int(self.frame.size.height)
				let circleCurve = UIBezierPath(ovalInRect: CGRectMake(CGFloat(x), CGFloat(y), CGFloat(radius), CGFloat(radius)))
				let red = arc4random() % 255 + 1 //random for now
				let green = arc4random() % 255 + 1 //random for now
				let blue = arc4random() % 255 + 1 //random for now
				let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
				color.setFill()
				circleCurve.fill()
			}
		}
    }
}
