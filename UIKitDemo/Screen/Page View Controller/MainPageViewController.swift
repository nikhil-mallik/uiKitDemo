//
//  MainPageViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 30/07/24.
//

import UIKit

class MainPageViewController: UIPageViewController, UIPageViewControllerDataSource {
  
    lazy var vcArray: [UIViewController] = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let one = storyBoard.instantiateViewController(identifier: "Page 1")
        let two = storyBoard.instantiateViewController(identifier: "Page 2")
        let three = storyBoard.instantiateViewController(identifier: "Page 3")
        let four = storyBoard.instantiateViewController(identifier: "Page 4")
        
        return [one, two, three, four]
    }()
    
    var currentPage = 0
    var pageIndicAppearence = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])

    override func viewDidLoad() {
        super.viewDidLoad()
        pageIndicAppearence.pageIndicatorTintColor = .cyan
        pageIndicAppearence.currentPageIndicatorTintColor = .black
        self.dataSource = self
        if let vc = vcArray.first {
            self.setViewControllers([vc], direction: .forward, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        for subviews in self.view.subviews {
            if subviews is UIScrollView {
                subviews.frame = self.view.bounds
            }
        }
        super.viewDidLayoutSubviews()
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcArray.lastIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0 else { return nil }
        guard previousIndex < vcArray.count else { return nil }
        currentPage = index - 1
        return vcArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcArray.lastIndex(of: viewController) else { return nil }
        let previousIndex = index + 1
        guard previousIndex >= 0 else { return nil }
        guard previousIndex < vcArray.count else { return nil }
        currentPage = index + 1
        return vcArray[previousIndex]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPage
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return vcArray.count
    }

}

// MARK: - Extension
extension MainPageViewController {
    // Create an instance of ViewController from storyboard
    static func sharedIntance() -> MainPageViewController {
        return MainPageViewController.instantiateFromStoryboard("MainPageViewController")
    }
}
