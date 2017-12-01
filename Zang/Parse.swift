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
typealias MangaItemURL = String

func extractMangaList(html: String) -> [(Title, MangaURL)] {
    let a = extractEndMangaList(html: html)
    let b = extractSerialMangaList(html: html)
    
    return a + b
    
}

func extractEndMangaList(html: String) -> [(Title, MangaURL)] {
    do {
        let doc = try HTML(html: html, encoding: .utf8)
        
        return doc.css("#manga-list a").map({ (elm) -> (String, String) in
            return (elm.text!, elm["href"]!)
        })
    } catch {
        return []
    }
}

func extractSerialMangaList(html: String) -> [(Title, MangaURL)] {
    do {
        let doc = try HTML(html: html, encoding: .utf8)
        
        return doc.css("#post .contents a.tx-link").map({ (elm) -> (String, String) in
            return (elm.text!, elm["href"]!)
        })
    } catch {
        return []
    }
}

func extractMangaItem(html: String) -> [(Title, MangaItemURL)] {
    do {
        let doc = try HTML(html: html, encoding: .utf8)
        return doc.css("#post .contents p > a").map({ (elm) -> (String, String) in
            return (elm.text!, elm["href"]!)
        })
    } catch {
        return []
    }
}

func extractMangaContent(html: String) -> [String] {
    do {
        let doc = try HTML(html: html, encoding: .utf8)
        return doc.css("#post .contents img").map({ (elm) -> String in
            return elm["src"]!
        })
    } catch {
        return []
    }
}
