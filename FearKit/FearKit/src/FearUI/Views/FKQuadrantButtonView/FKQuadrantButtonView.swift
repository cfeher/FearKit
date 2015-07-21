//
//  QuadrantButtonView.swift
//  TaxiBoss
//
//  Created by Chris Feher on 2015-07-20.
//  Copyright (c) 2015 Chris Feher. All rights reserved.
//

import UIKit

class QuadrantButtonView: UIView {

	private let button1 = UIButton(frame: CGRectZero)
	private let button2 = UIButton(frame: CGRectZero)
	private let button3 = UIButton(frame: CGRectZero)
	private let button4 = UIButton(frame: CGRectZero)

	private let separatorFraction: CGFloat = 0.85
	private let separatorPadding: CGFloat = 10
	private let horizontalSeparator: FadedView = FadedView(frame: CGRectMake(0, 0, 0, 0))
	private let verticalSeparator: FadedView = FadedView(frame: CGRectMake(0, 0, 0, 0))
	private var cachedConstraints: [NSLayoutConstraint] = []

	var topLeftCallback: ((buttonControlState: UIControlState) -> Void)?
	var topRightCallback: ((buttonControlState: UIControlState) -> Void)?
	var bottomLeftCallback: ((buttonControlState: UIControlState) -> Void)?
	var bottomRightCallback: ((buttonControlState: UIControlState) -> Void)?

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addSubview(self.horizontalSeparator)
		self.addSubview(self.verticalSeparator)
		self.addSubview(self.button1)
		self.addSubview(self.button2)
		self.addSubview(self.button3)
		self.addSubview(self.button4)

		self.prepareForConstraints()
		self.setupFadedViews()
		self.setupButtons()
		self.addConstraints(self.cachedConstraints)
		self.layoutIfNeeded()
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	func prepareForConstraints() {
		self.cachedConstraints.removeAll(keepCapacity: true)
		let closure: (view: UIView?) -> () = {(view: UIView?) in
				view?.setTranslatesAutoresizingMaskIntoConstraints(false)
				view?.backgroundColor = UIColor.clearColor()
				(view as? UIButton)?.imageView?.contentMode = .ScaleAspectFit
			}
		self.subviews.map({view in closure(view: view as? UIView)})
	}

