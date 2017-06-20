//
//  ContentViewController.swift
//  Zang
//
//  Created by drskur on 2017. 6. 20..
//  Copyright © 2017년 drskur. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    var pageIndex: Int!
    var pageSecondIndex: Int!
    var mangaContent: MangaContent?
    var backward = false
    
    var splitImages: [UIImage]?
    

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let images = self.splitImages {
            self.imageView.image = images[self.pageSecondIndex - 1]
        } else {
            let _ = loadMangaContent(url: mangaContent!.imageUrl)
                .subscribe(onNext: { (image) in
                    if image.size.width > image.size.height {
                        self.splitImages = self.splitImage(image: image)
                        if self.backward {
                            self.imageView.image = self.splitImages![1]
                        } else {
                            self.imageView.image = self.splitImages![self.pageSecondIndex - 1]
                        }
                    } else {
                        self.imageView.image = image
                    }
                })
        }
    }
    
    func splitImage(image: UIImage) -> [UIImage] {
        let left = CGRect(x: 0, y: 0, width: image.size.width / 2.0, height: image.size.height)
        let right = CGRect(x: image.size.width / 2.0, y: 0, width: image.size.width / 2.0, height: image.size.height)
        
        let leftRef = image.cgImage!.cropping(to: left)
        let rightRef = image.cgImage!.cropping(to: right)
        
        
        return [UIImage(cgImage: leftRef!), UIImage(cgImage: rightRef!)]
    }
}
