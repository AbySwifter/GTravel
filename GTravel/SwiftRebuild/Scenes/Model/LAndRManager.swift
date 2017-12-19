//
//  LAndRManager.swift
//  GTravel_test
//
//	注册登录的数据层管理对象
//
//  Created by aby on 2017/12/18.
//  Copyright © 2017年 dragontrail. All rights reserved.
//

import UIKit

class LAndRManager: NSObject {
	var loginAdapter: LoginAdapter = LoginAdapter.init() // 登录适配器，用于与oc现有的登录逻辑对接
	var delegate: ToastDelegate? // 当前类的代理，用来在VC上展示Toast
	var userName:String? // 登录用户名
	var passWord:String? // 注册用户名
	var isUsrNamAviliable: Bool {
		if let name = self.userName {
			return name != ""
		}
		return false
	}
	var isPWDAviliable: Bool {
		if let pwd = self.passWord {
			return pwd != ""
		}
		return false
	}
	// 登录方法
	func login() -> Void {
		guard isUsrNamAviliable&&isPWDAviliable else {
			var content: String = "用户名和密码不能为空"
			if isUsrNamAviliable && !isPWDAviliable {
				content = "密码不能为空"
			} else if !isUsrNamAviliable && isPWDAviliable {
				content = "用户名不能为空"
			}
			delegate?.showTitleToast(content)
			return
		}
		loginAdapter.loginReslult = {(error: Error?, msg: String) in
			self.delegate?.hideLoading()
			if let err = error {
				// 登录失败
				print(err)
				self.delegate?.showTitleToast("登录失败")
				return
			}
			self.delegate?.showTitleToast("登录成功")
		}
		if let delegate = self.delegate {
			delegate.showLoading("登录中...")
			let params: NSDictionary = NSDictionary.init(dictionary: ["nick_name": (self.userName ?? "") , "pwd": (self.passWord ?? "")])
			loginAdapter.startLogin(params)
		}
	}

	// 微信登录的方法
	func weChatLoginRequest() -> Void {
		loginAdapter.loginReslult = {(error: Error?, msg: String) in
			self.delegate?.hideLoading()
			if let err = error {
				// 登录失败
				print(err)
				self.delegate?.showTitleToast("登录失败")
				return
			}
			self.delegate?.showLoading("登录中...")
		}
		loginAdapter.weChatLogin()
	}

	// 注册方法
	func register() -> Void {
		if let delegate = self.delegate {
			delegate.showLoading("注册中...")
		}
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0){
			self.delegate?.hideLoading()
			self.delegate?.showTitleToast("注册成功")
		}
	}
}
