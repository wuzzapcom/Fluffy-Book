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
    var searchedWords : [WordPreviewModel]
    
    init(databaseModel db : DatabaseModel) {
        
        database = db
        
        words = database.loadWordsPreviews()
        
        searchedWords = []
        
    }
    
    //Search books
    func searchWords(forWord w : String) {
        
        searchedWords.removeAll()
        
        for word in words {
            
            print(word)
            
            if word.word!.lowercased().contains(w.lowercased()){
                
                searchedWords.append(word)
                
            }
            
        }
        
    }
    
    //Adding data to database
    
    func addWordPreviewToDatabase(wordPreview : WordPreviewModel){
        
        database.addWordPreviewModel(wordPreview: wordPreview)
        
        words = database.loadWordsPreviews()
        
    }
    
    //Remove elements
    
    func deleteElement(atRow indexPath : IndexPath) {
        
        database.deleteModelObject(modelObject: words[indexPath.row])
        
        words = database.loadWordsPreviews()
        
    }
    
    //Getting data
    
    func getWord(indexPath : IndexPath) -> String {

        return words[indexPath.row].word!
        
    }
    
    func getSearchedWord(indexPath : IndexPath) -> WordPreviewModel {
        
        return searchedWords[indexPath.row]
        
    }
    
    func getNumberOfSearchedWords() -> Int {
        
        return searchedWords.count
        
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
