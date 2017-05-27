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
    fileprivate dynamic var currentChapter : Int = 0
    fileprivate dynamic var currentOffsetInChapter : Int = 0
    fileprivate var contentSizesList = List<IntObject>()
    fileprivate var bookMarkList = List<BookMark>()
    
    
    func getSection(number: Int) -> String? {
        return nil
    }
    func addResource(_ resource: BookParserStructServiceFiles) {
        self.resources.append(resource)
    }
    
    func getCurrentProgressPercent() -> Float {
        
        print(contentSizesList.endIndex)
        if contentSizesList.endIndex <= currentChapter {
            return 0.0
        }
        
        if contentSizesList[currentChapter].int == 0{
            return 0.0
        }
        
        return Float(currentOffsetInChapter) / Float(contentSizesList[currentChapter].int) * 100
        
    }
    
    func getNewOffsetInContent(bySliderValue value : Float) -> Int{
        
        var newOffset = Int(value * Float(contentSizesList[currentChapter].int) / 100)
        
        while newOffset % Int(UIScreen.main.bounds.width) != 0 {
            
            newOffset += 1
            
        }
        
        if newOffset == contentSizesList[currentChapter].int{
            return newOffset - Int(UIScreen.main.bounds.width)
        }
        
        return newOffset
        
    }
    
    func addBookMark(){
        
        let bookMark = BookMark()
        bookMark.setValues(chapterNum: currentChapter, offset: currentOffsetInChapter)
        
        bookMarkList.append(bookMark)
        
    }
    
    func getBookMarks() -> [BookMark] {
        
        var result: [BookMark] = []
        
        for bookMark in bookMarkList {
            
            result.append(bookMark)
            
        }
        
        return result
        
    }
    
    func getTextFromChapter(path : String) -> String{
        let _path = URL(fileURLWithPath: path)
        do {
            return try String(contentsOf: _path, encoding: String.Encoding.utf8)
            
        } catch {
            print("Error")
            return ""
        }
        
    }
    
    func openNextChapter() -> String? {
        
        let pair = getTitles()
        
        guard currentChapter != pair.0.count - 1 else {
            return nil
        }
        
        let db = DatabaseModel()
        
        db.updateCurrentChapter(forModel: self, currentChapter: currentChapter + 1)
        
        db.updateCurrentContentOffset(forModel: self, withOffset: 0)
        
        return getTextFromChapter(path: pair.1[currentChapter])
        
    }
    
    func openCurrentChapter() -> String{
        
        return getTextFromChapter(path: getTitles().1[currentChapter])
        
    }
    
    func openPrevChapter() -> String? {
        
        guard currentChapter != 0 else {
            return nil
        }
        
        let db = DatabaseModel()
        
        db.updateCurrentChapter(forModel: self, currentChapter: currentChapter - 1)
        
        let x = Int(UIScreen.main.bounds.width)
        
        db.updateCurrentContentOffset(forModel: self, withOffset: contentSizesList[currentChapter].int - x)
        
        
        return getTextFromChapter(path: getTitles().1[currentChapter])
        
    }
    
    
    func setCurrentChapter(currentChapter page : Int){
        currentChapter = page
    }
    
    func setContentSizesListForCurrentPage(contentSize : Int){
//        print(contentSizesList.count)
        while contentSizesList.count <= currentChapter {
            let int = IntObject()
            int.int = 0
            contentSizesList.append(int)
        }
        contentSizesList[currentChapter].int = contentSize
        
        print(contentSizesList[currentChapter].int)
        
    }
    
    func getCurrentChapter() -> Int {
        return currentChapter
    }
    
    func setCurrentOffsetInChapter(currentOffsetInChapter offset : Int){
        
        currentOffsetInChapter = offset
        
    }
    
    func getCurrentOffsetInChapter() -> Int {
        return currentOffsetInChapter
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
