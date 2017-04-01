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
    
}
