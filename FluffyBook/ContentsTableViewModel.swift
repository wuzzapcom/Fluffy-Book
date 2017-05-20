//
//  ContentsTableViewModel.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 20.05.17.
//  Copyright © 2017 FluffyBook. All rights reserved.
//

import Foundation

class ContentsTableViewModel{
    
    fileprivate var content : [String]
    
    init(withContent c : [String]){
        
        content = c
        
    }
    
    func getNumberOfElements() -> Int {
        
        return content.count
        
    }
    
    func getChapterTitle(withIndexPath indexPath : IndexPath) -> String{
        
        return content[indexPath.row]
        
    }
    
    
    
    
    
}
