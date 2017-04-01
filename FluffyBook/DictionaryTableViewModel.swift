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
     
     Class gets data from database and it is able put data to it.
     
     */
    
    var database : DatabaseModel
    var words : [WordPreviewModel]
    
    init(databaseModel db : DatabaseModel) {
        
        database = db
        words = database.loadWordsPreviews()
        
    }
    
    //Adding data to database
    
    func addWordPreviewToDatabase(wordPreview : WordPreviewModel){
        
        database.addWordPreviewModel(wordPreview: wordPreview)
        
        words = database.loadWordsPreviews()
        
    }
    
    //Remove elements
    
    func deleteElement(atRow indexPath : IndexPath) {
        
//        words.remove(at: indexPath.row)
        
        database.deleteModelObject(modelObject: words[indexPath.row])
        
        words = database.loadWordsPreviews()
        
    }
    
    //Getting data
    
    func getWord(indexPath : IndexPath) -> String {

        return words[indexPath.row].word!
        
    }
    
    func getTranslation(indexPath : IndexPath) -> String {

        return words[indexPath.row].translation!
        
    }
    
    func getNumberOfSections() -> Int {
        
        return 1
        
    }
    
    func getNumberOfRows(section : Int) -> Int {
        
        return words.count
        
    }
    
}
