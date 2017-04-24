//
//  BookReaderModel.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import Foundation

class BookReaderModel {
    
    var database : DatabaseModel
    
    init() {
        
        database = try! DatabaseModel()
        
        loadDataFromAppGroups()
        
        deleteTempFiles()
        
    }
    
    func loadDataFromAppGroups() {
        
        var parser = BookParserModel()
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.FluffyBookShare")
        let dataArray = sharedDefaults?.array(forKey: "savedEPUBs") as? [Data]
        let fileManager = FileManager.default
        var documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if dataArray == nil {
            
            print("no new saved files")
            return
            
        }
        
        var i = 0
        
        print(dataArray!.count)
        
        while i < dataArray!.count {
            
            print(i)
        
            documentDirectory.appendPathComponent("saved_\(i).epub")
            
            print(documentDirectory.path)
        
            if fileManager.fileExists(atPath: documentDirectory.path) {
            
                print("file exists")
            
            } else {
            
                fileManager.createFile(atPath: documentDirectory.path, contents: dataArray?[i], attributes: nil)
                
                print("created file \(documentDirectory.path)")
                
                parser.kostylInit(documentDirectory.lastPathComponent)
                
                let book = parser.parseBook()
                
                let preview = BookPreviewModel()
                preview.bookAuthor = book?.author
                preview.bookTitle = book?.bookTitle
                preview.bookImageName = book?.coverImage
                preview.bookTags = "tag"
                
                database.addBookModel(bookModel: book!)
                database.addBookPreview(bookPreview: preview)
                print(database.loadBookPreviews())
            
            }
            
            documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            i += 1
            
        }
        
        sharedDefaults?.removeObject(forKey: "savedEPUBs")
        
    }
    
    func deleteTempFiles() {
        
        let fileManager = FileManager.default
    
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        var i = 0
        
        while true {
            
            print(i)
            
            if fileManager.fileExists(atPath: documentDirectory.path + "/saved_\(i).epub") {
                
                try! fileManager.removeItem(atPath: documentDirectory.path + "/saved_\(i).epub")
                
                print("file deleted")
                
            }else{
                
                print("break")
                
                break
                
            }
            
            i += 1
            
        }
        
        
    
    }
    
    
    func getDatabase() -> DatabaseModel {
        
        return database
        
    }
    
    func getBooksTableViewModel() -> BooksTableViewModel {
        
        return BooksTableViewModel(database: database)
        
    }
    
    func getDictionaryTableViewModel() -> DictionaryTableViewModel{
        
        return DictionaryTableViewModel(databaseModel : database)
        
    }
    
    
}
