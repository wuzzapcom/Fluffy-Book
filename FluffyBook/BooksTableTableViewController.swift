//
//  BooksTableTableViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class BooksTableTableViewController: UITableViewController {
    
    var bookReaderModel : BookReaderModel?
    var booksTableViewModel : BooksTableViewModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Just one instanse of BookReaderModel, initialization in AppDelegate
        bookReaderModel = (UIApplication.shared.delegate as! AppDelegate).bookReaderModel
        booksTableViewModel = bookReaderModel?.getBooksTableViewModel()
        
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return booksTableViewModel!.getNumberOfSections()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return booksTableViewModel!.getNumberOfRows(section: section)
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCellIdentifier", for: indexPath) as? (BooksTableViewCell)
        
        cell?.bookNameLabel!.text = booksTableViewModel?.getBookName(indexPath : indexPath)
        cell?.bookAuthorLabel!.text = booksTableViewModel?.getAuthor(indexPath : indexPath)
        cell?.tagsLabel!.text = booksTableViewModel?.getTags(indexPath : indexPath)
        cell?.bookPictureImageView?.image = UIImage(imageLiteralResourceName: (booksTableViewModel?.getImageName(indexPath : indexPath))!)

        return cell!
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        booksTableViewModel?.setSelectedCell(indexPath: indexPath)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let seg = segue.destination as? BookReaderViewController {
            
            seg.bookModel = bookReaderModel?.getBookModelObject()
            
        }

    }


}
