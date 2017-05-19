//
//  WebDictionaryModel.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 25/04/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import Foundation

class WebDictionaryModel{
    
    fileprivate let requestURLStart : String = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20170414T102047Z.355690ae879089f6.6b8496c9af36698028371bf78465cb9a4ec24f76&text="
    fileprivate let requestURLEnd : String = "&lang=en-ru&format=plain&options=0"

    fileprivate let db : DatabaseModel
    
    init() {
        
        db = DatabaseModel()
        
    }
    
    
    public func asyncQuery(forWord word : String) throws {
        
        let w = word.lowercased()
        
        let translation = db.getTranslation(forWord: w)
        
        if translation != nil {
            
            print("Word already in db")
            DispatchQueue.main.async {
                WebDictionaryModel.sendNotifications(withWord: translation!)
            }
            return
            
        }
        
        let requestURL = requestURLStart + w + requestURLEnd
        
        let optionalURL = URL(string: requestURL)

        guard let url = optionalURL else{
            
            throw WebDictionaryException.RuntimeError("request url string cant be converted to url")
            
        }  
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
 
        let session = URLSession(configuration: URLSessionConfiguration.default)
    
        session.dataTask(with: request) { data, result, error in
            
            guard let data = data, error == nil else {
                
                print("URL session finished with error : \(error!.localizedDescription)")
                return
                
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                
                if let code = responseJSON["code"] as? Int {
                    
                    if (code != 200){
                        
                        print("Server returns code \(code)")
                        
                    }
                    
                }
                
                if let translationArray = responseJSON["text"] as? [String]{
                    
                    let firstTranslation = translationArray[0]
                    
                    let wordPreview = WordPreviewModel()
                    wordPreview.setFields(word : w, translation : firstTranslation)
                    
                    
                    DispatchQueue.main.async {
                        
                        let wordPreview = WordPreviewModel()
                        wordPreview.setFields(word : w, translation : firstTranslation)
                        
                        let localDB = DatabaseModel()
                        localDB.addWordPreviewModel(wordPreview: wordPreview)
                        
                        WebDictionaryModel.sendNotifications(withWord: firstTranslation)
                        
                    }
                    
                    
                }
                
                
            }
            
        }.resume()
            
    }
    
    fileprivate static func sendNotifications(withWord translation : String){
    
        NotificationCenter.default.post(name: Notification.Name(Constants.NOTIFICATION_FOR_DICTIONARY_TABLE_VIEW), object: translation)
        NotificationCenter.default.post(name: Notification.Name(Constants.NOTIFICATION_FOR_BOOK_READER_VIEW_CONTROLLER), object: translation)
    
    }
    
    
}

enum WebDictionaryException : Error{
    
    case RuntimeError(String)
    
}
