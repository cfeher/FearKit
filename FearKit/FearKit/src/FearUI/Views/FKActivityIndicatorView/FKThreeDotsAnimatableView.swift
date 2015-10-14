internal class FKThreeDotsAnimatableView: FKAnimatableView {

    private let colorOne: UIColor
    private let colorTwo: UIColor
    private let dotOne = FKCircleView(frame: CGRectZero)
    private let dotTwo = FKCircleView(frame: CGRectZero)
    private let dotThree = FKCircleView(frame: CGRectZero)
    private var dotDiameter: CGFloat {
        return self.frame.size.width/3.0 - self.dotSpacing/3.0
    }
    private let dotSpacing: CGFloat = 3

    init(frame: CGRect = CGRectZero, colorOne: UIColor, colorTwo: UIColor) {
        self.colorOne = colorOne
        self.colorTwo = colorTwo
        super.init(frame: frame)
        self.setup()
    }

    func setup() {

        self.addSubview(self.dotOne)
        self.addSubview(self.dotTwo)
        self.addSubview(self.dotThree)

        self.dotOne.backgroundColor = colorOne
        self.dotTwo.backgroundColor = colorOne
        self.dotThree.backgroundColor = colorOne

        setTranslatesAutoresizingMaskIntoConstraintsForAllHeirarchy(self, false)

        //dot one
        self.addConstraint(NSLayoutConstraint(
            item: self.dotOne,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotOne,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotOne,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Width,
            multiplier: 1.0/3.0,
            constant: -(self.dotSpacing * 2.0/3.0)))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotOne,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: self.dotOne,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0))

        //dot two
        self.addConstraint(NSLayoutConstraint(
            item: self.dotTwo,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self.dotOne,
            attribute: .Right,
            multiplier: 1.0,
            constant: self.dotSpacing))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotTwo,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotTwo,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Width,
            multiplier: 1.0/3.0,
            constant: -(self.dotSpacing * 2.0/3.0)))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotTwo,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: self.dotTwo,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0))

        //dot three
        self.addConstraint(NSLayoutConstraint(
            item: self.dotThree,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self.dotTwo,
            attribute: .Right,
            multiplier: 1.0,
            constant: self.dotSpacing))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotThree,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotThree,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Width,
            multiplier: 1.0/3.0,
            constant: -(self.dotSpacing * 2.0/3.0)))
        self.addConstraint(NSLayoutConstraint(
            item: self.dotThree,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: self.dotThree,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func animate(_startStop: Bool) {

        self.animating = _startStop
        var fade: (() -> Void)?
        var show: (() -> Void)?

        show = {
            let showOne: () -> Void = {
                self.dotOne.backgroundColor = self.colorOne
            }
            let showTwo: () -> Void = {
                self.dotTwo.backgroundColor = self.colorOne
            }
            let showThree: () -> Void = {
                self.dotThree.backgroundColor = self.colorOne
            }

            UIView.animateKeyframesWithDuration(self.animationSpeed,
                delay: 0.0, options: .CalculationModeLinear, animations: {

                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0/3.0, animations: showOne)

                    UIView.addKeyframeWithRelativeStartTime(1.0/3.0, relativeDuration: 1.0/3.0, animations: showTwo)

                    UIView.addKeyframeWithRelativeStartTime(2.0/3.0, relativeDuration: 1.0/3.0, animations: showThree)

                }) { (complete) -> Void in
                    if self.animating {
                        fade?()
                    }
            }
        }

        fade = {
            let fadeOne: () -> Void = {
                self.dotOne.backgroundColor = self.colorTwo
            }
            let fadeTwo: () -> Void = {
                self.dotTwo.backgroundColor = self.colorTwo
            }
            let fadeThree: () -> Void = {
                self.dotThree.backgroundColor = self.colorTwo
            }

            UIView.animateKeyframesWithDuration(self.animationSpeed,
                delay: 0.0, options: .CalculationModeLinear, animations: {
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0/3.0, animations: fadeOne)

                    UIView.addKeyframeWithRelativeStartTime(1.0/3.0, relativeDuration: 1.0/3.0, animations: fadeTwo)

                    UIView.addKeyframeWithRelativeStartTime(2.0/3.0, relativeDuration: 1.0/3.0, animations: fadeThree)
                    
                }) { (complete) -> Void in
                    show?()
            }
        }
        _startStop ? fade?() : show?()
    }
}