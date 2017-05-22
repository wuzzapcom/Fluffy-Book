//
//  BooksTableTableViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class BooksTableTableViewController: UITableViewController, UIViewControllerPreviewingDelegate, UISearchResultsUpdating {
 
    var booksTableViewModel : BooksTableViewModel?
    var searchController : UISearchController = UISearchController(searchResultsController: nil)
    
    var parse = BookParserModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        booksTableViewModel = BooksTableViewModel()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        registerViewForPreview()
        
        addEditButton()
        
        loadDefaultBookToBD()
        
        addSearchController()
        
        refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleReopening(notification:)),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        
        BookReaderModel.loadDataFromAppGroups()
        
    }
    
    func handleReopening(notification : Notification){
    
        NSLog("App reopened")

        if BookReaderModel.loadDataFromAppGroups() {
            reloadData()
        }
    
    }
    
    func handleRefresh(refreshControl: UIRefreshControl){
        
        reloadData()
        refreshControl.endRefreshing()
        
    }
    
    func reloadData(){
        booksTableViewModel?.loadBookPreviewsFromDatabase()
        tableView.reloadData()
    }
    
    //viewDidLoad methods
    func registerViewForPreview(){
        
        if UIApplication.shared.keyWindow?.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: self.view)
        }
        
    }
    
    func addEditButton() {
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTableAndChangeButton))
        
        self.navigationItem.rightBarButtonItem = editButton
        
    }
    
    func editTableAndChangeButton(){
        
        setEditing(true, animated: true)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditingAndChangeButton))
        
        self.navigationItem.rightBarButtonItem = cancelButton
        
    }
    
    func cancelEditingAndChangeButton() {
        
        setEditing(false, animated: true)
        
        addEditButton()
        
    }
    
    func addSearchController(){
        
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = true
        
        searchController.definesPresentationContext = true
        
        searchController.searchBar.barTintColor = UIColor.white
        
        self.tableView!.tableHeaderView = searchController.searchBar
        
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.bounds.height)
    
    }
    
    func loadDefaultBookToBD(){
        
        booksTableViewModel!.loadBookPreviewsFromDatabase()
        
        guard booksTableViewModel!.books.count == 0 else {
            return
        }
       
        parse.kostylInit("TheW.epub")
        let parsBook = parse.parseBook()
        let bookPreview = BookPreviewModel()
        bookPreview.bookImageName = (parsBook?.coverImage)!
        bookPreview.bookTitle = (parsBook?.bookTitle)!//"TheW.epub"
        bookPreview.bookAuthor = (parsBook?.author)!
        bookPreview.bookTags = "#testtag"
        
        parsBook?.getTitles()
        
        booksTableViewModel?.addBookPreviewToDatabase(bookPreview: bookPreview)
        booksTableViewModel?.addBookModelToDatabase(bookModel: parsBook!)
//
        
        self.tableView!.reloadData()
        
    }
    
    //UISearchResultUpdating method
    func updateSearchResults(for searchController: UISearchController) {
        
        booksTableViewModel?.searchBooks(withTitle: searchController.searchBar.text!)
        
        self.tableView.reloadData()
        
    }

    //tableView methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return booksTableViewModel!.getNumberOfSections()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return booksTableViewModel!.getNumberOfSearchedBooks()
            
        }
        
        return booksTableViewModel!.getNumberOfRows(section: section)
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCellIdentifier", for: indexPath) as? BooksTableViewCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            let searchedModel = booksTableViewModel!.getSearchedBook(indexPath: indexPath)
            
            cell?.bookNameLabel!.text = searchedModel.bookTitle
            cell?.bookAuthorLabel!.text = searchedModel.bookAuthor
            cell?.tagsLabel!.text = searchedModel.bookTags
            cell?.bookPictureImageView!.image = UIImage(imageLiteralResourceName: (searchedModel.bookImageName))
            
            return cell!
            
        }

            cell?.bookNameLabel!.text = self.booksTableViewModel?.getBookTitle(indexPath : indexPath)
            cell?.bookAuthorLabel!.text = self.booksTableViewModel?.getAuthor(indexPath : indexPath)
            cell?.tagsLabel!.text = self.booksTableViewModel?.getTags(indexPath : indexPath)

        let data = try! Data(contentsOf: URL(fileURLWithPath: (self.booksTableViewModel?.getImageName(indexPath : indexPath))!))
        let image = UIImage(data: data)
            
        cell?.bookPictureImageView!.image = image
        
    
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            booksTableViewModel?.deleteElement(atRow: indexPath)
            
            self.tableView.reloadData()
            
        }
        
    }
    
    //Peek and Pop methods
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let indexPath = self.tableView?.indexPathForRow(at: location)
        
        guard indexPath != nil else{
            return nil
        }
        
        let cell = self.tableView?.cellForRow(at: indexPath!)
        
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "BookReaderViewController") as? BookReaderViewController
        
        setModelToDestinationViewController(vc: detailViewController!, indexPath: indexPath)
        
        detailViewController?.preferredContentSize = CGSize(width: 0.0, height: 300)
        
        previewingContext.sourceRect = (cell?.frame)!
        
        return detailViewController
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
        
        showDetailViewController(viewControllerToCommit, sender: self)
        
    }
    
    func setModelToDestinationViewController(vc : BookReaderViewController, indexPath ip : IndexPath?){
        
        if ip == nil{
        
            vc.bookModel = booksTableViewModel?.getSelectedBookModel(indexPath : self.tableView.indexPathForSelectedRow!)
            booksTableViewModel?.setLastOpenDate(toBookWithIndexPath: self.tableView.indexPathForSelectedRow!)
        
            putBookToAddGroups()
        }
        else {
            
            vc.bookModel = booksTableViewModel?.getSelectedBookModel(indexPath : ip!)
            booksTableViewModel?.setLastOpenDate(toBookWithIndexPath: ip!)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backButton = UIBarButtonItem()
        
        backButton.title = ""
 
        self.navigationItem.backBarButtonItem = backButton
        
        if let seg = segue.destination as? BookReaderViewController {
            
            setModelToDestinationViewController(vc: seg, indexPath : nil)
        }
        
    }
    
    func putBookToAddGroups() {
        let book = booksTableViewModel?.getSelectedBookModel(indexPath: self.tableView.indexPathForSelectedRow!)
        let data = try! Data(contentsOf: URL(fileURLWithPath: (book?.coverImage)!))
        let img = UIImage(data: data)
        let commonBookName = book?.bookTitle
        let commonBookAuthor = book?.author
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.FluffyBooktodayWidget")
        
        sharedDefaults?.removeObject(forKey: "bookImgKey")
        sharedDefaults?.removeObject(forKey: "bookNameKey")
        sharedDefaults?.removeObject(forKey: "bookAuthorKey")
        
        sharedDefaults?.set(data, forKey: "bookImgKey")
        sharedDefaults?.set(commonBookName, forKey: "bookNameKey")
        sharedDefaults?.set(commonBookAuthor, forKey: "bookAuthorKey")
        NSLog("Success")
    }


}
