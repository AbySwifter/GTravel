//
//  UIVIewController+HUD.swift
//  GTravel_test
//
//  Created by aby on 2017/12/18.
//  Copyright © 2017年 dragontrail. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

//keyWindow
let KeyWindow: UIWindow = UIApplication.shared.keyWindow!

private var HUDKey = "HUDKey"

// 利用runtime给UIViewController加上一个属性
// 思考有没有其他的解决方案
extension UIViewController {

	var hud: MBProgressHUD? {
		get {
			return (objc_getAssociatedObject(self, &HUDKey) as? MBProgressHUD)!
		}
		set {
			objc_setAssociatedObject(self, &HUDKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	/**
	显示提示信息(有菊花, 一直显示, 不消失)，默认文字“加载中”，默认偏移量0

	- parameter view:    显示在哪个View上
	- parameter hint:    提示信息
	- parameter yOffset: y上的偏移量
	*/
	func showHUD(in view: UIView, hint: String = "加载中...", yOffset: CGFloat? = 0) -> Void {
		let HUD = MBProgressHUD.init(view: view)
		HUD.label.text = hint
		HUD.label.font = UIFont.systemFont(ofSize: 14.0)
		// 设置为false一个点击屏幕的其他地方没有反应
		HUD.isUserInteractionEnabled = true
		// 内容的颜色
		HUD.contentColor = UIColor.init(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.00)
		// UIView的颜色
		HUD.bezelView.color = UIColor.init(hexString: "#000000", alpha: 0.7)
		//style -blur 不透明 -solidColor 透明
		HUD.bezelView.style = .solidColor

		HUD.margin = 12.0
		// 中心的偏移量
		HUD.offset.y = yOffset ?? 0
		view.addSubview(HUD)
		HUD.show(animated: true)
		hud = HUD
	}

	/**
	显示纯文字提示信息(显示在keywindow上)，默认时间2s，默认偏移量0

	- parameter hint: 提示信息
	- parameter duration: 持续时间(不填的话, 默认两秒)
	- parameter yOffset: y上的偏移量
	*/
	func showHintInKeywindow(hint: String, duration: Double = 2.0, yOffset:CGFloat? = 0) {
		let view = KeyWindow
		let HUD = MBProgressHUD(view: view)
		view.addSubview(HUD)
		HUD.animationType = .zoomOut
		HUD.isUserInteractionEnabled = false
		HUD.bezelView.color = UIColor.init(hexString: "#000000", alpha: 0.7)
		HUD.contentColor = UIColor.white
		HUD.mode = .text
		HUD.label.text = hint
		HUD.bezelView.style = .solidColor
		HUD.show(animated: true)
		HUD.removeFromSuperViewOnHide = false
		HUD.offset.y = yOffset ?? 0
		HUD.margin = 12
		HUD.hide(animated: true, afterDelay: duration)
		hud = HUD
	}

	/**
	显示纯文字提示信息，默认时间1.5s，默认偏移量0

	- parameter view: 显示在哪个View上
	- parameter hint: 提示信息
	- parameter duration: 持续时间(不填的话, 默认两秒)
	- parameter yOffset: y上的偏移量
	*/
	func showHint(in view: UIView, hint: String, duration: Double = 1.5, yOffset:CGFloat? = 0) {
		let HUD = MBProgressHUD(view: view)
		view.addSubview(HUD)
		HUD.animationType = .zoomOut
		HUD.bezelView.color = UIColor.init(hexString: "#000000", alpha: 0.7)
		HUD.contentColor = UIColor.white
		HUD.mode = .text
		HUD.label.text = hint
		HUD.label.font = UIFont.systemFont(ofSize: 14.0)
		HUD.isUserInteractionEnabled = false
		HUD.removeFromSuperViewOnHide = false
		HUD.bezelView.style = .solidColor
		HUD.show(animated: true)
		HUD.offset.y = yOffset ?? 0
		HUD.margin = 12
		HUD.hide(animated: true, afterDelay: duration)
		hud = HUD
	}


	/// 移除提示
	func hideHud() {
		//如果解包成功则移除，否则不做任何事
		if let hud = hud {
			hud.hide(animated: true)
		}
	}
}
