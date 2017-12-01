//
//  MangaItem.swift
//  Zang
//
//  Created by drskur on 2017. 6. 20..
//  Copyright © 2017년 drskur. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import Alamofire


class MangaItem: Object {
    @objc dynamic var manga: Manga!
    @objc dynamic var title = ""
    @objc dynamic var url = ""
    @objc dynamic var isMangaDirection = false
    @objc dynamic var pageIndex = 0
    @objc dynamic var pageSecondIndex = 0
}

func fetchMangaItemList(manga: Manga) -> Observable<[(Title, MangaURL)]> {
    let realm = try! Realm()
    
    return Observable.create { (observer) -> Disposable in
        let req = Alamofire.request(manga.url).responseString { (res) in
            res.result
                .map(extractMangaItem)
                .withValue({ (values) in
                    try! realm.write {
                        for (title, url) in values {
                            realm.add(MangaItem(value: ["title": title, "url": url, "manga": manga]))
                        }
                    }
                    observer.onNext(values)
                    observer.onCompleted()
                }).withError(observer.onError)
        }
        
        return Disposables.create(with: req.cancel)
    }
    
}
