//
//  BookParserContentInfo.swift
//  FluffyBook
//
//  Created by Alexandr Tsukanov on 18.04.17.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import Foundation
import RealmSwift

class BookParserContentInfo : Object {
    dynamic var resource: BookParserStructServiceFiles?
    dynamic var title: String!
    dynamic var fragmentID: String?
    dynamic var countsOfTitles: Int = 0
    var children = List<BookParserContentInfo>()
    
    func initializeVar(title: String, resource: BookParserStructServiceFiles?, fragmentID: String = "") {
        self.initializeVar(title: title, resource: resource, fragmentID: fragmentID, children: List<BookParserContentInfo>())
    }
    
    func initializeVar(title: String, resource: BookParserStructServiceFiles?, fragmentID: String, children: List<BookParserContentInfo>!) {
        self.resource = resource
        self.title = title
        self.fragmentID = fragmentID
        self.children = children
    }
    
}

func ==(lhs: BookParserContentInfo, rhs: BookParserContentInfo) -> Bool {
    return lhs.title == rhs.title && lhs.fragmentID == rhs.fragmentID
}
