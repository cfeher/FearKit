//
//  FKMasterCell.swift
//  FearKit
//
//  Created by Chris Feher on 2015-07-27.
//  Copyright (c) 2015 Chris Feher. All rights reserved.
//

import UIKit

public class FKMasterCell: UITableViewCell {

	public let majorLabel: UILabel = UILabel()
	public var leftImage: UIImage?
	private var leftImageView: UIImageView = UIImageView(frame: CGRectZero)
	private let padding: CGFloat = 10

	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		self.addSubview(self.majorLabel)
		self.addSubview(self.majorLabel)

		//autolayout
		self.addConstraint(NSLayoutConstraint(
			item: self.majorLabel,
			attribute: NSLayoutAttribute.Left,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self.leftImageView,
			attribute: NSLayoutAttribute.Right,
			multiplier: 1.0,
			constant: self.padding))

		self.addConstraint(NSLayoutConstraint(
			item: self.majorLabel,
			attribute: NSLayoutAttribute.Right,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self,
			attribute: NSLayoutAttribute.Right,
			multiplier: 1.0,
			constant: -self.padding))

		self.addConstraint(NSLayoutConstraint(
			item: self.majorLabel,
			attribute: NSLayoutAttribute.Top,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self,
			attribute: NSLayoutAttribute.Top,
			multiplier: 1.0,
			constant: 0))

		self.addConstraint(NSLayoutConstraint(
			item: self.majorLabel,
			attribute: NSLayoutAttribute.Bottom,
			relatedBy: NSLayoutRelation.Equal,
			toItem: self,
			attribute: NSLayoutAttribute.Bottom,
			multiplier: 1.0,
			constant: 0))

		self.layoutIfNeeded()

	}

	required public init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
