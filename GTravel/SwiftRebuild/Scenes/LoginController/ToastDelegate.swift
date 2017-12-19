//
//  ToastDelegate.swift
//  GTravel_test
//
//  Created by aby on 2017/12/18.
//  Copyright © 2017年 dragontrail. All rights reserved.
//

import Foundation

// 用于Model层与视图的交互
protocol ToastDelegate {
	func showTitleToast(_ content: String) -> Void
	func showLoading(_ content: String) -> Void
	func hideLoading() -> Void
}
