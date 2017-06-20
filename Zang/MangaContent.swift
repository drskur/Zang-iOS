//
//  MangaContent.swift
//  Zang
//
//  Created by drskur on 2017. 6. 20..
//  Copyright © 2017년 drskur. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import Alamofire


class MangaContent: Object {
    dynamic var mangaItem: MangaItem!
    dynamic var imageUrl = ""
}

func fetchMangaContentsList(mangaItem: MangaItem) -> Observable<[String]> {
    let realm = try! Realm()
    
    return Observable.create { (observer) -> Disposable in
        let req = Alamofire.request(mangaItem.url).responseString { (res) in
            res.result
                .map(extractMangaContent)
                .withValue({ (values) in
                    try! realm.write {
                        for url in values {
                            realm.add(MangaContent(value: ["imageUrl": url, "mangaItem": mangaItem]))
                        }
                    }
                    observer.onNext(values)
                    observer.onCompleted()
                }).withError(observer.onError)
        }
        
        return Disposables.create(with: req.cancel)
    }
    
}

func loadMangaContent(url: String) -> Observable<UIImage> {
    return Observable.create { (observer) -> Disposable in
        
        let req = Alamofire.request(url).responseData(completionHandler: { (res) in
            res.result
                .withValue({ (data) in
                    observer.onNext(UIImage(data: data)!)
                    observer.onCompleted()
                }).withError(observer.onError)
        })
        
        
        return Disposables.create(with: req.cancel)
    }
}
