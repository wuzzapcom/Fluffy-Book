//
//  DatabaseModel.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 30.03.17.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseModel{

//    func addBookToDatabase(book : BookDatabase){}
    
//    func addWordToDatabase(word : WordDatabase){}
    
    var db : Realm
    
    init() {
        
        db = try! Realm()
        
    }
    
    func loadBookPreviews() -> [BookPreviewModel]{
    
        let books = db.objects(BookPreviewModel.self)
        var result : [BookPreviewModel] = []
        
        for book in books{
            
            result.append(book)
            
        }
        
        return result
    
    }
    
    func addBookPreview(bookPreview : BookPreviewModel){
        
//        let bookDB = BookPreviewDatabase()
//        bookDB.bookPreview = bookPreview
        
        try! db.write {
            
           db.add(bookPreview)
            
        }
        
    }
    
}

//
//class BookPreviewDatabase : Object{
//
//    var bookPreview : BookPreviewModel?
//
//}

class WordDatabase{}
