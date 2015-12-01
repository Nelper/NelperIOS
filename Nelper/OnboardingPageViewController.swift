//
//  OnboardingPageViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-29.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
	
	var pagingViewControllers = [
		(OnboardingFirstViewController()),
		(OnboardingSecondViewController()),
		(OnboardingThirdViewController()),
		(OnboardingFourthViewController()),
		(OnboardingFifthViewController())
	]
	
	var currentPagingViewController: UIViewController!
	
	var pageControl: UIPageControl!
	
	var goButton: PrimaryActionButton!
	var firstLoad = true
	
	let pageControlHeight = 50

	//MARK: Init
	
	override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
		super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: options)
	}
	
	required init?(coder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.dataSource = self
		self.delegate = self
		self.view.backgroundColor = Color.whiteBackground
		
		var firstIndex = 0
		let startingVC = self.pagingViewControllers[firstIndex]
		self.setViewControllers([startingVC], direction: .Forward, animated: false, completion: nil)
		
		for pagingViewController in self.pagingViewControllers {
			pagingViewController.view.tag = firstIndex
			firstIndex += 1
		}
		
		self.createPageControl()
		self.createGoButton()
	}
	
	override func viewDidAppear(animated: Bool) {
		Helper.statusBarHidden(true, animation: .Slide)
	}
	
	override func viewWillDisappear(animated: Bool) {
		Helper.statusBarHidden(false, animation: .Slide)
	}
	
	// MARK: UI
	
	func createPageControl() {
		let pageControlBackground = UIView()
		self.view.addSubview(pageControlBackground)
		pageControlBackground.backgroundColor = Color.redPrimary
		pageControlBackground.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.view.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.height.equalTo(self.pageControlHeight)
		}
		
		let pageControl = UIPageControl()
		self.pageControl = pageControl
		pageControl.numberOfPages = self.pagingViewControllers.count
		pageControl.currentPage = 0
		//pageControl.tintColor = Color.redPrimary
		pageControl.pageIndicatorTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
		pageControl.currentPageIndicatorTintColor = Color.whitePrimary
		self.view.addSubview(pageControl)
		pageControl.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(self.view.snp_centerX)
			make.centerY.equalTo(pageControlBackground.snp_centerY)
		}
		
		self.view.bringSubviewToFront(pageControl)
	}
	
	func createGoButton() {
		let goButton =  PrimaryActionButton()
		self.goButton = goButton
		self.view.addSubview(goButton)
		goButton.setTitle("Débuter!", forState: .Normal)
		goButton.addTarget(self, action: "goButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		goButton.snp_remakeConstraints { (make) -> Void in
			make.bottom.equalTo(self.view.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.height.equalTo(self.pageControlHeight)
		}
		goButton.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 0)
		goButton.alpha = 0
		
		self.view.bringSubviewToFront(goButton)
	}
	
	func updateGoButtonLayout(hidden: Bool) {
		if self.firstLoad {
			self.firstLoad = false
			return
		}
		
		if !(hidden) {
			UIView.animateWithDuration(0.4, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.goButton.transform = CGAffineTransformMakeTranslation(0, 0)
				self.goButton.alpha = 1
				}, completion: nil)
		} else {
			UIView.animateWithDuration(0.4, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.goButton.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 0)
				self.goButton.alpha = 0
				}, completion: nil)
		}
	}
	
	//MARK: pageViewController Delegate
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		let index = viewController.view.tag
		
		self.pageControl.currentPage = index
		self.currentPagingViewController = viewController
		
		self.updateGoButtonLayout(true)
		
		if index == 0 {
			return nil
		}
		
		return self.pagingViewControllers[index - 1]
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		let index = viewController.view.tag
		
		self.pageControl.currentPage = index
		self.currentPagingViewController = viewController
		
		if index == self.pagingViewControllers.count - 1 {
			self.updateGoButtonLayout(false)
			return nil
		}
		
		return self.pagingViewControllers[index + 1]
	}
	
	//MARK: Actions
	
	func goButtonTapped(sender: PrimaryActionButton) {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.showLogin(true)
	}
}