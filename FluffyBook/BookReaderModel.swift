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
