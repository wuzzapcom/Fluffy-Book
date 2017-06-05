//
//  ViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit


class ViewController: UIViewController, TransferDataProtocol {


    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var textPresenter: TextPresenterView!
    
    var parsedWords:[[ParsedWord]]?
    var startValue = 0
    
    var bookModel:BookModel?
    
    fileprivate var isStatusBarHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = bookModel!.getBookTitle()
        customizeProgressSlider()
//        changeInterfaceHiddency()
        addButtonsToNavigationController()
        setTranslateMenu()
        self.tabBarController?.tabBar.isHidden = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
//        gestureRecognizer.delegate = self
        gestureRecognizer.numberOfTapsRequired = 1
        textPresenter.addGestureRecognizer(gestureRecognizer)
        
        textPresenter.parsedWords = parsedWords?[startValue]
    }
    
    func customizeProgressSlider() {
        
        progressSlider.backgroundColor = UIColor.white
        
        progressSlider.setThumbImage(#imageLiteral(resourceName: "Bookmark"), for: UIControlState.normal)
        
    }
    
    func addButtonsToNavigationController(){
        
        let markButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: #selector(handleBookMarkButton(sender:)))
        
        let contentsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "List"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleContentsButton(sender:)))
        
        self.navigationItem.rightBarButtonItems = [markButton, contentsButton]
        
    }
    
    func setTranslateMenu() {
        
        let translateMenuItem = UIMenuItem(title: "Translate", action: #selector(translation))
        UIMenuController.shared.menuItems = [translateMenuItem]
        
    }
    
    func handleBookMarkButton(sender:UIBarButtonItem){
        
        let db = DatabaseModel()
        db.addBookMark(forModel: bookModel!)
        
    }
    
    func handleContentsButton(sender : UIBarButtonItem){
        
        let contentTableViewController = storyboard?.instantiateViewController(withIdentifier: Constants.CONTENT_TABLE_VIEW_IDENTIFIER) as! ContentsTableViewController
        
        contentTableViewController.currentBookModel = bookModel!
        
        contentTableViewController.delegate = self
        
        navigationController?.pushViewController(contentTableViewController, animated: true)
        
    }
    
    func translation(){
        
        
    }
    
    func openTranslationView(){
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        let translationView = storyboard!.instantiateViewController(withIdentifier: Constants.TRANSLATION_PRESENTATION_ID) as! TranslationPresentationViewController
        translationView.prevViewBlur = blurEffectView
        translationView.modalPresentationStyle = .overCurrentContext
        present(translationView, animated: true, completion: nil)
        
    }
    
    func setSelectedRow(number n: Int?) {
        
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
        
        progressSlider.isHidden = false
        
    }
    
    
    func hideInterface() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        progressSlider.isHidden = true
        
    }
    
    func handleTap(sender : UITapGestureRecognizer){
        
        changeInterfaceHiddency()
        
    }
    
    func draw(withPage: Int){
        
        guard textPresenter != nil else {
            startValue = withPage
            return
        }
        textPresenter.parsedWords = parsedWords?[withPage]
        textPresenter.setNeedsDisplay()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }



}

