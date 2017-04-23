//
//  BookModel.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import Foundation
import RealmSwift

class BookModel : Object {
    
    //var version: Double?
    dynamic var uniqueId: String?
    var resources = List<BookParserStructServiceFiles>()
    dynamic var currentPercent = 0.0
    dynamic var bookTitle: String?
    dynamic var author: String!
    dynamic var coverImage: String?
    dynamic var opfFile: BookParserStructServiceFiles!
    var contentInfo = List<BookParserContentInfo>()
    
    
    func getSection(number: Int) -> String? {
        return nil
    }
    func addResource(_ resource: BookParserStructServiceFiles) {
//        self.resources[resource.href] = resource
        self.resources.append(resource)
    }
    
    func getCurrentProgressPercent() -> Float {
        
        return Float(currentPercent)
        
    }
    
    func getTextFromCurrentPage() -> String {
        var text = ""
        for content in contentInfo {
            let path = URL(fileURLWithPath: (content.resource?.fullHref)!)
            do {
                text += try String(contentsOf: path, encoding: String.Encoding.utf8)
            } catch {
                print("Error\n")
                return ""
            }
            //return text
        }
        return text
    }
    
    func getBookTitle() -> String {
        
        return "Test"
        
    }
    
    // Crutch, 'cause realm is sucker
    // Return title, and counts of title
    func getTitles(num: Int) -> (String?, Int) {
        let path = URL(fileURLWithPath: (contentInfo[num].resource?.fullHref)!)
        var title = ""
        do {
            title = try String(contentsOf: path, encoding: String.Encoding.utf8)
        } catch {
            print("Error\n")
            return ("", 0)
        }
        return (title, contentInfo.count)
    }
    
}
