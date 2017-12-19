//
//  LoginViewController.swift
//  GTravel_test
//
//  Created by aby on 2017/12/14.
//  Copyright © 2017年 dragontrail. All rights reserved.
//

import UIKit
import MBProgressHUD


class LoginViewController: UIViewController, UITextFieldDelegate, ToastDelegate {

	//MARK: 属性
	@objc var needLoadingView: Bool = true
	// 存储属性
	private var isAnimationPlay: Bool = false
	private var isLoadingViewHiden: Bool = false
	let loginFormView: UIView = UIView.init()
	private var _userNameTextfield: UITextField = UITextField.init()
	private var _passWordTextField: UITextField = UITextField.init()
	private var _loginBtn: UIButton = UIButton.init(type: UIButtonType.custom)
	private var dismissLoading = false
	let isWeChatInstall: Bool = {
		// FIXME: 添加判断微信是否安装的方法
		let isWxInstall = WXApi.isWXAppInstalled()
		return isWxInstall
	}()
	// 动画页懒加载属性
	lazy var adImageView: UIImageView = {
		let adImage = UIImage.init(named: "ad02.png")
		let AnimationImageView: UIImageView = UIImageView.init(image: adImage!)
		return AnimationImageView
	}()
	// 整个广告页面
	lazy var loadingView: UIView = {
		let view = UIView.init(frame: self.view.bounds)
		view.backgroundColor = UIColor.white
		return view
	}()
	// 背景图片懒加载
	lazy var bgLoginImageView: UIImageView = {
		let bgImage = UIImage.init(named: "bg_login")
		var imageView: UIImageView = UIImageView.init()
		if let image = bgImage {
			imageView.image = image
			imageView.contentMode = UIViewContentMode.scaleAspectFill
		}
		imageView.frame = self.view.bounds
		imageView.isUserInteractionEnabled = true
		return imageView
	}()
	// 登录管理者加载
	lazy var manager: LAndRManager = {
		let manager = LAndRManager.init()
		manager.delegate = self
		return manager
	}()
	//MARK: 视图生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		self.view.backgroundColor = UIColor.black
		//首先在底层创建登录页
		self.createLoginView()
		// 然后在上层创建广告页
		if (self.needLoadingView) {
			self.createLoadingView()
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(true, animated: true)
	}
	// 防止内存泄露
	deinit {
		self.manager.delegate = nil
	}
	//MARK: 设置视图布局的方法
	func createLoadingView() -> Void {
		self.view.addSubview(self.loadingView)
		self.setAnimationView()
		self.setBottomView()
		self.setButton()
	}

	func removeLoadingView() -> Void {
		self.loadingView.removeFromSuperview()
	}

