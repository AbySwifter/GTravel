//
//  StackView+HitTest.swift
//  GTravel_test
//
//  穿透点击事件的延展
//  Created by aby on 2017/12/18.
//  Copyright © 2017年 dragontrail. All rights reserved.
//

import Foundation

extension UIStackView {
	open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		if let view = superview {
			if view is UIButton {
				return view
			}
		}
		return super.hitTest(point, with: event)
	}
}
