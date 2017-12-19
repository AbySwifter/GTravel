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
	var cacheUnit: GTCacheUnit = GTCacheUnit.sharedCache() // 缓存单例，用来检测是否可以自动登录
	var netWorkUnit: GTNetworkUnit = GTNetworkUnit.shared() // 网络请求单例
	var loginReslult: LoginResultCallback?
	private var isUserIDExist: Bool {
		if let userID = cacheUnit.userID {
			return userID != ""
		}
		return false
	}
	private var isNickName: Bool {
		guard let nickname = cacheUnit.userNickName else { return false }
		return nickname != ""
	}
	private var isPWD: Bool {
		guard let pwd = cacheUnit.passWord else { return false }
		return pwd != ""
	}
	var canAutoLogin: Bool {
		return isUserIDExist || (isPWD && isNickName)
	}
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

	/// 自动登录
	func autoLogin() -> Void {
		if self.isUserIDExist {
			// 根据UserID去登录
			model.startToLogin()
		} else if self.isNickName&&self.isPWD {
			model.startNormalAutoLogin()
		}
	}
	// 注册方法
	func regeistAction(nickName: String, passWord:String) -> Void {
		netWorkUnit.registerUser(withNickName: nickName, passWord: passWord, sex: 1) { (error: Error?, responseObject: Any) in
			if let err = error {
				self.loginReslult?(err, "注册失败")
				return
			}
			self.loginReslult?(nil, "注册成功")

		}
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