	func setupButtons() {
		button1.setImage(UIImage(named: "placeholder"), forState: .Normal)
		button1.addTarget(self, action: Selector("buttonPressEvent:"), forControlEvents: .TouchUpInside)
		button2.setImage(UIImage(named: "placeholder"), forState: .Normal)
		button2.addTarget(self, action: Selector("buttonPressEvent:"), forControlEvents: .TouchUpInside)
		button3.setImage(UIImage(named: "placeholder"), forState: .Normal)
		button3.addTarget(self, action: Selector("buttonPressEvent:"), forControlEvents: .TouchUpInside)
		button4.setImage(UIImage(named: "placeholder"), forState: .Normal)
		button4.addTarget(self, action: Selector("buttonPressEvent:"), forControlEvents: .TouchUpInside)

		// Button 1 is in the top left quadrant
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button1,
			attribute: NSLayoutAttribute.Leading,
			relatedBy: .Equal,
			toItem: self.horizontalSeparator,
			attribute: NSLayoutAttribute.Leading,
			multiplier: 1.0,
			constant: 0))
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button1,
			attribute: NSLayoutAttribute.Top,
			relatedBy: .Equal,
			toItem: self.verticalSeparator,
			attribute: NSLayoutAttribute.Top,
			multiplier: 1.0,
			constant: 0))
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button1,
			attribute: NSLayoutAttribute.Trailing,
			relatedBy: .Equal,
			toItem: self.verticalSeparator,
			attribute: NSLayoutAttribute.Leading,
			multiplier: 1.0,
			constant: -self.separatorPadding))
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button1,
			attribute: NSLayoutAttribute.Bottom,
			relatedBy: .Equal,
			toItem: self.horizontalSeparator,
			attribute: NSLayoutAttribute.Top,
			multiplier: 1.0,
			constant: -self.separatorPadding))

		//Button 2 is in the top right quadrant
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button2,
			attribute: NSLayoutAttribute.Leading,
			relatedBy: .Equal,
			toItem: self.verticalSeparator,
			attribute: NSLayoutAttribute.Trailing,
			multiplier: 1.0,
			constant: self.separatorPadding))
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button2,
			attribute: NSLayoutAttribute.Top,
			relatedBy: .Equal,
			toItem: self.verticalSeparator,
			attribute: NSLayoutAttribute.Top,
			multiplier: 1.0,
			constant: 0))
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button2,
			attribute: NSLayoutAttribute.Trailing,
			relatedBy: .Equal,
			toItem: self.horizontalSeparator,
			attribute: NSLayoutAttribute.Trailing,
			multiplier: 1.0,
			constant: 0))
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button2,
			attribute: NSLayoutAttribute.Bottom,
			relatedBy: .Equal,
			toItem: self.horizontalSeparator,
			attribute: NSLayoutAttribute.Top,
			multiplier: 1.0,
			constant: -self.separatorPadding))

		//Button 3 is in the bottom left quadrant
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button3,
			attribute: NSLayoutAttribute.Leading,
			relatedBy: .Equal,
			toItem: self.horizontalSeparator,
			attribute: NSLayoutAttribute.Leading,
			multiplier: 1.0,
			constant: 0))
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button3,
			attribute: NSLayoutAttribute.Top,
			relatedBy: .Equal,
			toItem: self.horizontalSeparator,
			attribute: NSLayoutAttribute.Bottom,
			multiplier: 1.0,
			constant: self.separatorPadding))//CHANGED FROM -
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button3,
			attribute: NSLayoutAttribute.Trailing,
			relatedBy: .Equal,
			toItem: self.verticalSeparator,
			attribute: NSLayoutAttribute.Leading,
			multiplier: 1.0,
			constant: -self.separatorPadding))
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button3,
			attribute: NSLayoutAttribute.Bottom,
			relatedBy: .Equal,
			toItem: self.verticalSeparator,
			attribute: NSLayoutAttribute.Bottom,
			multiplier: 1.0,
			constant: 0))

		//Button 4 is in the bottom right quadrant
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button4,
			attribute: NSLayoutAttribute.Leading,
			relatedBy: .Equal,
			toItem: self.verticalSeparator,
			attribute: NSLayoutAttribute.Trailing,
			multiplier: 1.0,
			constant: self.separatorPadding))
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button4,
			attribute: NSLayoutAttribute.Top,
			relatedBy: .Equal,
			toItem: self.horizontalSeparator,
			attribute: NSLayoutAttribute.Bottom,
			multiplier: 1.0,
			constant: self.separatorPadding)) //CHANGED FROM -
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button4,
			attribute: NSLayoutAttribute.Trailing,
			relatedBy: .Equal,
			toItem: self.horizontalSeparator,
			attribute: NSLayoutAttribute.Trailing,
			multiplier: 1.0,
			constant: 0))
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.button4,
			attribute: NSLayoutAttribute.Bottom,
			relatedBy: .Equal,
			toItem: self.verticalSeparator,
			attribute: NSLayoutAttribute.Bottom,
			multiplier: 1.0,
			constant: 0))
	}

	func setupFadedViews() {

		//Length of vertical separator is 60% the height of the super view
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.verticalSeparator,
			attribute: NSLayoutAttribute.Height,
			relatedBy: .Equal,
			toItem: self,
			attribute: NSLayoutAttribute.Height,
			multiplier: self.separatorFraction,
			constant: 0))

		//Width of vertical separator is 2
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.verticalSeparator,
			attribute: NSLayoutAttribute.Width,
			relatedBy: .Equal,
			toItem: nil,
			attribute: NSLayoutAttribute.NotAnAttribute,
			multiplier: 1,
			constant: 2))

		//Vertical Separator is centered in view
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.verticalSeparator,
			attribute: NSLayoutAttribute.CenterX,
			relatedBy: .Equal,
			toItem: self,
			attribute: NSLayoutAttribute.CenterX,
			multiplier: 1.0,
			constant: 0))
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.verticalSeparator,
			attribute: NSLayoutAttribute.CenterY,
			relatedBy: .Equal,
			toItem: self,
			attribute: NSLayoutAttribute.CenterY,
			multiplier: 1.0,
			constant: 0))

		//Horizontal Width equal to 0.6 times width of super
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.horizontalSeparator,
			attribute: NSLayoutAttribute.Width,
			relatedBy: .Equal,
			toItem: self,
			attribute: NSLayoutAttribute.Width,
			multiplier: self.separatorFraction,
			constant: 0))

		//Horizontal height equal to width of veritical
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.horizontalSeparator,
			attribute: NSLayoutAttribute.Height,
			relatedBy: .Equal,
			toItem: self.verticalSeparator,
			attribute: NSLayoutAttribute.Width,
			multiplier: 1.0,
			constant: 0))

		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.horizontalSeparator,
			attribute: NSLayoutAttribute.CenterX,
			relatedBy: .Equal,
			toItem: self.verticalSeparator,
			attribute: NSLayoutAttribute.CenterX,
			multiplier: 1.0,
			constant: 0))
		self.cachedConstraints.append(NSLayoutConstraint(
			item: self.horizontalSeparator,
			attribute: NSLayoutAttribute.CenterY,
			relatedBy: .Equal,
			toItem: self.verticalSeparator,
			attribute: NSLayoutAttribute.CenterY,
			multiplier: 1.0,
			constant: 0))

		//Set Gradient Direction
		let lineColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1.0)
		self.horizontalSeparator.baseColor = lineColor
		self.verticalSeparator.baseColor = lineColor
		self.horizontalSeparator.gradientDirection = .Horizontal
		self.verticalSeparator.gradientDirection = .Vertical
	}

	//Button Press
	func buttonPressEvent(button: UIButton) {
		if button == self.button1 {
			self.topLeftCallback?(buttonControlState: button.state)
		} else if button == self.button2 {
			self.topRightCallback?(buttonControlState: button.state)
		} else if button == self.button3 {
			self.bottomLeftCallback?(buttonControlState: button.state)
		} else if button == self.button4 {
			self.bottomRightCallback?(buttonControlState: button.state)
		}
	}

}
