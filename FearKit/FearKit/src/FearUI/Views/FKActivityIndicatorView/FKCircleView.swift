import UIKit

internal class FKCircleView: UIView {

    override func layoutSubviews() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.fillColor = UIColor.blueColor().CGColor
        shapeLayer.path = UIBezierPath(ovalInRect: shapeLayer.frame).CGPath
        self.layer.mask = shapeLayer
        self.userInteractionEnabled = true
    }
}
