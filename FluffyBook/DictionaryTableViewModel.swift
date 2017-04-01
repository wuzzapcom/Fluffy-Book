//
//  DictionaryWordsModel.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 15/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import Foundation


class DictionaryTableViewModel{
    
    /*
     
     This class should return to controller data for DictionaryTableViewCell.
     Idea of realization is array with this signature : WordTranslationData[sector][row], where 1 sector may
     contain up to 20 rows, and WordTranslationData contains all needed information, which loading from web or DB.
 
     Same logic in BooksTableViewModel.
     
     */
    
    var database : DatabaseModel
    var words : [WordPreviewModel]
    
    init(databaseModel db : DatabaseModel) {
        
        database = db
        words = database.loadWordsPreviews()
        
    }
    
    func getWord(indexPath : IndexPath) -> String {
        
//        return "Home"
        return words[indexPath.row].word!
        
    }
    
    func getTranslation(indexPath : IndexPath) -> String {
        
//        return "Дом"
        return words[indexPath.row].translation!
        
    }
    
    func setSelectedCell(indexPath : IndexPath) {
        
        /* 
         
         Save selected path and create WordTranslationModel object in BookReaderModel with this info for segue.
         Or, may be, create WordTranslationModel from this object?
         This make sense with confidence that this object will create only from this context.
 
        */
        
        
    }
    
    func deleteElement(atRow indexPath : IndexPath) {
        
        words.remove(at: indexPath.row)
        
    }
    
    func getNumberOfSections() -> Int {
        
        return 1
        
    }
    
    func getNumberOfRows(section : Int) -> Int {
        
        return words.count
        
    }
    
}
