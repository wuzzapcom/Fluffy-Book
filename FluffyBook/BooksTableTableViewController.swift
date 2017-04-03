//
//  BooksTableTableViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class BooksTableTableViewController: UITableViewController, UIViewControllerPreviewingDelegate, UISearchResultsUpdating {
    
    var bookReaderModel : BookReaderModel?
    var booksTableViewModel : BooksTableViewModel?
    var searchController : UISearchController = UISearchController(searchResultsController: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Just one instanse of BookReaderModel, initialization in AppDelegate
        bookReaderModel = (UIApplication.shared.delegate as! AppDelegate).bookReaderModel
        booksTableViewModel = bookReaderModel?.getBooksTableViewModel()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        registerViewForPreview()
        
        addEditButton()
        
        loadDefaultBookToBD()
        
        addSearchController()
        
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.FluffyBook")
        
        let data = sharedDefaults?.data(forKey: "saved") as? NSData
        
        print(data?.length)
        
        
        let fileManager = FileManager.default
        
        let newFileURL = URL(fileURLWithPath:  (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("saved.pdf"))
        
        fileManager.fileExists(atPath: newFileURL.absoluteString)
        
        fileManager.createFile(atPath: newFileURL.absoluteString, contents: data as Data?, attributes: nil)
        
        
//        let url = sharedDefaults?.url(forKey: "saved")!
        
//        print(url)

        
//        print(fileManager.fileExists(atPath: (url?.absoluteString)!))
        
//        let newFileURL = URL(fileURLWithPath:  (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("saved.pdf"))
//        
//        let fileManager = FileManager.default
//        
//        print(fileManager.fileExists(atPath: newFileURL.absoluteString))
//        print(fileManager.fileExists(atPath: newFileURL.relativeString))
        
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
        //because i clean db
        
        let bookPreview = BookPreviewModel()
        bookPreview.bookImageName = "HarryPotterLogo"
        bookPreview.bookTitle = "Harry Potter and Philosopher's Stone"
        bookPreview.bookAuthor = "J.K. Rowling"
        bookPreview.bookTags = "#forkids"
        
        let bookModel = BookModel()
        bookModel.currentPercent = 33.0
        bookModel.bookTitle = "Harry Potter and Philosopher's Stone"
        
        booksTableViewModel?.addBookPreviewToDatabase(bookPreview: bookPreview)
        booksTableViewModel?.addBookModelToDatabase(bookModel: bookModel)
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCellIdentifier", for: indexPath) as? (BooksTableViewCell)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            let searchedModel = booksTableViewModel!.getSearchedBook(indexPath: indexPath)
            
            cell?.bookNameLabel!.text = searchedModel.bookTitle
            cell?.bookAuthorLabel!.text = searchedModel.bookAuthor
            cell?.tagsLabel!.text = searchedModel.bookTags
            cell?.bookPictureImageView!.image = UIImage(imageLiteralResourceName: (searchedModel.bookImageName)!)
            
            return cell!
            
        }
        
        cell?.bookNameLabel!.text = booksTableViewModel?.getBookTitle(indexPath : indexPath)
        cell?.bookAuthorLabel!.text = booksTableViewModel?.getAuthor(indexPath : indexPath)
        cell?.tagsLabel!.text = booksTableViewModel?.getTags(indexPath : indexPath)
        cell?.bookPictureImageView!.image = UIImage(imageLiteralResourceName: (booksTableViewModel?.getImageName(indexPath : indexPath))!)

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
    
    //Segue
    
    func setModelToDestinationViewController(vc : BookReaderViewController, indexPath ip : IndexPath?){
        
        if ip == nil{
        
            vc.bookModel = booksTableViewModel?.getSelectedBookModel(indexPath : self.tableView.indexPathForSelectedRow!)
        
        }
        else {
            
            vc.bookModel = booksTableViewModel?.getSelectedBookModel(indexPath : ip!)
            
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


}
