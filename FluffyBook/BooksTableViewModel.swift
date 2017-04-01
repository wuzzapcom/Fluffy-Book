//
//  BooksTableViewModel.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 15/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import Foundation


class BooksTableViewModel{
    
    var booksSections = 1
    var booksRows = 1
    
    var books : [BookPreviewModel]
    var database : DatabaseModel
    
    init(database db : DatabaseModel) {
        
        database = db
        
        books = database.loadBookPreviews()
        
    }
    
    
    func getBookTitle(indexPath : IndexPath) -> String {
        
        return books[indexPath.row].bookTitle!
        
    }
    
    func getAuthor(indexPath : IndexPath) -> String {
        
        return books[indexPath.row].bookAuthor!
        
    }
    
    func getTags(indexPath : IndexPath) -> String {
        
        return books[indexPath.row].bookTags!
        
    }
    
    func getImageName(indexPath : IndexPath) -> String {
        
        return books[indexPath.row].bookImageName!
        
    }
    
    func getNumberOfSections() -> Int {
        
        return booksSections
        
    }
    
    func getNumberOfRows(section : Int) -> Int {
        
        return books.count
        
    }
    
    func deleteElement(atRow indexPath : IndexPath) {
        
        books.remove(at: indexPath.row)
        
    }
    
    func getSelectedBookModel(indexPath : IndexPath) -> BookModel {
        
        return try! database.getBookModel(withTitle: books[indexPath.row].bookTitle!)
        
//        return try! database.getBookModel(withTitle: "Harry Potter and Philosopher's Stone")
        
//        database
        
//        return BookModel(/*url: URL(fileURLWithPath: ""), title: ""*/)
        
    }
    
    func addBookModelToDatabase(bookModel : BookModel) {
        
        database.addBookModel(bookModel: bookModel)
        
    }
    
    func addBookPreviewToDatabase(bookPreview : BookPreviewModel){
        
        database.addBookPreview(bookPreview: bookPreview)
        
    }
    
    func addWordPreviewToDatabase(wordPreview : WordPreviewModel){
        
        database.addWordPreviewModel(wordPreview: wordPreview)
        
    }
    
    func getBookPreviewsFromDatabase() -> [BookPreviewModel]{
        
        books = database.loadBookPreviews()
        return books
        
    }
    
}
