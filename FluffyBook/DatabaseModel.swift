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
    
    var db : Realm
    
    init(){
        
        db = try! Realm()

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
    
    func clearDatabase(){
        try! db.write {
            db.deleteAll()
        }
        
    }
    
    func addBookPreview(bookPreview : BookPreviewModel){
        
        try! db.write {
            
            db.add(bookPreview)
            
            try! db.commitWrite()
            
        }
        
    }
    
    func addBookMark(forModel model : BookModel){
        
        try! db.write {
            model.addBookMark()
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
            model.setCurrentOffsetInChapter(currentOffsetInChapter: offset)
        }
        
    }
    
    func updateContentSizesList(forModel model : BookModel, contentSize : Int){
        
        try! db.write {
            model.setContentSizesListForCurrentPage(contentSize: contentSize)
        }
        
    }
    
    func updateCurrentChapter(forModel model : BookModel, currentChapter : Int){
    
        try! db.write{
            model.setCurrentChapter(currentChapter: currentChapter)
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
            
            print("LoadBookPreviews : last open date \(book.lastOpenDate)")
            
            result.append(book)
            
        }
        
        return result
    
    }
    
    func checkForFilesExist(path : String) -> Bool{
        
        return FileManager.default.fileExists(atPath:path)
        
    }
    
    func setLastOpenDate(toBook book : BookPreviewModel){
        
        let date = Date()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        
        let currentDate = dateFormatter.string(from: date)
        
        print("setLastOpenDate : \(currentDate)")
        
        try! db.write {
            
            book.lastOpenDate = currentDate
            
        }
        
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
//            print(word.word)
            if word.word == forWord {
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





