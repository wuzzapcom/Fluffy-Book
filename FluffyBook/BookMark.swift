//
//  BookMarkStruct.swift
//  FluffyBook
//
//  Created by Alexandr Tsukanov on 20.05.17.
//  Copyright © 2017 FluffyBook. All rights reserved.
//

import Foundation

struct BookMark {
    fileprivate var chapterNum : Int
    fileprivate var offset : Int
    
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
    
    init(_chapterNum : Int, _offset : Int) {
        
        chapterNum = _chapterNum
        offset = _offset
        
    }
    
//    func getChapterNum() -> Int {
//        return chapterNum
//    }
//    
//    func getOffset() -> Int {
//        return offset
//    }
    
}
