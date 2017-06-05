//
//  PageViewController.swift
//  TestCoreText
//
//  Created by Владимир Лапатин on 02.06.17.
//  Copyright © 2017 fluffybook. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var controllers : [ViewController]?
    var currentPage = 0
    var presentingView = 0
    var numberOfPages = 0
    var flag = false
    var bookModel: BookModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        addButtonsToNavigationController()
        
        let text = bookModel!.openCurrentChapter()
        
        let parser = ParsingTextModel(withText: text, inRect: CGRect(x: 0, y: 0, width: 375, height: 639))
        let pages = parser.parseText()
        
        numberOfPages = pages.count
        
        let view1 = storyboard?.instantiateViewController(withIdentifier: Constants.TEXT_PRESENTER_VIEW_CONTROLLER) as! ViewController
        let view2 = storyboard?.instantiateViewController(withIdentifier: Constants.TEXT_PRESENTER_VIEW_CONTROLLER) as! ViewController
        
        view1.parsedWords = pages
        view2.parsedWords = pages
        view1.bookModel = bookModel
        view2.bookModel = bookModel
        
        view1.draw(withPage: 0)
        view2.draw(withPage: 1)
        
        controllers = [view1, view2]

        dataSource = self
        
        if let firstViewController = controllers?.first{
            
            setViewControllers([firstViewController], direction: .forward , animated: true, completion: nil)
            
        }

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        currentPage = abs((currentPage + 1) % numberOfPages)
        presentingView = (presentingView + 1) % 2
        controllers?[presentingView].draw(withPage: currentPage)
        
        
//        if flag{
//            currentPage = abs((currentPage - 1) % numberOfPages)
//        }
//        
//        flag = !flag
        
        NSLog("Current page is\(currentPage)")
        
        return controllers?[presentingView]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        currentPage = abs((currentPage - 1) % numberOfPages)
        presentingView = (presentingView + 1) % 2
        controllers?[presentingView].draw(withPage: currentPage)
        
//        if flag{
//            currentPage = abs((currentPage + 1) % numberOfPages)
//        }
//        
//        flag = !flag
        
        NSLog("Current page is\(currentPage)")
        
        return controllers?[presentingView]
    }
    
    func addButtonsToNavigationController(){
        
        let markButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: nil)
        
        let contentsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "List"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItems = [markButton, contentsButton]
        
    }
    

}

