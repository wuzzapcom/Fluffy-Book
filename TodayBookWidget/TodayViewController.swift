//
//  TodayViewController.swift
//  TodayBookWidget
//
//  Created by Alexandr Tsukanov on 15.05.17.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var authorName: UILabel!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var bookImg: UIImageView!
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
        bookImg.image = UIImage(named: "cover.jpg")
    }
    
    func getBookInfo() {
        
    }
    
}
