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
    
    
    //Adding data to database
    func addWordPreviewModel(wordPreview : WordPreviewModel) {
        
        let words = loadWordsPreviews()
        
        if words.contains(wordPreview){
            
            return
            
        }
        
        try! db.write {
            
            db.add(wordPreview)
            
        }
        
    }
    
    func addBookPreview(bookPreview : BookPreviewModel){
        
        try! db.write {
            
            db.add(bookPreview)
            
            try! db.commitWrite()
            
        }
        
    }
    
    func addBookModel(bookModel : BookModel) {
        
        try! db.write {
            
            db.add(bookModel)
            
            try! db.commitWrite()
            
        }
        
    }
    
    func updateCurrentContentOffset(forModel model : BookModel, withOffset offset : Int){
        
        try! db.write {
            model.setCurrentOffsetInContent(currentOffsetInContent: offset)
        }
        
    }
    
    func updateContentSizesList(forModel model : BookModel, contentSize : Int){
        
        try! db.write {
            model.setContentSizesListForCurrentPage(contentSize: contentSize)
        }
        
    }
    
    //Getting data from database
    func loadBookPreviews() -> [BookPreviewModel]{
    
        let books = db.objects(BookPreviewModel.self)
        var result : [BookPreviewModel] = []
        
        print(books)
        
        for book in books{
            
            if !FileManager.default.fileExists(atPath: book.bookImageName){
                
                try! deleteModelObject(modelObject: getBookModel(withTitle: book.bookTitle))
                deleteModelObject(modelObject: book)
                
            }
            
            result.append(book)
            
        }
        
        return result
    
    }
    
    func checkForFilesExist(path : String) -> Bool{
        
        return FileManager.default.fileExists(atPath:path)
        
    }
    
//    func deleteAllObjects(){
//        
//        print("Deleting all objects")
//        
//        for object in objects{
//            
//            deleteModelObject(modelObject: object)
//            
//        }
//        
//        let books = db.objects(BookModel.self)
//        
//        for book in books{
//            
//            deleteModelObject(modelObject: book)
//            
//        }
//    
//    }
    
    func loadWordsPreviews() -> [WordPreviewModel] {
        
        let words = db.objects(WordPreviewModel.self)
        var result : [WordPreviewModel] = []
        
        for word in words {
            
            result.append(word)
            
        }
        
        return result
        
    }
    
    func getTranslation(forWord : String) -> String?{
        
        let words = loadWordsPreviews()
        
        for word in words {
            
            if word.translation == forWord {
                return word.translation
            }
            
        }
        
        return nil
        
    }
    
    func getBookModel(withTitle ident : String) throws -> BookModel{
        
        let results = db.objects(BookModel.self).filter("bookTitle == \"\(ident)\"")
        print("Results = \(results)")
        
        if results.count == 0 {
            
            throw DatabaseInstansesException.RuntimeError("There is no books with this title or there are few of them.")
            
        }
        
        return results.first!
        
    }
    
    func deleteModelObject(modelObject model : Object) {
        
        try! db.write {
            
            db.delete(model)
            
        }
        
        
        
    }
    
}

enum DatabaseInstansesException : Error{
    
    case RuntimeError(String)
    
}





