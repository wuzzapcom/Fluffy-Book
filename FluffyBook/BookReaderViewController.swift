//
//  BookReaderViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit
import WebKit

class BookReaderViewController: UIViewController, UIGestureRecognizerDelegate, UIWebViewDelegate, TransferDataProtocol {
    
    
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
        
        database = DatabaseModel()
        
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
        gestureRecognizer.numberOfTapsRequired = 2
        bookWebView.addGestureRecognizer(gestureRecognizer)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        bookWebView.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightSwipe.direction = .right
        bookWebView.addGestureRecognizer(rightSwipe)

        
        let translateMenuItem = UIMenuItem(title: "Translation", action: #selector(translation))
        UIMenuController.shared.menuItems = [translateMenuItem]

    }
    
    func handleSwipe(sender : UISwipeGestureRecognizer){
        
        if sender.direction == .up || sender.direction == .down{
            return
        }
        
        var screenWidth = UIScreen.main.bounds.width
        
        if sender.direction == .right {
            
            screenWidth *= -1
            
        }
        
//        if bookWebView.scrollView.contentOffset.x + screenWidth < 0 || bookWebView.scrollView.contentOffset.x - screenWidth >= bookWebView.scrollView.contentSize.width{
//            return
//        }
        
        if bookWebView.scrollView.contentOffset.x + screenWidth < 0 {
            
            let text = bookModel?.openPrevChapter()
            
            guard text != nil else {
                return
            }
            
            openHTMLInWebView(text: text!)
            progressSlider.value = bookModel!.getCurrentProgressPercent()
            return
            
        }
        
        else if bookWebView.scrollView.contentOffset.x + screenWidth >= bookWebView.scrollView.contentSize.width {
            
            let text = bookModel?.openNextChapter()
            
            guard text != nil else {
                return
            }
            
            openHTMLInWebView(text: text!)
            progressSlider.value = bookModel!.getCurrentProgressPercent()
            return
            
        }
        
        
        moveContent(toOffset: bookWebView.scrollView.contentOffset.x + screenWidth)
        
    }
    
    func translation(){
        
        UIApplication.shared.sendAction(#selector(copy(_:)), to: nil, from: self, for: nil)
        
        let copied = UIPasteboard.general.string
        
        guard let copiedText = copied, copied != nil else {
            return
        }
        
        let webDict = WebDictionaryModel()
        
        guard (try? webDict.asyncQuery(forWord: copiedText)) != nil else{
            
            print("Async Query error")
            return
            
        }
        
        print("Selected text is \(copiedText)")
        
//        if isStatusBarHidden{
//            changeInterfaceHiddency()
//        }
//        self.navigationController?.pushViewController(TranslationPresentationViewController(), animated: true)
        
        openTranslationView()
        
    }
    
    func openTranslationView(){
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        let translationView = TranslationPresentationViewController()
        translationView.prevViewBlur = blurEffectView
        translationView.modalPresentationStyle = .overCurrentContext
        present(translationView, animated: true, completion: nil)
        
    }
    
    @IBAction func handleUserChangedSlider(_ sender: Any) {
        
        print("update progress slider")
        
        let newOffset = bookModel?.getNewOffsetInContent(bySliderValue: progressSlider.value)
        
        moveContent(toOffset: CGFloat(newOffset!))
        
    }

    
    func handleTap(sender : UITapGestureRecognizer){
        
        changeInterfaceHiddency()
    
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        bookWebView.scrollView.setContentOffset(CGPoint(x:bookModel!.getCurrentOffsetInChapter(), y:0), animated: true)
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
        
        openHTMLInWebView(text: bookModel!.openCurrentChapter())
        
        progressSlider?.value = bookModel!.getCurrentProgressPercent()
        
        self.title = bookModel!.getBookTitle()
        
    }
    
    func openHTMLInWebView(text : String){
        
        bookWebView.loadHTMLString(text, baseURL: nil)
        
    }
    
    func customizeProgressSlider() {
        
        progressSlider.setThumbImage(#imageLiteral(resourceName: "Bookmark"), for: UIControlState.normal)
        
    }
    
    func addButtonsToNavigationController(){
        
        let markButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: nil)
        
        let contentsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "List"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleContentsButton(sender:)))
        
        self.navigationItem.rightBarButtonItems = [markButton, contentsButton]
        
    }
    
    func handleContentsButton(sender : UIBarButtonItem){
        
        let contentTableViewController = storyboard?.instantiateViewController(withIdentifier: Constants.CONTENT_TABLE_VIEW_IDENTIFIER) as! ContentsTableViewController
        
        contentTableViewController.currentBookModel = bookModel!
        
        contentTableViewController.delegate = self
        
        navigationController?.pushViewController(contentTableViewController, animated: true)
        
    }
    
    func setSelectedRow(number n: Int?) {
        
        guard let number = n, n != nil else {
            NSLog("number of chapter is nil")
            return
        }
        
        NSLog("Number of chapter is \(number)")
        
        var pathsToFiles = bookModel!.getTitles().1
        
        print(pathsToFiles[number])
        
        database?.updateCurrentChapter(forModel: bookModel!, currentChapter: number)
        
        database?.updateCurrentContentOffset(forModel: bookModel!, withOffset: 0)
        
        openHTMLInWebView(text: bookModel!.openCurrentChapter())
        
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
