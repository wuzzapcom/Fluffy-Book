//
//  BookParserMediaInfoService.swift
//  FluffyBook
//
//  Created by Alexandr Tsukanov on 16.04.17.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import Foundation

// Name of fields are taken from something OPF file

struct Author {
    var name: String!
    var role: String!
    var fileAs: String!
    
    init(name: String, role: String, fileAs: String) {
        self.name = name
        self.role = role
        self.fileAs = fileAs
    }
}

struct Meta {
    var name: String?
    var content: String?
//    var id: String?
//    var property: String?
//    var value: String?
//    var refines: String?
    
    init(name: String, content: String) {
        self.name = name
        self.content = content
    }
}

class BookParserMetaInfoService {
    var creators = [Author]()
    var titles = [String]()
    var descriptions = [String]()
    var metaAttributes = [Meta]()
}
