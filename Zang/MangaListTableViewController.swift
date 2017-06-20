//
//  MangaListTableViewController.swift
//  Zang
//
//  Created by drskur on 2017. 6. 19..
//  Copyright © 2017년 drskur. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import RxSwift

class MangaListTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var mangas: Results<Manga>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mangas = realm.objects(Manga.self).sorted(byKeyPath: "title", ascending: true)
        
        if mangas.isEmpty {
            let _ = fetchMangaList().subscribe(onCompleted: {
                self.tableView.reloadData()
            })
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MangaCell", for: indexPath)
        
        let manga = mangas[indexPath.row]
        cell.textLabel?.text = manga.title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let manga = mangas[indexPath.row]
        
        self.performSegue(withIdentifier: "ShowMangaItem", sender: manga)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "ShowMangaItem":
            if let vc = segue.destination as? MangaItemListTableViewController {
                vc.manga = sender as! Manga
            }
            
        default:
            break
            
        }
    }

}
