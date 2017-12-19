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
	var delegate: ToastDelegate? // 当前类的代理，用来在VC上展示Toast

	var userName:String? // 登录用户名
	var passWord:String? // 注册用户名

	// 登录方法
	func login() -> Void {
		if let delegate = self.delegate {
			delegate.showLoading("登录中...")
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0){
//				self.delegate?.hideLoading()
//				self.delegate?.showTitleToast("登录成功")
			}
		}
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
