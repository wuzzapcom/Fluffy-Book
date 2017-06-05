//
//  ParsedPageModel.swift
//  TestCoreText
//
//  Created by Владимир Лапатин on 03.06.17.
//  Copyright © 2017 fluffybook. All rights reserved.
//

import Foundation
import CoreText

class ParsedPageModel{
    
    fileprivate var words: [ParsedWord]
    
    init(){
        
        words = []
        
    }
    
    func addWords(parsedWord: ParsedWord){
        
        words.append(parsedWord)
        
    }
    
    
}

class ParsedWord{
    
    fileprivate var word: NSMutableAttributedString
    fileprivate var positionInPage: CGRect
    
    init(word w: NSMutableAttributedString, rect: CGRect){
        
        word = w
        positionInPage = rect
        
    }
    
    func getRect() -> CGRect {
        
        return positionInPage
        
    }
    
    func getWord() -> NSMutableAttributedString {
        
        return word
        
    }
    
}
