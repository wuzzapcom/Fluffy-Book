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
    dynamic var uniqueId: String = ""
    var resources = List<BookParserStructServiceFiles>()
    dynamic var bookTitle: String = ""
    dynamic var author: String = ""
    dynamic var coverImage: String = ""
    dynamic var opfFile: BookParserStructServiceFiles!
    var contentInfo = List<BookParserContentInfo>()
    fileprivate dynamic var currentContentPage : Int = 0
    fileprivate dynamic var currentOffsetInContent : Int = 0
    fileprivate var contentSizesList = List<IntObject>()
    
    
    func getSection(number: Int) -> String? {
        return nil
    }
    func addResource(_ resource: BookParserStructServiceFiles) {
//        self.resources[resource.href] = resource
        self.resources.append(resource)
    }
    
    func getCurrentProgressPercent() -> Float {
        
        print(contentSizesList.endIndex)
        if contentSizesList.endIndex <= currentContentPage {
            return 0.0
        }
        
        if contentSizesList[currentContentPage].int == 0{
            return 0.0
        }
        
        return Float(currentOffsetInContent) / Float(contentSizesList[currentContentPage].int) * 100
        
    }
    
    func getNewOffsetInContent(bySliderValue value : Float) -> Int{
        
        var newOffset = Int(value * Float(contentSizesList[currentContentPage].int) / 100)
        
        while newOffset % Int(UIScreen.main.bounds.width) != 0 {
            
            newOffset += 1
            
        }
        
        return newOffset
        
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
    
    func setCurrentContentPage(currentContentPage page : Int){
        currentContentPage = page
    }
    
    func setContentSizesListForCurrentPage(contentSize : Int){
//        print(contentSizesList.count)
        while contentSizesList.count <= currentContentPage {
            let int = IntObject()
            int.int = 0
            contentSizesList.append(int)
        }
        contentSizesList[currentContentPage].int = contentSize
        
        print(contentSizesList[currentContentPage].int)
        
    }
    
    func getCurrentContentPage() -> Int {
        return currentContentPage
    }
    
    func setCurrentOffsetInContent(currentOffsetInContent offset : Int){
        
        currentOffsetInContent = offset
        
    }
    
    func getCurrentOffsetInContent() -> Int {
        return currentOffsetInContent
    }
    
    
    func getBookTitle() -> String? {
        
        return bookTitle
        
    }
    
    func getTitles() -> ([String], [String]) {
        var titles = [String]()
        var fullPaths = [String]()
        for res in contentInfo {
            var title = "null"
            var fullPath = "null"
            do {
                title = try res.title
                fullPath = (res.resource?.fullHref)!
                
            } catch {
                print("Get titles error\n")
                return ([], [])
            }
            titles.append(title)
            fullPaths.append(fullPath)
        }
        return (titles, fullPaths)
    }
    
}

class IntObject : Object{
    
    dynamic var int : Int = 0
    
}
