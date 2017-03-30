//
//  BookPreview.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 30.03.17.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import Foundation
import RealmSwift

class BookPreviewModel : Object{
    
    dynamic var bookImageName : String?
    dynamic var bookTitle : String?
    dynamic var bookAuthor : String?
    dynamic var bookTags : String?
    dynamic var bookIdentifier : Int = 0
    
//    required init(imageName image : String, title : String, author : String, tags : String, identifier : Int) {
//        bookImageName = image
//        bookTitle = title
//        bookAuthor = author
//        bookTags = tags
//        bookIdentifier = identifier
//    }
    

    
}
