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
        
        let itemProvider = fileItem.attachments!.first as! NSItemProvider
        
        let identifier = kUTTypeElectronicPublication as String
        
        if itemProvider.hasItemConformingToTypeIdentifier(identifier) {
            
            itemProvider.loadItem(forTypeIdentifier: identifier, options: nil, completionHandler: handleCompletion)
            
        }
        
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        
    }
    
    func handleCompletion(fileURL: NSSecureCoding?, error: Error!) {
        
        if let fileURL = fileURL as? URL {
            
            let sharedDefaults = UserDefaults.init(suiteName: "group.FluffyBook")
            
            let data = NSData(contentsOf : fileURL)
            
            var array = getContainedArray(sharedDefaults: sharedDefaults!, key: "savedEPUBs")
            
            array.append(data!)
            
            print(array.count)
            
            sharedDefaults?.set(array, forKey: "savedEPUBs")
            
            print("saved")
            
        }
    }
    
    func getContainedArray(sharedDefaults : UserDefaults, key : String) -> [NSData] {
        
        
        if let array = sharedDefaults.array(forKey: key) {
            
            print("exists")
            
            if array as? [NSData] != nil {
                
                print("is [NSData]")
                
                sharedDefaults.removeObject(forKey: key)
                
                return array as! [NSData]
                
            }
            
            print("array is not [NSData]")
            
        }
        
        return []
        
    }
    
    
}
