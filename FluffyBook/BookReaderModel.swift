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
        
    }
    
    func loadDataFromAppGroups() {
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.FluffyBook")
        
        let data = sharedDefaults?.data(forKey: "saved")
        
        if data == nil {
            
            print("no new saved files")
            return
            
        }
        
        sharedDefaults?.removeObject(forKey: "saved")

        let fileManager = FileManager.default
        
        var documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        documentDirectory.appendPathComponent("saved.pdf")
        
        print(documentDirectory)
        
        if fileManager.fileExists(atPath: documentDirectory.path) {
            
            print("file exists")
            
        } else {
            
            fileManager.createFile(atPath: documentDirectory.path, contents: data, attributes: nil)
            
        }
        
        print(fileManager.fileExists(atPath: documentDirectory.path))
        
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
