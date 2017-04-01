//
//  WordPreviewModel.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 01.04.17.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import Foundation
import RealmSwift

class WordPreviewModel : Object{
    
    dynamic var word : String?
    dynamic var translation : String?
    dynamic var transcription : String?
    
}
