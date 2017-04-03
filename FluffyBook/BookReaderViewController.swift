//
//  BookReaderViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit
import WebKit

class BookReaderViewController: UIViewController {
    
    
    var bookModel : BookModel?
    var isStatusBarHidden: Bool = false
    var isDetectedGesture: Bool = false
    override var prefersStatusBarHidden: Bool{
        return isStatusBarHidden
    }
    
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var bookWebView: UIWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fillViewByModel()  //Modifying view controller
        
        customizeProgressSlider()
        
        addButtonsToNavigationController()
        
        customizeNavigationBar()
        
        bookWebView.paginationBreakingMode = UIWebPaginationBreakingMode.page //webView stuff
        bookWebView.paginationMode = UIWebPaginationMode.leftToRight
        bookWebView.scrollView.bounces = false

    }
    
    //viewDidLoad methods
    func fillViewByModel() {
        
        bookWebView.loadHTMLString(bookModel!.getTextFromCurrentPage(), baseURL: nil)
        
        progressSlider?.value = bookModel!.getCurrentProgressPercent()
        
        self.title = bookModel!.getBookTitle()
        
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
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    //Changing view bounds on tap
    func setNavigationBarToDefaults(){
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        
    }

    func showNavigationBar() {
        
        isStatusBarHidden = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let heightOffset = self.navigationController?.navigationBar.frame.height
        
        changeBookWebViewSize(offset: -heightOffset!)
        
        bookWebView.frame = bookWebView.frame.offsetBy(dx: 0, dy: heightOffset!)
        
        showSlider()
        
    }
    
    
    func hideNavigationBar() {
        
        isStatusBarHidden = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let heightOffset = self.navigationController?.navigationBar.frame.height

        changeBookWebViewSize(offset: heightOffset!)

        bookWebView.frame = bookWebView.frame.offsetBy(dx: 0, dy: -heightOffset!)
        
        hideSlider()
        
    }
    
    func hideSlider(){
        
        let heightOffset = progressSlider.frame.height
        
        changeBookWebViewSize(offset: heightOffset)
        
        progressSlider.isHidden = true
    
    }
    
    func showSlider(){
        
        let heightOffset = progressSlider.frame.height
        
        changeBookWebViewSize(offset: -heightOffset)
        
        progressSlider.isHidden = false

    
    }

    
    func changeBookWebViewSize(offset : CGFloat){
        
        bookWebView.frame.size.height += offset
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        setNavigationBarToDefaults()
        
    }

}