	// 创建登录页面
	func createLoginView() -> Void {
		self.view.addSubview(self.bgLoginImageView)
		// 创建表单提交父视图
		self.loginFormView.backgroundColor = UIColor.clear
		self.loginFormView.isUserInteractionEnabled = true
		self.bgLoginImageView.addSubview(self.loginFormView)
		self.loginFormView.mas_makeConstraints { (make) in
			if #available(iOS 11.0, *) {
				make?.top.equalTo()(self.bgLoginImageView.mas_safeAreaLayoutGuideTop)?.offset()(40)
			} else {
				make?.top.equalTo()(self.bgLoginImageView.mas_top)?.offset()(40)
			}
			make?.left.and().right().equalTo()(self.bgLoginImageView)
			make?.height.mas_equalTo()(self.bgLoginImageView.frame.size.height / 2)
		}
		// 创建logingImageView
		let sloganImageView = self.createsLogoView()
		// 接下来添加输入框视图, 高度为80，每个输入框为40
		let formView = self.createInputForm(sloganImageView)
		// 再接下来创建登录按钮
		self.createLoginBtn(formView)
		// 然后创建微信登录按钮
		self.addBottomButtons()
	}
	// 创建slogo视图
	func createsLogoView() -> UIImageView {
		let sloganImage = UIImage.init(named: "slogan")
		var WHRatio: CGFloat = 0.5
		if let image = sloganImage {
			WHRatio = (image.size.height / image.size.width) as CGFloat
		}
		let sloganImageView = UIImageView.init(image: sloganImage!)
		self.loginFormView.addSubview(sloganImageView)
		sloganImageView.mas_makeConstraints { (make) in
			make?.top.equalTo()(self.loginFormView)
			make?.width.equalTo()(self.loginFormView)?.multipliedBy()(0.8)
			make?.height.equalTo()(sloganImageView.mas_width)?.multipliedBy()(WHRatio) // 设置自身的纵横比
			make?.centerX.equalTo()(self.loginFormView)
		}
		sloganImageView.contentMode = UIViewContentMode.scaleAspectFit
		return sloganImageView
	}

	/// 创建提交表单
	///
	/// - Parameter sloganImageView: 表单上面的logo视图，为了布置约束
	func createInputForm(_ sloganImageView: UIImageView) -> UIView {
		// 表单父视图
		let textFaildView: UIView = UIView.init()
		textFaildView.isUserInteractionEnabled = true
		self.loginFormView.addSubview(textFaildView)
		textFaildView.mas_makeConstraints { (make) in
			make?.top.equalTo()(sloganImageView.mas_bottom)?.offset()(30)
			make?.width.equalTo()(self.loginFormView)?.multipliedBy()(0.9)
			make?.height.equalTo()(81)
			make?.centerX.equalTo()(self.loginFormView)
		}
		textFaildView.backgroundColor = UIColor.white
		textFaildView.layer.cornerRadius = 5.0
		// 分割线
		let line = UIView.init()
		textFaildView.addSubview(line)
		line.mas_makeConstraints { (make) in
			make?.width.equalTo()(textFaildView)
			make?.height.mas_equalTo()(1)
			make?.left.equalTo()(textFaildView.mas_left)
			make?.centerY.equalTo()(textFaildView)
		}
		line.backgroundColor = UIColor.init(hexString: "#707179")
		// 用户名输入头像
		let userNameImage = UIImage.init(named: "userName.png")
		let userNameImageView = UIImageView.init(image: userNameImage!)
		textFaildView.addSubview(userNameImageView)
		userNameImageView.mas_makeConstraints { (make) in
			make?.width.and().height().mas_equalTo()(20)
			make?.top.and().left().equalTo()(textFaildView)?.offset()(10)
		}
		userNameImageView.contentMode = UIViewContentMode.scaleToFill
		// 用户名密码图
		let passWordImage = UIImage.init(named: "password.png")
		let passWordImageView = UIImageView.init(image: passWordImage!)
		textFaildView.addSubview(passWordImageView)
		passWordImageView.mas_makeConstraints { (make) in
			make?.width.and().height().mas_equalTo()(20)
			make?.bottom.equalTo()(textFaildView)?.offset()(-10)
			make?.left.equalTo()(textFaildView)?.offset()(10)
		}
		passWordImageView.contentMode = UIViewContentMode.scaleToFill
		// 用户名输入框
		textFaildView.addSubview(_userNameTextfield)
		_userNameTextfield.mas_makeConstraints { (make) in
			make?.left.equalTo()(userNameImageView.mas_right)?.offset()(10)
			make?.right.equalTo()(textFaildView)?.offset()(10)
			make?.height.equalTo()(40)
			make?.centerY.equalTo()(userNameImageView)
		}
		_userNameTextfield.placeholder = "昵称"
		_userNameTextfield.addTarget(self, action: #selector(userNameChanged(textField:)), for: UIControlEvents.editingChanged)
		// 密码输入框
		textFaildView.addSubview(_passWordTextField)
		_passWordTextField.mas_makeConstraints { (make) in
			make?.height.equalTo()(40)
			make?.left.equalTo()(passWordImageView.mas_right)?.offset()(10)
			make?.right.equalTo()(textFaildView)?.offset()(10)
			make?.centerY.equalTo()(passWordImageView)
		}
		_passWordTextField.placeholder = "密码"
		_passWordTextField.isSecureTextEntry = true
		_passWordTextField.addTarget(self, action: #selector(passwordChanged(textField:)), for: .editingChanged)
		return textFaildView
	}
	// 创建登录按钮
	func createLoginBtn(_ formView: UIView) -> Void {
		self.loginFormView.addSubview(_loginBtn)
		_loginBtn.mas_makeConstraints { (make) in
			make?.width.equalTo()(formView)
			make?.top.equalTo()(formView.mas_bottom)?.offset()(30)
			make?.centerX.equalTo()(formView)
			make?.height.equalTo()(40)
		}
		_loginBtn.layer.cornerRadius = 6.0
		_loginBtn.backgroundColor = UIColor.init(hexString: "#C9081B")
		_loginBtn.setTitle("登录", for: UIControlState.normal)
		_loginBtn.titleLabel?.textColor = UIColor.white
		_loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
		_loginBtn.addTarget(self, action: #selector(touchInSide(button:)), for: UIControlEvents.touchDown)
		_loginBtn.addTarget(self, action: #selector(loginAction(button:)), for: UIControlEvents.touchUpInside)
	}
	// 底部的按钮组
	func addBottomButtons() -> Void {
		let goRegistButton = UIButton.init(type: UIButtonType.custom)
		self.bgLoginImageView.addSubview(goRegistButton)
		goRegistButton.mas_makeConstraints { (make) in
			make?.width.equalTo()(self.bgLoginImageView)
			if #available(iOS 11.0, *) {
				make?.bottom.equalTo()(self.bgLoginImageView.mas_safeAreaLayoutGuideBottom)
			} else {
				make?.bottom.equalTo()(self.bgLoginImageView.mas_bottom)
			}

			make?.centerX.equalTo()(self.bgLoginImageView)
			make?.height.equalTo()(30)
		}
		goRegistButton.setTitle("还没有账号，先去注册", for: UIControlState.normal)
		goRegistButton.titleLabel?.textColor = UIColor.init(hexString: "#A6A6A6")
		goRegistButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
		goRegistButton.addTarget(self, action: #selector(touchInSide(button:)), for: UIControlEvents.touchDown)
		goRegistButton.addTarget(self, action: #selector(goRegistButton(button:)), for: UIControlEvents.touchUpInside)
		let line: UIView = UIView.init()
		self.bgLoginImageView.addSubview(line)
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
		self.bgLoginImageView.addSubview(weChatButton)
		weChatButton.mas_makeConstraints { (make) in
			make?.width.equalTo()(self.bgLoginImageView)?.multipliedBy()(0.9)
			make?.height.equalTo()(30)
			if #available(iOS 11.0, *) {
				make?.bottom.equalTo()(self.bgLoginImageView.mas_safeAreaLayoutGuideBottom)?.offset()(-46)
			} else {
				make?.bottom.equalTo()(self.bgLoginImageView.mas_bottom)?.offset()(-46)
			}

			make?.centerX.equalTo()(self.bgLoginImageView)
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
		weChatImageView.isUserInteractionEnabled = true
		weChatImageView.mas_makeConstraints { (make) in
			make?.width.and().height().equalTo()(20)
		}
		weChatImageView.contentMode = UIViewContentMode.scaleAspectFit
		let titleLabel = UILabel.init()
		titleLabel.text = "微信登录"
		titleLabel.textColor = UIColor.white
		titleLabel.font = UIFont.systemFont(ofSize: 14.0)
		titleLabel.isUserInteractionEnabled = true
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
		stackView.isUserInteractionEnabled = true
	}
	// MARK: 广告视图
	// 设置跳过按钮
	func setButton() -> Void {
		let button: UIButton = UIButton.init(type: UIButtonType.custom)
		self.loadingView.addSubview(button)
		button.mas_makeConstraints { (make) in
			make?.width.equalTo()(50)
			make?.height.equalTo()(30)
			make?.bottom.equalTo()(self.loadingView)?.offset()(-130)
			make?.right.equalTo()(self.loadingView)?.offset()(-30)
		}
		button.setTitle("跳过", for: UIControlState.normal)
		button.setTitleColor(UIColor.black, for: UIControlState.normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
		button.layer.cornerRadius = 5.0
		button.layer.masksToBounds = true
		button.backgroundColor = UIColor.white
		button.addTarget(self, action: #selector(dismissLoadingView(button:)), for: UIControlEvents.touchUpInside)
		button.addTarget(self, action: #selector(touchInSide(button:)), for: UIControlEvents.touchDown)
	}
	// 设置动画视图
	func setAnimationView() -> Void {
		self.loadingView .addSubview(self.adImageView)
		self.adImageView.mas_makeConstraints { (make) in
			make?.top.and().left().right().equalTo()(self.loadingView)
			make?.bottom.equalTo()(self.loadingView)?.offset()(-100)
		}
		self.adImageView.contentMode = UIViewContentMode.scaleAspectFill
		self.adImageView.transform = self.adImageView.transform.scaledBy(x: 1.2, y: 1.2)
	}
	
	/**
		播放动画的方法, 想要在oc里访问，必须加入objc
	*/
	@objc
	func startAnimation() -> Void {
		if self.isAnimationPlay {
			return
		}
		UIView.animate(withDuration: 2.0, animations: {
			self.adImageView.transform = self.adImageView.transform.scaledBy(x:1 / 1.2, y:1 / 1.2)
		}) { (success) in
			self.isAnimationPlay = true
			let time: DispatchTime = DispatchTime.now()
			DispatchQueue.main.asyncAfter(deadline: time + 1.0, execute: {
				if !self.dismissLoading {
					self.dismissLoadingView(button: UIButton.init())
				}
			})
		}
	}
	// 设置底部视图
	func setBottomView() -> Void {
		// 添加下方视图
		let bottomView: UIView = UIView.init()
		self.loadingView.addSubview(bottomView)
		bottomView.mas_makeConstraints { (make) in
			make?.left.and().bottom().equalTo()(self.loadingView)
			make?.height.mas_equalTo()(100)
			make?.width.equalTo()(self.loadingView)
		}
		bottomView.backgroundColor = UIColor.white

		let logo_Ger: UIImage = UIImage.init(named: "bottom_logoGer.png")!
		let logo_Luf: UIImage = UIImage.init(named: "bottom_logoLuf.png")!
		let totalWidth = logo_Ger.size.width + logo_Luf.size.width
		// 添加航空logo
		let imageView_luf = UIImageView.init(image: logo_Luf)
		bottomView.addSubview(imageView_luf)
		let lufWidth = (self.loadingView.frame.size.width-60) * logo_Luf.size.width / totalWidth
		imageView_luf.mas_makeConstraints { (make) in
			make?.centerY.equalTo()(bottomView)
			make?.height.mas_equalTo()(100)
			make?.width.mas_equalTo()(lufWidth)
			make?.left.equalTo()(bottomView)?.offset()(15)
		}
		imageView_luf.contentMode = UIViewContentMode.scaleAspectFit
		// 添加德旅局logo
		let imageView_Ger = UIImageView.init(image: logo_Ger)
		bottomView.addSubview(imageView_Ger)
		let gerWidthScal = logo_Ger.size.width / totalWidth
		let gerWidth = (self.loadingView.frame.size.width-60) * gerWidthScal
		imageView_Ger.mas_makeConstraints { (make) in
			make?.centerY.equalTo()(bottomView)
			make?.left.equalTo()(imageView_luf.mas_right)?.offset()(30)
			make?.height.mas_equalTo()(100)
			make?.width.mas_equalTo()(gerWidth)
		}
		imageView_Ger.contentMode = UIViewContentMode.scaleAspectFit
		// 添加中心线
		let spaceView: UIView = UIView.init()
		bottomView.addSubview(spaceView)
		spaceView.mas_makeConstraints { (make) in
			make?.width.mas_equalTo()(1)
			make?.height.mas_equalTo()(gerWidth * logo_Ger.size.height / logo_Ger.size.width)
			make?.centerY.equalTo()(bottomView)
			make?.left.equalTo()(imageView_luf.mas_right)?.offset()(15)
		}
		spaceView.backgroundColor = UIColor.init(hexString: "#F0F0F0")
		bottomView.bringSubview(toFront: spaceView)
	}

	//MARK:点击释放键盘
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.bgLoginImageView.endEditing(false)
	}

	//MARK: 按钮的方法
	@objc
	func touchInSide(button: UIButton) -> Void {
		button.alpha = 0.7
	}

	@objc
	func dismissLoadingView(button: UIButton) -> Void {
		button.alpha = 1.0
		self.dismissLoading = true
		// 设置广告页动画
		UIView.animate(withDuration: 0.8, animations: {
			self.loadingView.alpha = 0.0
		}) { (success) in
			// 隐藏整个广告页
			self.removeLoadingView()
		}
	}

	@objc
	func goRegistButton(button:UIButton) -> Void {
		button.alpha = 1.0
		// 从xib初始化vc
		let regiestViewController = RegistViewController.init(nibName: "RegistViewController", bundle: nil)
		self.navigationController?.pushViewController(regiestViewController, animated: true)
	}

	@objc
	func weChatLogin(button: UIButton) -> Void {
		button.alpha = 1.0
		self.manager.weChatLoginRequest()
	}

	@objc
	func loginAction(button: UIButton) -> Void {
		button.alpha = 1.0
		self.adImageView.endEditing(false) // 关闭键盘
		// 登录的动作
		self.manager.login()
	}

	@objc
	func userNameChanged(textField:UITextField) -> Void {
		self.manager.userName = textField.text
	}

	@objc
	func passwordChanged(textField:UITextField) -> Void {
		self.manager.passWord = textField.text
	}

	// MARK:ToastDelegete
	func showLoading(_ content: String) {
		self.showHUD(in: self.view, hint: content, yOffset: 1.0)
	}

	func hideLoading() {
		self.hideHud(view: self.view)
	}

	func showTitleToast(_ content: String) {
		self.showHint(in: self.view, hint: content)
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
