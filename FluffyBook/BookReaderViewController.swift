//
//  BookReaderViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class BookReaderViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var bookModel : BookModel?
    
    var isStatusBarHidden: Bool = false
    
    var isDetectedGesture: Bool = false
    
    override var prefersStatusBarHidden: Bool{
        return isStatusBarHidden
    }
    
    
//    @IBOutlet weak var bookTextView: UITextView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var bookWebView: UIWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        fillViewByModel()
        
        customizeProgressSlider()
        
        addButtonsToNavigationController()
        
        customizeNavigationBar()
        
        bookWebView.paginationBreakingMode = UIWebPaginationBreakingMode.page
        bookWebView.paginationMode = UIWebPaginationMode.leftToRight

    }
    
    func fillViewByModel() {
        bookWebView.loadHTMLString(bookModel!.getTextFromCurrentPage(), baseURL: nil)
        
        progressSlider?.value = bookModel!.getCurrentProgressPercent()
        
        self.title = bookModel!.getBookTitle()
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func customizeProgressSlider() {
        
        progressSlider.setThumbImage(#imageLiteral(resourceName: "Bookmark"), for: UIControlState.normal)
        
    }
    
    func addButtonsToNavigationController(){
    
        let markButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: nil)
        
        let contentsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "List"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItems = [markButton, contentsButton]
    
    }
    
    func customizeNavigationBar(){
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    
    func setNavigationBarToDefaults(){
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        if touches.first!.force / touches.first!.maximumPossibleForce > 0.5 {
            
            print("FORCE TOUCH")
            
            isDetectedGesture = true
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if event?.type == UIEventType.touches{
            
            if touches.first?.tapCount == 1 && !isDetectedGesture {
                
                
                if !self.navigationController!.isNavigationBarHidden {
                    
                    hideNavigationBar()
                    
                } else {
                    
                    showNavigationBar()
                    
                }
                
            }
        }
        
        isDetectedGesture = false
    }
    
    func showNavigationBar() {
        
        isStatusBarHidden = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let heightOffset = self.navigationController?.navigationBar.frame.height
        
        changeBookTextViewSize(offset: -heightOffset!)
        
        bookWebView.frame = bookWebView.frame.offsetBy(dx: 0, dy: heightOffset!)
        
    }
    
    
    func hideNavigationBar() {
        
        isStatusBarHidden = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let heightOffset = self.navigationController?.navigationBar.frame.height

        changeBookTextViewSize(offset: heightOffset!)

        bookWebView.frame = bookWebView.frame.offsetBy(dx: 0, dy: -heightOffset!)
        
    }

    
    func changeBookTextViewSize(offset : CGFloat){
        
        bookWebView.frame.size.height += offset
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        setNavigationBarToDefaults()
        
    }

    

}
