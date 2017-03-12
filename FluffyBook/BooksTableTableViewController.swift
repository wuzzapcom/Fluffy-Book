//
//  BooksTableTableViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class BooksTableTableViewController: UITableViewController {
    
    public var bookReaderModel : BookReaderModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Just one instanse of BookReaderModel, initialization in AppDelegate
        bookReaderModel = (UIApplication.shared.delegate as! AppDelegate).bookReaderModel
        
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookIdentifier", for: indexPath)

        cell.textLabel!.text = "Book1"

        return cell
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let seg = segue.destination as? BookReaderViewController {
            
            seg.bookModel = bookReaderModel?.getBookModelObject()
            
        }

    }


}
