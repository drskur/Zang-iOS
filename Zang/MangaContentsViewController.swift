//
//  MangaContentsViewController.swift
//  Zang
//
//  Created by drskur on 2017. 6. 20..
//  Copyright © 2017년 drskur. All rights reserved.
//

import UIKit
import RealmSwift

class MangaContentsViewController: UIViewController, UIPageViewControllerDataSource {
    
    var mangaItem: MangaItem!
    let realm = try! Realm()
    var mangaContent: Results<MangaContent>!
    
    let pageVC = UIPageViewController()

    @IBOutlet weak var directionButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = mangaItem.title
        self.navigationController?.hidesBarsOnTap = true
        
        mangaContent = realm.objects(MangaContent.self).filter("mangaItem == %@", mangaItem)
        
        setupPageViewController()
        setupDirectionButtion()
    }
    
    func setupDirectionButtion() {
        if mangaItem.isMangaDirection {
            directionButton.title = "역순모드"
        } else {
            directionButton.title = "일반모드"
        }
    }
    
    func setupPageViewController() {
        pageVC.view.frame = self.view.frame
        
        
        if mangaContent.isEmpty {
            let _ = fetchMangaContentsList(mangaItem: mangaItem).subscribe(onCompleted: {
                self.pageVC.setViewControllers([self.mkViewController(content: self.mangaContent.first!, splitImages: nil, index: 0, secondIndex: 0)], direction: .forward, animated: true, completion: nil)
            })
        } else {
            pageVC.setViewControllers([mkViewController(content: mangaContent.first!, splitImages: nil, index: 0, secondIndex: 0)], direction: .forward, animated: true, completion: nil)
        }
        
        self.addChildViewController(pageVC)
        pageVC.dataSource = self
        self.view.addSubview(pageVC.view)
    }
    
    
    // MARK: - Page View Controller
    
    func mkViewController(content: MangaContent!, splitImages: [UIImage]?, index: Int, secondIndex: Int) -> ContentViewController {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MangaContents") as! ContentViewController
        vc.mangaContent = content
        vc.splitImages = splitImages
        vc.pageIndex = index
        vc.pageSecondIndex = secondIndex
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        

        if mangaItem.isMangaDirection {
            if vc.splitImages == nil || vc.pageSecondIndex == 0 {
                let newIndex = vc.pageIndex + 1
                if self.mangaContent.count >= newIndex + 1 {
                    return mkViewController(content: self.mangaContent[newIndex], splitImages: nil, index: newIndex, secondIndex: 1)
                }
            } else {
                return mkViewController(content: self.mangaContent[vc.pageIndex], splitImages: vc.splitImages, index: vc.pageIndex, secondIndex: 0)
            }
        } else {
            if vc.splitImages == nil || vc.pageSecondIndex == 0 {
                let newIndex = vc.pageIndex - 1
                if newIndex >= 0 {
                    return mkViewController(content: self.mangaContent[newIndex], splitImages: nil, index: newIndex, secondIndex: 1)
                }
            } else {
                return mkViewController(content: self.mangaContent[vc.pageIndex], splitImages: vc.splitImages, index: vc.pageIndex, secondIndex: 0)
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        
        if mangaItem.isMangaDirection {
            if vc.splitImages == nil || vc.pageSecondIndex == 1 {
                let newIndex = vc.pageIndex - 1
                if newIndex >= 0 {
                    return mkViewController(content: self.mangaContent[newIndex], splitImages: nil, index: newIndex, secondIndex: 0)
                }
            } else {
                return mkViewController(content: self.mangaContent[vc.pageIndex], splitImages: vc.splitImages, index: vc.pageIndex, secondIndex: 1)
            }
        } else {
            if vc.splitImages == nil || vc.pageSecondIndex == 1 {
                let newIndex = vc.pageIndex + 1
                if self.mangaContent.count >= newIndex + 1 {
                    return mkViewController(content: self.mangaContent[newIndex], splitImages: nil, index: newIndex, secondIndex: 0)
                }
            } else {
                return mkViewController(content: self.mangaContent[vc.pageIndex], splitImages: vc.splitImages, index: vc.pageIndex, secondIndex: 1)
            }
        }
        
        return nil
    }

    @IBAction func pressedDirectionButton(_ sender: UIBarButtonItem) {
        try! realm.write {
            self.mangaItem.isMangaDirection = !self.mangaItem.isMangaDirection
        }
        setupDirectionButtion()
    }
}
