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
    
    //Singleton class.
    //Or something like this, i guess.
    // IMPORTANT 
    
    var db : Realm
    
    private static var instanses : Int = 0
    
    init() throws {
        
        if DatabaseModel.instanses == 0 {
            DatabaseModel.instanses = 1
        }
        else {
            
            throw DatabaseInstansesException.RuntimeError("More than one instanse of this class")
            
        }
        
        db = try! Realm()
        
        try! db.write {
            db.deleteAll()
        }
        
        
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
        
        try! db.write {
            
           db.add(bookPreview)
            
        }
        
    }
    
    func getBookModel(withTitle ident : String) throws -> BookModel{
        
        let results = db.objects(BookModel.self).filter("bookTitle == \"\(ident)\"")
        
        if results.count != 1 {
            
            throw DatabaseInstansesException.RuntimeError("There is no books with this title or there are few of them.")
            
        }
        
        return results.first!
        
    }
    
    func addBookModel(bookModel : BookModel) {
        
        try! db.write {
            
            db.add(bookModel)
            
        }
        
    }
    
}


enum DatabaseInstansesException : Error{
    
    case RuntimeError(String)
    
}





