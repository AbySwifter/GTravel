//
//  RegistViewController.swift
//  GTravel_test
//
//  Created by aby on 2017/12/15.
//  Copyright © 2017年 dragontrail. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController, ToastDelegate {

	@IBOutlet weak var cancelBtn: UIButton!
	@IBOutlet weak var nickNameTextField: UITextField!
	@IBOutlet weak var secretTextfield: UITextField!
	@IBOutlet weak var sureSecretTextField: UITextField!
	@IBOutlet weak var regiestBtn: UIButton!
	lazy var manager: LAndRManager = {
		let manager = LAndRManager.init()
		manager.delegate = self
		return manager
	}()

	let isWeChatInstall: Bool = {
		let isWxInstall = WXApi.isWXAppInstalled()
		return isWxInstall
	}()
	// MARK: 视图的生命周期
	override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(registerSuccess), name: NSNotification.Name.init("registerSuccess"), object: nil)
		self.view.backgroundColor = UIColor.init(hexString: "#0F0F0F")
        // Do any additional setup after loading the view.
		self.regiestBtn.layer.cornerRadius = 6.0
		addBottomButtons()
    }
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.manager.delegate = nil
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.manager.delegate = self
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// 底部的按钮组
	func addBottomButtons() -> Void {
		let goRegistButton = UIButton.init(type: UIButtonType.custom)
		self.view.addSubview(goRegistButton)
		goRegistButton.mas_makeConstraints { (make) in
			make?.width.equalTo()(self.view)
			if #available(iOS 11.0, *) {
				make?.bottom.equalTo()(self.view.mas_safeAreaLayoutGuideBottom)
			} else {
				make?.bottom.equalTo()(self.view.mas_bottom)
			}
			make?.centerX.equalTo()(self.view)
			make?.height.equalTo()(30)
		}
		goRegistButton.setTitle("已有账号，去登录", for: UIControlState.normal)
		goRegistButton.titleLabel?.textColor = UIColor.init(hexString: "#A6A6A6")
		goRegistButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
		goRegistButton.addTarget(self, action: #selector(touchInSide(button:)), for: UIControlEvents.touchDown)
		goRegistButton.addTarget(self, action: #selector(goLoginButton(button:)), for: UIControlEvents.touchUpInside)
		let line: UIView = UIView.init()
		self.view.addSubview(line)
		line.mas_makeConstraints { (make) in
			make?.width.equalTo()(goRegistButton)
			make?.height.equalTo()(1)
			make?.bottom.equalTo()(goRegistButton.mas_top)
			make?.centerX.equalTo()(goRegistButton)
		}
		line.backgroundColor = UIColor.init(hexString: "#A6A6A6")
		if self.isWeChatInstall {
			addWeChatbutton()
		}
	}
	// 添加微信登按钮
	func addWeChatbutton() -> Void {
		let weChatButton = UIButton.init(type: UIButtonType.custom)
		self.view.addSubview(weChatButton)
		weChatButton.mas_makeConstraints { (make) in
			make?.width.equalTo()(self.view)?.multipliedBy()(0.9)
			make?.height.equalTo()(30)
			if #available(iOS 11.0, *) {
				make?.bottom.equalTo()(self.view.mas_safeAreaLayoutGuideBottom)?.offset()(-46)
			} else {
				make?.bottom.equalTo()(self.view.mas_bottom)?.offset()(-46)
			}
			make?.centerX.equalTo()(self.view)
		}
		weChatButton.backgroundColor = UIColor.init(hexString: "#1b1C1F")
		weChatButton.layer.cornerRadius = 6.0
		weChatButton.addTarget(self, action:#selector(touchInSide(button:)) , for: UIControlEvents.touchDown)
		weChatButton.addTarget(self, action: #selector(weChatLogin(button:)), for: UIControlEvents.touchUpInside)
		// weChatlogo
		let weChatImageView = UIImageView.init()
		if let weChatLogo = UIImage.init(named: "weChat.png") {
			weChatImageView.image = weChatLogo
		}
		weChatImageView.mas_makeConstraints { (make) in
			make?.width.and().height().equalTo()(20)
		}
		weChatImageView.contentMode = UIViewContentMode.scaleAspectFit
		let titleLabel = UILabel.init()
		titleLabel.text = "微信登录"
		titleLabel.textColor = UIColor.white
		titleLabel.font = UIFont.systemFont(ofSize: 14.0)
		let stackView = UIStackView.init()
		weChatButton.addSubview(stackView)
		stackView.mas_makeConstraints { (make) in
			make?.centerX.and().centerY().equalTo()(weChatButton)
		}
		stackView.spacing = 5
		stackView.axis = UILayoutConstraintAxis.horizontal
		stackView.distribution = UIStackViewDistribution.fill
		stackView.addArrangedSubview(weChatImageView)
		stackView.addArrangedSubview(titleLabel)
	}
	//MARK: 按钮的方法
	@objc
	func touchInSide(button: UIButton) -> Void {
		button.alpha = 0.7
	}

	@objc
	func goLoginButton(button:UIButton) -> Void {
		button.alpha = 1.0
		// 从xib初始化vc
		self.navigationController?.popViewController(animated: true)
	}

	@objc
	func weChatLogin(button: UIButton) -> Void {
		button.alpha = 1.0
		self.manager.weChatLoginRequest()
	}


	@IBAction func cancelAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}

	@IBAction func regiestAction(_ sender: Any) {
		self.manager.register()
	}

	@IBAction func nickNameChange(_ sender: UITextField) {
		self.manager.nickName = sender.text
	}

	@IBAction func pwdOnceChange(_ sender: UITextField) {
		self.manager.pwdOnce = sender.text
	}

	@IBAction func pwdTwiceChange(_ sender: UITextField) {
		self.manager.pwdTwice = sender.text
	}
	// MARK: -ToastDelegate
	func showTitleToast(_ content: String) {
		self.showHint(in: self.view, hint: content)
	}

	func showLoading(_ content: String) {
		self.showHUD(in: self.view, hint: content, yOffset: 1.0)
	}

	func hideLoading() {
		self.hideHud(view: self.view)
	}

	@objc
	func registerSuccess() -> Void {
		self.navigationController?.popViewController(animated: true)
	}
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
