//
//  Manga.swift
//  Zang
//
//  Created by drskur on 2017. 6. 19..
//  Copyright © 2017년 drskur. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

class Manga: Object {
    dynamic var title = ""
    dynamic var url = ""
}

func fetchMangaList () {
    let realm = try! Realm()
    
    Alamofire.request("http://zangsisi.net").responseString { (res) in
        res.result
            .map(extractMangaList)
            .withValue({ (values) in
                try! realm.write {
                    for (title, url) in values {
                        realm.add(Manga(value: ["title": title, "url": url]))
                    }
                }
            })
    }
}
