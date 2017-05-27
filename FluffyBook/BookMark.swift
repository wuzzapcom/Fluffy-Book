//
//  BookMarkStruct.swift
//  FluffyBook
//
//  Created by Alexandr Tsukanov on 20.05.17.
//  Copyright © 2017 FluffyBook. All rights reserved.
//

import Foundation
import RealmSwift

class BookMark : Object {
    
    dynamic fileprivate var chapterNum : Int = 0
    dynamic fileprivate var offset : Int = 0
    
    public var chapter : Int {
        get{
            return chapterNum
        }
    }
    public var offsetInChapter : Int{
        get{
            return offset
        }
    }
    
    func setValues(chapterNum chapter : Int, offset off : Int) {
        
        chapterNum = chapter
        offset = off
        
    }
    
}
