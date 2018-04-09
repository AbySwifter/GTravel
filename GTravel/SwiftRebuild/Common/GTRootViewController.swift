//
//  DTRootViewController.swift
//  GTravel
//
//  Created by aby on 2018/4/9.
//  Copyright © 2018年 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

import UIKit

class GTRootViewController: UIViewController, SRRefreshDelegate, UIScrollViewDelegate {
	lazy var model: GTModel = GTModel.shared()
	lazy var networkUnit: GTNetworkUnit = GTNetworkUnit.shared()
	lazy var cacheUnit: GTCacheUnit = GTCacheUnit.sharedCache()
	var refreshView: SRRefreshView?
	// MARK: 视图生命周期
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.setNeedsStatusBarAppearanceUpdate()
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	// 重置状态栏样式
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return UIStatusBarStyle.lightContent
	}
	// MARK: 公开方法

	/// 展示登录页面
	///
	/// - Parameters:
	///   - show: 是否展示的bool值
	///   - animated: 是否带动画
	public func showLoginView(_ show: Bool, animated: Bool) -> Void {
		let delegate = UIApplication.shared.delegate as! AppDelegate
		if show {
			delegate.showLoginView(animated: animated)
		} else {
			delegate.hiddenLoginView(animated: animated)
		}
	}
	// 计算图片缩放比
	func height(ForRouteImageSizeRatio ratio:CGFloat, footerHeight: CGFloat, margin:CGFloat) -> CGFloat {
		return ABYWinRect().size.width / ratio + footerHeight + margin
	}

	/// 添加头像变化观察者
	func startUserHeadImageUpdateObserver() -> Void {
		NotificationCenter.default.addObserver(self, selector: #selector(userHeadImageDisUpdateNotification(notification:)), name: NSNotification.Name.init(kGTravelUserHeadImageDidUpdate), object: nil)
	}

	@objc
	func userHeadImageDisUpdateNotification(notification: NSNotification) -> Void {

	}

	/// 停止头像变化观察者
	func stopUserHeadImageUpdateObserver() -> Void {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(kGTravelUserHeadImageDidUpdate), object: nil)
	}

	func openWebDetailView(ofURl strUrl: String) -> Void {
		let webViewController: DTWebViewController = DTWebViewController.init()
		webViewController.strURL = strUrl
		self.navigationController?.pushViewController(webViewController, animated: true)
	}

	func openCityDetail(of cityItem: GTravelCityItem) -> Void {
		let detailViewController: CityDetailViewController = CityDetailViewController.init()
		detailViewController.cityItem = cityItem
		self.navigationController?.pushViewController(detailViewController, animated: true)
	}

	func openTownDetail(of townItem: GTravelTownItem) -> Void {
		let detailViewController: TownsDetailViewController = TownsDetailViewController.init()
		detailViewController.townItem = townItem
		self.navigationController?.pushViewController(detailViewController, animated: true)
	}

	func openRouteDetail(of routeItem: GTravelRouteItem) -> Void {
		let detailViewController: RouteDetailViewController = RouteDetailViewController.init()
		detailViewController.routeItem = routeItem
		self.navigationController?.pushViewController(detailViewController, animated: true)
	}

	func openTipDetail(of tipItem: GTravelToolItem) -> Void {
		let detailViewController: TipDetailViewController = TipDetailViewController.init()
		detailViewController.tipItem = tipItem
		self.navigationController?.pushViewController(detailViewController, animated: true)
	}
	// MARK: SRRefreshDelegate


	// MARK: UIScrollViewDelegate

	// 初始化刷新视图
	func initializedRefreshView(for view: UIView) -> Void {
		let refreshView = SRRefreshView.init(frame: CGRect(x: 0, y: -44, width: ABYWinRect().size.width, height: 44))
		refreshView.delegate = self
		refreshView.slimeMissWhenGoingBack = true
		view.addSubview(refreshView)
	}
}
