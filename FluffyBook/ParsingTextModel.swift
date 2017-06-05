//
//  ParsingTextModel.swift
//  TestCoreText
//
//  Created by Владимир Лапатин on 03.06.17.
//  Copyright © 2017 fluffybook. All rights reserved.
//

import Foundation
import CoreText
import UIKit

class ParsingTextModel{
    
    fileprivate var text: [String]
    fileprivate let bounds: CGRect
    fileprivate var parsedWords: [ParsedWord]
    fileprivate var parsedPages: [[ParsedWord]]
    
    fileprivate var startPoint: CGPoint
    fileprivate var currentHeight: Double
    fileprivate var currentWidth: Double
    
    fileprivate let lineHeight: Double
    
    fileprivate var fontSize: Int
    
    fileprivate var numberOfNewlines = 0
    
    init(withText t: String, inRect rect: CGRect){
        
        text = t.components(separatedBy: " ")
        parsedWords = []
        parsedPages = []
        bounds = rect
        lineHeight = Double(bounds.height / 25)
        startPoint = CGPoint(x: 0, y: Double(bounds.height) - lineHeight)
        currentHeight = Double(bounds.height)
        currentWidth = 0.0
        
        fontSize = 20
        
    }
    
    func parseText() ->[[ParsedWord]] {
        
        var str: NSMutableAttributedString
 
        for word in text {

            str = makeAttributedString(word + " ")
            
            NSLog("Word : \(word), size : (width = \(str.size().width), height = \(str.size().height)")
            
            if currentWidth + Double(str.size().width) <= Double(self.bounds.size.width) && numberOfNewlines == 0{
                
                startPoint.x = CGFloat(currentWidth)
                currentWidth += Double(str.size().width)
                
            }
            else{
                
                startPoint.x = 0
                currentWidth = Double(str.size().width)
            
                if startPoint.y - CGFloat(lineHeight) < 0{
                    
                    currentHeight = Double(bounds.height)
                    currentWidth -= Double(startPoint.x)
                    startPoint = CGPoint(x: 0, y: Double(bounds.height) - lineHeight)
                    parsedPages.append(parsedWords)
                    parsedWords = []

                }
                else{
                    if numberOfNewlines != 0{
                        startPoint.y -= CGFloat(lineHeight * Double(numberOfNewlines))
                        currentHeight -= lineHeight * Double(numberOfNewlines)
                    }
                    else{
                        startPoint.y -= CGFloat(lineHeight)
                        currentHeight -= lineHeight
                    }
                }
                
            }
            
            parsedWords.append(ParsedWord(word: str,
                                          rect: CGRect(x: Double(startPoint.x), y: currentHeight, width: currentWidth, height:-currentHeight + Double(startPoint.y))))
            
            numberOfNewlines = isContainingNewline(word: word)
            
        }
        
        if parsedWords.count != 0{
            parsedPages.append(parsedWords)
        }
        
        return parsedPages
        
    }
    
    fileprivate func makeAttributedString(_ word: String) -> NSMutableAttributedString{
        
        let str = NSMutableAttributedString(string: word)
        
        str.addAttribute(kCTForegroundColorAttributeName as String, value: UIColor.black, range: NSMakeRange(0, str.length))
        
        let fontRef = UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium)
        str.addAttribute(kCTFontAttributeName as String, value: fontRef, range: NSMakeRange(0, str.length))
        
        return str
        
    }
    
    fileprivate func isContainingNewline(word:String) -> Int{
        
        var result = 0
        
        for ch in word.unicodeScalars{
            if ch == "\n"{
                result += 1
            }
        }
        return result
        
    }
    
}
