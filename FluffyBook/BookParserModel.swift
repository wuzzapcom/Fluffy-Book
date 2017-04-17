//
//  BookParserModel.swift
//  FluffyBook
//
//  Created by Alexandr Tsukanov on 18.03.17.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import Foundation
import FolioReaderKit
import SSZipArchive
import Zip
import AEXML

/* TODO:
 * Create class for media types (js, jpg, etc...)
 * Rewrite method for unzip book
 * Add Smil-file parser
 * Rewrite all system func
 */

class BookParserModel {
    fileprivate var book: BookModel?
    fileprivate let fileManager = FileManager.default
    fileprivate var bookPath: String!
    fileprivate var servicePath: String!
    fileprivate var bookName: String!
    
    init(_ _bookName: String) {
        bookName = _bookName
    }
    
    /// Before call this func, you must call unzipBook func
    func parseBook() -> BookModel? {
        book = BookModel()
        unzipBook(bookName)
        readContainer()
        readOpf()
        return book
    }
    
    /// Return cover of book in UIImage? format
    fileprivate func parseImage() -> String? {
        return book?.coverImage
    }
    
    /// Don't call. This method not working yet =)
    fileprivate func parseTitle() -> String? {
        return nil
    }
    
    /// Don't call. This method not working yet =)
    fileprivate func parseAuthorName() -> String? {
        return nil
    }
    
    /// Return reference to selected section
    fileprivate func parseText(_ sectionNumber: String) -> String? {
        let keyText = "section".appending(sectionNumber).appending(".xhtml")
//        return book.resources[keyText]?.fullHref
        return getResourceByKey(key: keyText)?.fullHref
    }
    
    func getResourceByKey(key : String) -> BookParserStructServiceFiles?{
        
        for resource in (book?.resources)! {
            if resource.href! == key {
                return resource
            }
            
        }
        
        return nil
        
    }
    
    func getResourceById(id: String) -> BookParserStructServiceFiles? {
        
        for resource in (book?.resources)! {
            if resource.id == id {
                return resource
            }
        }
        return nil
    }
    
    fileprivate func unzipBook(_ book_name: String) {
        guard let zipPathFile = tempZipPath(book_name) else {
            print("Cannot get path of zipfile")
            return
        }
        
        guard let unzipPath = tempUnzipPath() else {
            print("Cannot get path for unzip dir\n")
            return
        }
        
        let result = SSZipArchive.unzipFile(atPath: zipPathFile, toDestination: unzipPath)
        if result {
            bookPath = unzipPath
            print("File unzip\n")
        } else {
            print("Unzip error\n")
        }
        
        do {
            let url = NSURL(string: unzipPath)
            let dir_contents = try fileManager.contentsOfDirectory(at: url! as URL, includingPropertiesForKeys: nil, options: [])
//            print(dir_contents)
        } catch {
            print("Error...\n")
            return
        }
        
//        var items: [String]
//        do {
//            items = try fileManager.contentsOfDirectory(atPath: unzipPath)
//            for item in items {
//                print(item)
//            }
//        } catch {
//            return
//        }
        
    }
    
    fileprivate func tempUnzipPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/\(UUID().uuidString)"
        let url = URL(fileURLWithPath: path)
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            print("Directory created\n")
        } catch {
            return nil
        }
        
        return url.path
    }
    
    fileprivate func tempZipPath(_ bookName: String) -> String? {
//        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
//        path += "/\(UUID().uuidString).zip"
        let path = Bundle.main.path(forResource: bookName, ofType: nil)
        return path
    }
    
    fileprivate func readContainer() {
        let pathContainer = "/META-INF/container.xml"
        let containerfullPath = URL(fileURLWithPath: bookPath).appendingPathComponent(pathContainer)
        do {
            let data = try Data(contentsOf: containerfullPath, options: .alwaysMapped)
            let xmlDoc = try AEXMLDocument(xml: data)
            let opfInfo = BookParserStructServiceFiles()
            opfInfo.href = xmlDoc.root["rootfiles"]["rootfile"].attributes["full-path"]
            // blank
            opfInfo.mediaType = xmlDoc.root["rootfiles"]["rootfile"].attributes["full-path"]
            book?.opfFile = opfInfo
            servicePath = (bookPath as NSString).appendingPathComponent((opfInfo.href as NSString).deletingLastPathComponent)
        } catch {
            print("Cannot read container.xml")
            return
        }
    }
    
    fileprivate func readOpf() {
        let opfPath = (bookPath as NSString).appendingPathComponent((book?.opfFile.href)!)
        let opffullPath = URL(fileURLWithPath: opfPath)
        var id: String?
        do {
            let opfData = try Data(contentsOf: opffullPath, options: .alwaysMapped)
            let xmlDoc = try AEXMLDocument(xml: opfData)
            
            // metadata info in OPF file
            if let pck = xmlDoc.children.first {
                id = pck.attributes["unique-identifier"]
                
                if let version = pck.attributes["version"] {
                    book?.version = Double(version)
                }
            }
            
            // Parse each item in manifest...
            for item in xmlDoc.root["manifest"]["item"].all! {
                let servInfo = BookParserStructServiceFiles()
                servInfo.id = item.attributes["id"]
                servInfo.properties = item.attributes["properties"]
                servInfo.href = item.attributes["href"]
                servInfo.fullHref = (servicePath as NSString).appendingPathComponent(servInfo.href).removingPercentEncoding
                // blank
                servInfo.mediaType = item.attributes["media-type"]
                // + media overlay?
                book?.addResource(servInfo)
                //book?.coverImage = getResourceByKey(key: "images/cover.jpg")?.fullHref
            }
            let metadata = readMetadata(xmlDoc.root["metadata"].children)
            let coverImageInf = getCoverImg(metadata: metadata)
            book?.coverImage = getResourceById(id: coverImageInf!)?.fullHref
            book?.bookTitle = metadata.titles.first
            book?.author = metadata.creators.first?.name
        } catch {
            print("Can't open OPF file")
            return
        }
    }
    
    fileprivate func getCoverImg(metadata: BookParserMetaInfoService) -> String? {
        for meta in metadata.metaAttributes {
            if let metaName = meta.name {
                if metaName == "cover" || metaName == "cover-image" {
                    return meta.content!
                }
            }
        }
        return nil
    }
    
    fileprivate func readMetadata(_ items: [AEXMLElement]) -> BookParserMetaInfoService {
        var metadata = BookParserMetaInfoService()
        
        for item in items {
            
            if item.name == "dc:title" {
                metadata.titles.append(item.value ?? "")
            }
            
            if item.name == "dc:creator" {
                metadata.creators.append(Author(name: item.value ?? "",
                    role: item.attributes["opf:role"] ?? "",
                    fileAs: item.attributes["opf:file-as"] ?? ""))
            }
            
            if item.name == "meta" {
                if item.attributes["name"] != nil {
                    metadata.metaAttributes.append(Meta(name: item.attributes["name"]!, content: item.attributes["content"] ?? ""))
                }
            }
        }
        
        return metadata
    }
}
