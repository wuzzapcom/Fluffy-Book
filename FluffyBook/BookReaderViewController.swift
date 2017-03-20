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

        fillViewByModel()

        addTapHandler()
        
        customizeProgressSlider()
        
        addButtonsToNavigationController()
        
        customizeNavigationBar()

    }
    
    func fillViewByModel() {
        
        bookTextView?.text = bookModel!.getTextFromCurrentPage()
        
        progressSlider?.value = bookModel!.getCurrentProgressPercent()
        
        self.title = bookModel!.getBookTitle()
        
    }
    
    func addTapHandler() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapHideInterface(_:)))
        
        bookTextView.addGestureRecognizer(tap)
        
    }
    
    func customizeProgressSlider() {
        
        progressSlider.setThumbImage(#imageLiteral(resourceName: "Bookmark"), for: UIControlState.normal)
        
    }
    
    func addButtonsToNavigationController(){
    
        let markButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: nil)
        
//        markButton.title = "Marks"
        
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

    
    func changeBookTextViewSize(offset : CGFloat){
        
        bookTextView.frame.size.height += offset
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        setNavigationBarToDefaults()
        
    }

    

}
