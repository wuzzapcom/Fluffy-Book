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


    @IBOutlet weak var bookTextView: UITextView!
    @IBOutlet weak var progressSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookTextView?.text = bookModel?.getTextFromCurrentPage()
        
        progressSlider?.value = (bookModel?.getCurrentProgressPercent())!
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
