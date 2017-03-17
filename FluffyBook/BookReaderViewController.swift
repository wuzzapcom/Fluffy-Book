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


    @IBOutlet weak var bookTextView: UITextView!
    @IBOutlet weak var progressSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookTextView?.text = bookModel?.getTextFromCurrentPage()
        
        progressSlider?.value = (bookModel?.getCurrentProgressPercent())!
        
        hideTabBarAndUpdateViews()
        

        
    }
    
    func hideTabBarAndUpdateViews(){
        
        setTabBarVisible(visible: false, animated: false)
        
        moveSliderToBottom()
        
        changeBookTextViewSize()
        
    }
    
    
    func setTabBarVisible(visible : Bool, animated : Bool) {
        
        if (tabBarIsVisible() == visible) {return}
        
        let frame = self.tabBarController?.tabBar.frame
        
        let height = countOffsetY()
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
        
        let height = countOffsetY()
        
        progressSlider.frame = progressSlider.frame.offsetBy(dx: 0, dy: height)
        
    }
    
    func countOffsetY() -> CGFloat {
        
        return (self.tabBarController?.tabBar.frame.size.height)!
        
    }
    
    func changeBookTextViewSize(){
        
        bookTextView.frame.size.height += countOffsetY()
        
    }
    

}
