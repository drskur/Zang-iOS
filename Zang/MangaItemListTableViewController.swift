//
//  MangaItemListTableViewController.swift
//  Zang
//
//  Created by drskur on 2017. 6. 20..
//  Copyright © 2017년 drskur. All rights reserved.
//

import UIKit
import RealmSwift

class MangaItemListTableViewController: UITableViewController {
    
    var manga: Manga!
    let realm = try! Realm()
    var mangaItems: Results<MangaItem>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnTap = false
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = manga.title
        mangaItems = realm.objects(MangaItem.self).filter("manga == %@", manga)
        
        if (mangaItems.isEmpty) {
            let _ = fetchMangaItemList(manga: manga).subscribe(onCompleted: {
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangaItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MangaItemCell", for: indexPath) as! MangaItemCell
        
        let item = mangaItems[indexPath.row]
        cell.mangaNameLabel.text = item.title
        
        if (item.pageIndex != 0) {
            cell.setRead(true)
        }
        
        if (item.pageIndex >= item.pages - 1) {
            cell.setFinish(true)
        } else {
            cell.setFinish(false)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = mangaItems[indexPath.row]
        
        self.performSegue(withIdentifier: "ShowMangaContents", sender: item)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "ShowMangaContents":
            if let vc = segue.destination as? MangaContentsViewController {
                vc.mangaItem = sender as! MangaItem
            }
        default:
            break
        }
    }

}
