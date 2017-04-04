//
//  ShareViewController.swift
//  BookShare
//
//  Created by Владимир Лапатин on 03.04.17.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController : UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let fileItem = self.extensionContext!.inputItems.first as! NSExtensionItem
        
        let textItemProvider = fileItem.attachments!.first as! NSItemProvider
        
        let identifier = kUTTypePDF as String
        
        if textItemProvider.hasItemConformingToTypeIdentifier(identifier) {
            
            textItemProvider.loadItem(forTypeIdentifier: identifier, options: nil, completionHandler: handleCompletion)
            
        }
        
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        
    }
    
    func handleCompletion(fileURL: NSSecureCoding?, error: Error!) {
        
        if let fileURL = fileURL as? URL {
            
            let sharedDefaults = UserDefaults.init(suiteName: "group.FluffyBook")
            
            let data = NSData(contentsOf : fileURL)
            
            sharedDefaults?.set(data, forKey: "saved")
            
        }
    }
    
    
}
