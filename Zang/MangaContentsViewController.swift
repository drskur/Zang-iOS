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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = mangaItem.title
        
        mangaContent = realm.objects(MangaContent.self).filter("mangaItem == %@", mangaItem)
        
        pageVC.view.frame = CGRect(x: 0, y: 30, width: self.view.frame.size.width, height: self.view.frame.size.height - 30)
        
        
        if mangaContent.isEmpty {
            let _ = fetchMangaContentsList(mangaItem: mangaItem).subscribe(onCompleted: {
                self.pageVC.setViewControllers([self.mkViewController(content: self.mangaContent.first!, splitImages: nil, index: 1, secondIndex: 1)], direction: .forward, animated: true, completion: nil)
            })
        } else {
            pageVC.setViewControllers([mkViewController(content: mangaContent.first!, splitImages: nil, index: 1, secondIndex: 1)], direction: .forward, animated: true, completion: nil)
        }
        
        self.addChildViewController(pageVC)
        pageVC.dataSource = self
        self.view.addSubview(pageVC.view)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Page View Controller
    
    func mkViewController(content: MangaContent?, splitImages: [UIImage]?, index: Int, secondIndex: Int, backward: Bool = false) -> ContentViewController {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MangaContents") as! ContentViewController
        vc.mangaContent = content
        vc.splitImages = splitImages
        vc.pageIndex = index
        vc.pageSecondIndex = secondIndex
        vc.backward = backward
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        
        if vc.splitImages == nil || vc.pageSecondIndex == 1 {
            let newIndex = vc.pageIndex - 1
            if newIndex >= 1 {
                return mkViewController(content: self.mangaContent[newIndex - 1], splitImages: nil, index: newIndex, secondIndex: 2, backward: true)
            }
        } else {
            return mkViewController(content: nil, splitImages: vc.splitImages, index: vc.pageIndex, secondIndex: 1, backward: true)
        }
        

        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        
        if vc.splitImages == nil || vc.pageSecondIndex >= 2 {
            let newIndex = vc.pageIndex + 1
            if self.mangaContent.count >= newIndex {
                return mkViewController(content: self.mangaContent[newIndex - 1], splitImages: nil, index: newIndex, secondIndex: 1)
            }
        } else {
            return mkViewController(content: nil, splitImages: vc.splitImages, index: vc.pageIndex, secondIndex: 2)
        }
        
        return nil
    }

}
