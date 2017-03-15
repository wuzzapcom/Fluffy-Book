//
//  BooksTableViewModel.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 15/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import Foundation


class BooksTableViewModel{
    
    
    func getBookName(indexPath : IndexPath) -> String {
        
        return "Harry Potter"
        
    }
    
    func getAuthor(indexPath : IndexPath) -> String {
        
        return "J.K. Rowling"
        
    }
    
    func getTags(indexPath : IndexPath) -> String {
        
        return "#forKids"
        
    }
    
    func getImageName(indexPath : IndexPath) -> String {
        
        return "HarryPotterLogo"
        
    }
    
    
    func setSelectedCell(indexPath : IndexPath) {}
    
    func getNumberOfSections() -> Int {
        
        return 1
        
    }
    
    func getNumberOfRows(section : Int) -> Int {
        
        return 1
        
    }
    
    
    
    
}
