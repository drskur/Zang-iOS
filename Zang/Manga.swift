//
//  Manga.swift
//  Zang
//
//  Created by drskur on 2017. 6. 19..
//  Copyright © 2017년 drskur. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import Alamofire


class Manga: Object {
    dynamic var title = ""
    dynamic var url = ""
}

func fetchMangaList() -> Observable<[(Title, MangaURL)]> {
    let realm = try! Realm()
    
    return Observable.create { (observer) -> Disposable in
        let req = Alamofire.request("http://zangsisi.net").responseString { (res) in
            res.result
                .map(extractMangaList)
                .withValue({ (values) in
                    try! realm.write {
                        for (title, url) in values {
                            realm.add(Manga(value: ["title": title, "url": url]))
                        }
                    }
                    observer.onNext(values)
                    observer.onCompleted()
                })
            
        }
        
        return Disposables.create(with: req.cancel)
    }

}
