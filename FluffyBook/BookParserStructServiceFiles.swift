//
//  BookParserStructServiceFiles.swift
//  FluffyBook
//
//  Created by Alexandr Tsukanov on 03.04.17.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit
import RealmSwift

class BookParserStructServiceFiles : Object {
    dynamic var id: String!
    dynamic var properties: String?
    dynamic var href: String!
    dynamic var fullHref: String!
    dynamic var mediaType: String!
    
    
    func basePath() -> String! {
        if href == nil || href.isEmpty {
            return nil
        }
        var paths = fullHref.components(separatedBy: "/")
        paths.removeLast()
        return paths.joined(separator: "/")
    }
}

func ==(lhs: BookParserStructServiceFiles, rhs: BookParserStructServiceFiles) -> Bool {
    return lhs.id == rhs.id && lhs.href == rhs.href
}
