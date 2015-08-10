//
//  FKBubbleColorView.swift
//  FearKit
//
//  Created by Chris Feher on 2015-08-10.
//  Copyright (c) 2015 Chris Feher. All rights reserved.
//

import UIKit

public class FKBubbleColorView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        // Drawing code
		for iterator in 1...100 {
			let radius = arc4random() % 100 + 1
			let circleCurve = UIBezierPath(ovalInRect: CGRectMake(CGFloat(radius), CGFloat(radius), CGFloat(radius), CGFloat(radius)))
			let red = arc4random() % 255 + 1 //random for now
			let green = arc4random() % 255 + 1 //random for now
			let blue = arc4random() % 255 + 1 //random for now
			let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
			color.setFill()
			circleCurve.fill()
		}
    }
}
