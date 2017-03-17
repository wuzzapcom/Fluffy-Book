//
//  BookReaderViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class BookReaderViewController: UIViewController {
    
    var bookModel : BookModel?
    
    var isStatusBarHidden: Bool = false
    
    override var prefersStatusBarHidden: Bool{
        return isStatusBarHidden
    }


    @IBOutlet weak var bookTextView: UITextView!
    @IBOutlet weak var progressSlider: UISlider!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        bookTextView?.text = bookModel?.getTextFromCurrentPage()
        
        progressSlider?.value = (bookModel?.getCurrentProgressPercent())!
        
        hideTabBarAndUpdateViews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapHideInterface(_:)))
        
        bookTextView.addGestureRecognizer(tap)
        
    }
    
    func handleTapHideInterface(_ sender : UITapGestureRecognizer){
        
        if !self.navigationController!.isNavigationBarHidden {
        
            hideNavigationBar()
            
        } else {
            
            showNavigationBar()
            
        }
        
    }
    
    func showNavigationBar() {
        
        isStatusBarHidden = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let heightOffset = self.navigationController?.navigationBar.frame.height
        
        changeBookTextViewSize(offset: -heightOffset!)
        
        bookTextView.frame = bookTextView.frame.offsetBy(dx: 0, dy: heightOffset!)
        
    }
    
    
    func hideNavigationBar() {
        
        isStatusBarHidden = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let heightOffset = self.navigationController?.navigationBar.frame.height

        changeBookTextViewSize(offset: heightOffset!)

        bookTextView.frame = bookTextView.frame.offsetBy(dx: 0, dy: -heightOffset!)
        
    }
    
    
    
    func hideTabBarAndUpdateViews(){
        
        setTabBarVisible(visible: false, animated: true)
        
        moveSliderToBottom()
        
        changeBookTextViewSize(offset: countOffsetYForTabBar())
        
    }
    
    
    func setTabBarVisible(visible : Bool, animated : Bool) {
        
        if (tabBarIsVisible() == visible) {return}
        
        let frame = self.tabBarController?.tabBar.frame
        
        let height = countOffsetYForTabBar()
        let offsetY = (visible ? -height : height)
        
        let duration : TimeInterval = (animated ? 0.3 : 0.0)
        
        if frame != nil {
            
            UIView.animate(withDuration: duration) {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY)
                return
            }
            
        }
        
    }
    
    func tabBarIsVisible() -> Bool {
        
        return (self.tabBarController?.tabBar.frame.origin.y)! < self.view.frame.maxY
        
    }
    
    func moveSliderToBottom(){
        
        let height = countOffsetYForTabBar()
        
        progressSlider.frame = progressSlider.frame.offsetBy(dx: 0, dy: height)
        
    }
    
    func countOffsetYForTabBar() -> CGFloat {
        
        return (self.tabBarController?.tabBar.frame.size.height)!
        
    }
    
    func changeBookTextViewSize(offset : CGFloat){
        
        bookTextView.frame.size.height += offset
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        setTabBarVisible(visible: true, animated: true)
        
    }
    

}
