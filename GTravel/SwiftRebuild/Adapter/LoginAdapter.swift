//
//  LoginAdapter.swift
//  GTravel
//  用于登录的适配器
//
//  Created by aby on 2017/12/19.
//  Copyright © 2017年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

import UIKit

typealias LoginResultCallback = (_ err:Error?, _ msg: String) -> Void

class LoginAdapter: NSObject, GTModelDelegate {
	var model: GTModel = GTModel.shared() // model单例，Objective-C类C
	var loginReslult: LoginResultCallback?
	override init() {
		super.init()
		model.delegate = self
	}
	deinit {
		model.delegate = nil
	}
	/**
	普通登录的方法

	-params: 登录参数
	*/
	func startLogin(_ params: NSDictionary) -> Void {
		model.startNormalLoginWithReview(withParams: params as! [AnyHashable : Any])
	}

	/// 开始获取微信授权
	func weChatLogin() -> Void {
		model.startWeChatAuthentication()
	}

	/// 显示登录页的方法
	///
	/// - Parameters:
	///   - hidden: 是否显示
	///   - animate: 是否有动画
	func showLoginView(_ isShow:Bool, animate: Bool) -> Void {
		let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
		if !isShow {
			delegate.hiddenLoginView(animated: animate)
		} else {
			delegate.showLoginView(animated: animate)
		}
	}
	// MARK: GTModelDelegate model的代理, 以下代理方法中只需要注意处理LoginView的UI变化即可
	func weChatAuthenticationDidSucceed(with model: GTModel!) {
		self.loginReslult?(nil, "登录成功")
	}
	func model(_ model: GTModel!, didLoginWith userItem: GTravelUserItem!) {
		self.loginReslult?(nil, "登录成功")
		self.showLoginView(false, animate: true)
	}
	func model(_ model: GTModel!, operationDidFailedWithError error: Error!) {
		self.loginReslult?(error, "登录失败")
	}
}
