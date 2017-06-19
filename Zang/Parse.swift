//
//  Parse.swift
//  Zang
//
//  Created by drskur on 2017. 6. 19..
//  Copyright © 2017년 drskur. All rights reserved.
//

import Foundation
import Kanna

typealias Title = String
typealias MangaURL = String

func extractMangaList(html: String) -> [(Title, MangaURL)] {
    let a = extractEndMangaList(html: html)
    let b = extractSerialMangaList(html: html)
    
    return a + b
    
}

func extractEndMangaList(html: String) -> [(Title, MangaURL)] {
    if let doc = HTML(html: html, encoding: .utf8) {
        return doc.css("#manga-list a").map({ (elm) -> (String, String) in
            return (elm.text!, elm["href"]!)
        })
    }
    
    return []
}

func extractSerialMangaList(html: String) -> [(Title, MangaURL)] {
    if let doc = HTML(html: html, encoding: .utf8) {
        return doc.css("#post .contents a.tx-link").map({ (elm) -> (String, String) in
            return (elm.text!, elm["href"]!)
        })
    }
    
    return []
}
