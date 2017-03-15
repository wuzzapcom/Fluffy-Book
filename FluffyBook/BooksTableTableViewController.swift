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
        
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCellIdentifier", for: indexPath) as? (BooksTableViewCell)
        
        cell?.bookNameLabel!.text = booksTableViewModel?.getBookName(number: indexPath.row)
        cell?.bookAuthorLabel!.text = booksTableViewModel?.getAuthor(number: indexPath.row)
        cell?.tagsLabel!.text = booksTableViewModel?.getTags(number: indexPath.row)
        cell?.bookPictureImageView?.image = UIImage(imageLiteralResourceName: (booksTableViewModel?.getImageName(number: indexPath.row))!)

        return cell!
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let seg = segue.destination as? BookReaderViewController {
            
            seg.bookModel = bookReaderModel?.getBookModelObject()
            
        }

    }


}
