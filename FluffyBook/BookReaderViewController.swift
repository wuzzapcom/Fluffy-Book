//
//  BookReaderViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit
import WebKit

class BookReaderViewController: UIViewController, UIGestureRecognizerDelegate, UIWebViewDelegate{
    
    
    var bookModel : BookModel?
    var isStatusBarHidden: Bool = false
    var isDetectedGesture: Bool = false
    var database : DatabaseModel?
    
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
        bookWebView.scrollView.isScrollEnabled = false
        
        bookWebView.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        gestureRecognizer.delegate = self
        bookWebView.addGestureRecognizer(gestureRecognizer)
        
        let translateMenuItem = UIMenuItem(title: "Translation", action: #selector(translation))
        UIMenuController.shared.menuItems = [translateMenuItem]

    }
    
    func translation(){
        
        UIApplication.shared.sendAction(#selector(copy(_:)), to: nil, from: self, for: nil)
        
        let copied = UIPasteboard.general.string
        
        guard let copiedText = copied, copied != nil else {
            return
        }
        
        let webDict = WebDictionaryModel(database: database!)
        
        guard (try? webDict.asyncQuery(forWord: copiedText)) != nil else{
            
            print("Async Query error")
            return
            
        }
        
        print("Selected text is \(copiedText)")
        
        if isStatusBarHidden{
            changeInterfaceHiddency()
        }
        
        self.navigationController?.pushViewController(TranslationPresentationViewController(), animated: true)
        
    }
    
    @IBAction func handleUserChangedSlider(_ sender: Any) {
        
        print("update progress slider")
        
        let newOffset = bookModel?.getNewOffsetInContent(bySliderValue: progressSlider.value)
        
        moveContent(toOffset: CGFloat(newOffset!))
        
    }
    func handleTap(sender : UITapGestureRecognizer){
        
        var screenWidth = UIScreen.main.bounds.width
        
        if sender.location(in: bookWebView).x < screenWidth / 3 {
            screenWidth *= -1
        }
        else if sender.location(in: bookWebView).x < screenWidth * 2 / 3 {
            
            changeInterfaceHiddency()
            return
            
        }
        
        if bookWebView.scrollView.contentOffset.x + screenWidth < 0 || bookWebView.scrollView.contentOffset.x - screenWidth >= bookWebView.scrollView.contentSize.width{
            return
        }
        
        moveContent(toOffset: bookWebView.scrollView.contentOffset.x + screenWidth)

    
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        bookWebView.scrollView.setContentOffset(CGPoint(x:bookModel!.getCurrentOffsetInContent(), y:0), animated: true)
        database?.updateContentSizesList(forModel: bookModel!, contentSize: Int(bookWebView.scrollView.contentSize.width))
    }
    
    func  gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func moveContent(toOffset offset : CGFloat){
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.bookWebView.scrollView.contentOffset.x = offset
            }, completion: nil)
        }
        
        database?.updateCurrentContentOffset(forModel: bookModel!, withOffset: Int(self.bookWebView.scrollView.contentOffset.x))
        
        progressSlider?.value = bookModel!.getCurrentProgressPercent()
        print(progressSlider?.value)
        
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
    
    func changeInterfaceHiddency(){
        
        if isStatusBarHidden {
            showInterface()
        }
        else {
            hideInterface()
        }
        
        isStatusBarHidden = !isStatusBarHidden
        
    }

    func showInterface() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let heightOffset = self.navigationController?.navigationBar.frame.height
        
        changeBookWebViewSize(offset: -heightOffset!)
        
        bookWebView.frame = bookWebView.frame.offsetBy(dx: 0, dy: heightOffset!)
        
        showSlider()
        
    }
    
    
    func hideInterface() {
        
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
