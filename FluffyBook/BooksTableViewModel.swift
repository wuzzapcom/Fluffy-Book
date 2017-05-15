//
//  BooksTableViewModel.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 15/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import Foundation


class BooksTableViewModel{
    
    /*
     
     Class gets data from database and it is able put data to it.
 
     */
    
    var books : [BookPreviewModel]
    var searchedBooks : [BookPreviewModel]
    var database : DatabaseModel
    
    init() {

        database = DatabaseModel()
//        database.clearDatabase()

        books = database.loadBookPreviews()
        
        searchedBooks = []
        
    }
    
    //Search books
    func searchBooks(withTitle title : String) {
        
        searchedBooks.removeAll()
        
        for book in books {
            
            if book.bookTitle
                .lowercased().contains(title.lowercased()) {
                
                searchedBooks.append(book)
                
            }
            
        }
        
    }
    
    func loadBookPreviewsFromDatabase(){
        
        books = database.loadBookPreviews()
        
        print("books inside booksTableViewModel")
        print(books)
        
    }
    
    //Adding to Database
    
    func addBookModelToDatabase(bookModel : BookModel) {
        
        database.addBookModel(bookModel: bookModel)
        
        books = database.loadBookPreviews()
        
    }
    
    func addBookPreviewToDatabase(bookPreview : BookPreviewModel){
        
        database.addBookPreview(bookPreview: bookPreview)
        
        books = database.loadBookPreviews()
        
    }
    
    // Deleting elements
    
    func deleteElement(atRow indexPath : IndexPath) {
        
        database.deleteModelObject(modelObject: books[indexPath.row])
        
        books = database.loadBookPreviews()
        
    }
    
    func setLastOpenDate(toBookWithIndexPath indexPath : IndexPath) {
        
        database.setLastOpenDate(toBook: books[indexPath.row])
        
    }
    
    //Getting data
    
    func getSelectedBookModel(indexPath : IndexPath) -> BookModel {
        
        return try! database.getBookModel(withTitle: books[indexPath.row].bookTitle)
        
    }
    
    func getSearchedBook(indexPath : IndexPath) -> BookPreviewModel {
        
        return searchedBooks[indexPath.row]
        
    }
    
    func getNumberOfSearchedBooks() -> Int {
        
        return searchedBooks.count
        
    }

    func getBookTitle(indexPath : IndexPath) -> String {
        
        return books[indexPath.row].bookTitle
        
    }
    
    func getAuthor(indexPath : IndexPath) -> String {
        
        return books[indexPath.row].bookAuthor
        
    }
    
    func getTags(indexPath : IndexPath) -> String {
        
        return books[indexPath.row].bookTags
        
    }
    
    func getImageName(indexPath : IndexPath) -> String {
        
        print("getImageName \(indexPath.row)")
        print(books)
        
        return books[indexPath.row].bookImageName
        
    }
    
    func getNumberOfSections() -> Int {
        
        return 1
        
    }
    
    func getNumberOfRows(section : Int) -> Int {
        
        return books.count
        
    }
    
}
