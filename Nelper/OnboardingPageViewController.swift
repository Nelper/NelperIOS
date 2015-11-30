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
		(OnboardingThirdViewController())
	]
	
	var currentPagingViewController: UIViewController!
	
	var pageControl: UIPageControl!

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
	}
	
	override func viewDidAppear(animated: Bool) {
		Helper.statusBarHidden(true, animation: .Slide)
	}
	
	override func viewWillDisappear(animated: Bool) {
		Helper.statusBarHidden(false, animation: .Slide)
	}
	
	// MARK: UI
	
	func createPageControl() {
		let pageControl = UIPageControl()
		self.pageControl = pageControl
		pageControl.numberOfPages = self.pagingViewControllers.count
		pageControl.currentPage = 0
		pageControl.tintColor = Color.redPrimary
		pageControl.pageIndicatorTintColor = Color.redPrimarySelected.colorWithAlphaComponent(0.5)
		pageControl.currentPageIndicatorTintColor = Color.redPrimary
		self.view.addSubview(pageControl)
		pageControl.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.view.snp_bottom)
			make.centerX.equalTo(self.view.snp_centerX)
		}
		
		self.view.bringSubviewToFront(pageControl)
	}
	
	//MARK: pageViewController Delegate
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		let index = viewController.view.tag
		
		self.pageControl.currentPage = index
		self.currentPagingViewController = viewController
		
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
			return nil
		}
		
		return self.pagingViewControllers[index + 1]
	}
}