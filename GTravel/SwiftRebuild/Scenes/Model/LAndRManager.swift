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
	// 登录管理属性
	var userName:String? // 登录用户名
	var passWord:String? // 登录密码
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
	// 注册管理属性
	var nickName: String? // 注册用户名
	var pwdOnce: String? // 注册密码
	var pwdTwice: String? // 注册确认密码
	var isNcikNameAviliable: Bool {
		guard let nickName = self.nickName else { return false }
		return nickName != ""
	}
	var isPwdOnceAviliable : Bool {
		guard let pwdOnce = self.pwdOnce else { return false }
		return pwdOnce != ""
	}
	var isPwdTwiceAviliable: Bool {
		guard let pwdTwice = self.pwdTwice else { return false }
		return pwdTwice != ""
	}
	var isPwdEqual: Bool {
		guard isPwdOnceAviliable&&isPwdTwiceAviliable else {
			return false
		}
		return self.pwdTwice == self.pwdOnce
	}
	/// 自动登录
	func autoLogin() -> Void {
		if self.loginAdapter.canAutoLogin {
			self.delegate?.showLoading("登录中...")
			self.loginAdapter.autoLogin()
		}
	}

	/// 普通登录方法
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

	/// 微信登录的方法
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

	/// 注册方法
	func register() -> Void {
		var notice = ""
		guard self.isNcikNameAviliable else {
			notice = "用户名无效"
			delegate?.showTitleToast(notice)
			return
		}
		guard self.isPwdOnceAviliable else {
			notice = "请输入密码"
			delegate?.showTitleToast(notice)
			return
		}
		guard self.isPwdTwiceAviliable else {
			notice = "请输入确认密码"
			delegate?.showTitleToast(notice)
			return
		}
		guard self.isPwdEqual else {
			notice = "两次输入密码不一致"
			delegate?.showTitleToast(notice)
			return
		}
		loginAdapter.loginReslult = {(error: Error?, msg: String) in
			self.delegate?.hideLoading()
			if let err = error {
				// 登录失败
				print(err)
				self.delegate?.showTitleToast("注册失败")
				return
			}
			self.delegate?.showTitleToast("注册成功，请返回登录")
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "registerSuccess"), object: nil)
		}
		if let delegate = self.delegate {
			delegate.showLoading("注册中...")
			self.loginAdapter.regeistAction(nickName: self.nickName!, passWord: self.pwdOnce!) // 注册方法
		}
	}
}
