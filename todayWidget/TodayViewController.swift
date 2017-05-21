//
//  TodayViewController.swift
//  todayWidget
//
//  Created by Alexandr Tsukanov on 20.05.17.
//  Copyright © 2017 FluffyBook. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding {
    
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestRec = UITapGestureRecognizer(target: self, action: #selector(openBook(sender:)))
        self.view.addGestureRecognizer(gestRec)
        bookTitle.text = "Начните читать"
        bookAuthor.text = "И книга появится!"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
        loadDataFromAppGroups()
    }
    
    func loadDataFromAppGroups() {
        let sharedDefaults = UserDefaults.init(suiteName: "group.FluffyBooktodayWidget")
        let commonBookImgData = sharedDefaults?.data(forKey: "bookImgKey")
        let commonBookName = sharedDefaults?.string(forKey: "bookNameKey")
        let commonBookAuthor = sharedDefaults?.string(forKey: "bookAuthorKey")
        
        guard commonBookImgData != nil else {
            return
        }
        
        bookImage.image = UIImage(data: commonBookImgData!)
        bookTitle.text = commonBookName
        bookAuthor.text = commonBookAuthor
        
    }
    
    func openBook(sender tap : UITapGestureRecognizer) {
        extensionContext?.open(URL(string: "fluffyBook://")!, completionHandler: nil)
    }
}
