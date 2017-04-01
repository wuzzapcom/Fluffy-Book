//
//  BooksTableTableViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class BooksTableTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    var bookReaderModel : BookReaderModel?
    var booksTableViewModel : BooksTableViewModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Just one instanse of BookReaderModel, initialization in AppDelegate
        bookReaderModel = (UIApplication.shared.delegate as! AppDelegate).bookReaderModel
        booksTableViewModel = bookReaderModel?.getBooksTableViewModel()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        registerViewForPreview()
        
        addEditButton()
        
        loadDefaultBookToBD()
        
    }
    
    func loadDefaultBookToBD(){
        
        var books = booksTableViewModel!.getBookPreviewsFromDatabase()
        
        if books.count == 0 {
        
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
            
            books = booksTableViewModel!.getBookPreviewsFromDatabase()
            
            let word1 = WordPreviewModel()
            word1.word = "Home"
            word1.translation = "Дом"
            booksTableViewModel?.addWordPreviewToDatabase(wordPreview: word1)
            let word2 = WordPreviewModel()
            word2.word = "Gay"
            word2.translation = "Человек нетрадиционной сексуальной ориентации"
            booksTableViewModel?.addWordPreviewToDatabase(wordPreview: word2)
        }
        print(books)
        
        self.tableView!.reloadData()
        
        
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
    
    func registerViewForPreview(){
        
        if UIApplication.shared.keyWindow?.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: self.view)
        }
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return booksTableViewModel!.getNumberOfSections()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return booksTableViewModel!.getNumberOfRows(section: section)
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCellIdentifier", for: indexPath) as? (BooksTableViewCell)
        
        cell?.bookNameLabel!.text = booksTableViewModel?.getBookTitle(indexPath : indexPath)
        cell?.bookAuthorLabel!.text = booksTableViewModel?.getAuthor(indexPath : indexPath)
        cell?.tagsLabel!.text = booksTableViewModel?.getTags(indexPath : indexPath)
        cell?.bookPictureImageView?.image = UIImage(imageLiteralResourceName: (booksTableViewModel?.getImageName(indexPath : indexPath))!)

        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            booksTableViewModel?.deleteElement(atRow: indexPath)
            self.tableView.reloadData()
            
        }
        
    }
    
    
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
    
    func setModelToDestinationViewController(vc : BookReaderViewController, indexPath ip : IndexPath?){
        
//        vc.bookModel = bookReaderModel?.getBookModelObject()
        
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
