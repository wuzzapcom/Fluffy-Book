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
        
        return books[0].bookTitle!
        
    }
    
    func getAuthor(indexPath : IndexPath) -> String {
        
        return books[0].bookAuthor!
        
    }
    
    func getTags(indexPath : IndexPath) -> String {
        
        return books[0].bookTags!
        
    }
    
    func getImageName(indexPath : IndexPath) -> String {
        
        return books[0].bookImageName!
        
    }
    
    
    func setSelectedCell(indexPath : IndexPath) {}
    
    func getNumberOfSections() -> Int {
        
        return booksSections
        
    }
    
    func getNumberOfRows(section : Int) -> Int {
        
        return books.count
        
    }
    
    func deleteElement(atRow indexPath : IndexPath) {
        
        books.remove(at: 0)
        
    }
    
    func getSelectedBookModel(forIndex indexPath : IndexPath) -> BookModel {
        
        return try! database.getBookModel(withTitle: "Harry Potter and Philosopher's Stone")
        
//        database
        
//        return BookModel(/*url: URL(fileURLWithPath: ""), title: ""*/)
        
    }
    
    func addBookModelToDatabase(bookModel : BookModel) {
        
        database.addBookModel(bookModel: bookModel)
        
    }
    
    func addBookPreviewToDatabase(bookPreview : BookPreviewModel){
        
        database.addBookPreview(bookPreview: bookPreview)
        
    }
    
    func getBookPreviewsFromDatabase() -> [BookPreviewModel]{
        
        books = database.loadBookPreviews()
        return books
        
    }
    
}
