//
//  ViewController.swift
//  UIPageViewControllerDemo
//
//  Created by Niks on 21/12/15.
//  Copyright © 2015 TheAppGuruz. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // The custom UIPageControl
    @IBOutlet weak var pageControl: UIPageControl!
    
    // The UIPageViewController
    var pageContainer: UIPageViewController!
    
    @IBOutlet weak var btn_skip: UIButton!
    // The pages it contains
    var pages = [UIViewController]()
    
    // Track the current index
    var currentIndex: Int?
    private var pendingIndex: Int?
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Setup the pages
        let storyboard = StoryboardScene.Main.instantiate_WalkthroughViewController()
        let page1: UIViewController! = StoryboardScene.Main.instantiateSplash1_VCController()
        let page2: UIViewController! = StoryboardScene.Main.instantiateSplash2_VCController()
        let page3: UIViewController! = StoryboardScene.Main.instantiateSplash3_VCController()
        pages.append(page1)
//        pages.append(page2)
//        pages.append(page3)
        
        // Create the page container
        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.delegate = self
        pageContainer.dataSource = self
        pageContainer.setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        // Add it to the view
        view.addSubview(pageContainer.view)
        
        // Configure our custom pageControl
        view.bringSubview(toFront: pageControl)
        view.bringSubview(toFront: btn_skip)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
    }
    
    @IBAction func click_skip(_ sender: UIButton) {
        
        let vc = StoryboardScene.Main.instantiateHome_ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UIPageViewController delegates
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex! - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)
        if currentIndex == pages.count-1 {
            return nil
        }
        let nextIndex = abs((currentIndex! + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.index(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
}
